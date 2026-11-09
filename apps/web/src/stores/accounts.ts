import { create } from 'zustand'
import { api } from '@/lib/api'
import type { Account, AccountEntry, AccountMember } from '@/lib/types'

/**
 * Standalone account balances, owned by or shared with the signed-in user. No group
 * dependency, except the per-group pay-from default.
 */
const PAGE = 10

interface AccountsState {
  accounts: Account[]
  entries: AccountEntry[]
  /** Latest entries across every account (the "Recent" list). */
  recent: AccountEntry[]
  recentHasMore: boolean
  entriesHasMore: boolean
  /** Which account `entries` belongs to; null when no ledger is open. */
  openId: number | null
  loading: boolean
  loaded: boolean
  lastError: string | null
  /** This member's pay-from default in the ACTIVE group (X-Group-Id header). */
  defaultAccountId: number | null

  clear(): void
  loadDefaultAccount(): Promise<void>
  setDefaultAccount(accountId: number | null): Promise<void>
  load(): Promise<void>
  openAccount(id: number): Promise<void>
  closeAccount(): void
  loadEntries(): Promise<void>
  loadMoreRecent(): Promise<void>
  loadMoreEntries(): Promise<void>
  addAccount(payload: {
    name: string
    currency: string
    color: string
    includeInTotal: boolean
  }): Promise<void>
  updateAccount(
    id: number,
    payload: { name?: string; currency?: string; color?: string; includeInTotal?: boolean }
  ): Promise<void>
  deleteAccount(id: number): Promise<void>
  /** `amount` is signed: positive adds to the balance, negative subtracts. */
  addEntry(accountId: number, payload: { amount: number; occurredOn: string; note?: string }): Promise<void>
  /** Set the balance to `balance`; the server books the difference as one entry. */
  adjustBalance(
    accountId: number,
    payload: { balance: number; occurredOn: string; note?: string }
  ): Promise<void>
  updateEntry(
    accountId: number,
    entryId: number,
    payload: { amount?: number; occurredOn?: string; note?: string | null }
  ): Promise<void>
  /** One OUT + one IN entry, created atomically by the server. */
  transfer(payload: {
    fromAccountId: number
    toAccountId: number
    amount: number
    toAmount?: number
    occurredOn: string
    note?: string
  }): Promise<void>
  deleteEntry(accountId: number, entryId: number): Promise<void>
  /** The owner and everyone the wallet is shared with. */
  loadMembers(accountId: number): Promise<AccountMember[]>
  share(accountId: number, email: string): Promise<AccountMember>
  /** Removing your own row leaves the wallet; the list reloads. */
  removeMember(accountId: number, memberId: number): Promise<void>
}

const EMPTY = {
  accounts: [],
  entries: [],
  recent: [],
  recentHasMore: false,
  entriesHasMore: false,
  openId: null,
  lastError: null,
  loaded: false,
  defaultAccountId: null,
}

let loadingMoreRecent = false
let loadingMoreEntries = false

/**
 * Live events can start a reload at any time. Only the newest reload may
 * write, and a "load more" page is dropped when a reload replaced the list
 * meanwhile (its offset no longer fits).
 */
let listRequest = 0
let entriesRequest = 0

export const useAccounts = create<AccountsState>((set, get) => {
  async function reloadAll() {
    await Promise.all([get().load(), get().loadEntries()])
  }

  return {
    ...EMPTY,
    loading: false,

    clear() {
      set(EMPTY)
    },

    async loadDefaultAccount() {
      try {
        const { data } = await api.get<{ data: { accountId: number | null } }>('/default-account')
        set({ defaultAccountId: data.data.accountId })
      } catch {
        set({ defaultAccountId: null })
      }
    },

    async setDefaultAccount(accountId) {
      await api.put('/default-account', { accountId })
      set({ defaultAccountId: accountId })
    },

    async load() {
      const request = ++listRequest
      set({ loading: true, lastError: null })
      try {
        // Refetch what's already on screen (min one page) so reloads don't collapse the list.
        const limit = Math.max(PAGE, get().recent.length)
        const [accRes, recentRes] = await Promise.all([
          api.get<{ data: Account[] }>('/accounts'),
          api.get<{ data: AccountEntry[] }>('/accounts/recent-entries', { params: { limit } }),
        ])
        if (request !== listRequest) return
        set({
          accounts: accRes.data.data,
          recent: recentRes.data.data,
          recentHasMore: recentRes.data.data.length === limit,
          loaded: true,
        })
      } catch (e: any) {
        set({ lastError: e?.response?.data?.message ?? e?.message ?? 'Failed to load accounts' })
      } finally {
        set({ loading: false })
      }
    },

    async openAccount(id) {
      set({ openId: id, entries: [] })
      await get().loadEntries()
    },

    closeAccount() {
      set({ openId: null, entries: [], entriesHasMore: false })
    },

    async loadEntries() {
      const id = get().openId
      if (id === null) return
      const limit = Math.max(PAGE, get().entries.length)
      const request = ++entriesRequest
      set({ loading: true })
      try {
        const { data } = await api.get<{ data: AccountEntry[] }>(`/accounts/${id}/entries`, {
          params: { limit },
        })
        // The user may have backed out (or opened another account) meanwhile.
        if (get().openId === id && request === entriesRequest) {
          set({ entries: data.data, entriesHasMore: data.data.length === limit })
        }
      } catch (e: any) {
        set({ lastError: e?.response?.data?.message ?? e?.message ?? 'Failed to load transactions' })
      } finally {
        set({ loading: false })
      }
    },

    async loadMoreRecent() {
      if (!get().recentHasMore || loadingMoreRecent) return
      loadingMoreRecent = true
      const request = listRequest
      try {
        const { data } = await api.get<{ data: AccountEntry[] }>('/accounts/recent-entries', {
          params: { limit: PAGE, offset: get().recent.length },
        })
        if (request !== listRequest) return
        set({ recent: [...get().recent, ...data.data], recentHasMore: data.data.length === PAGE })
      } finally {
        loadingMoreRecent = false
      }
    },

    async loadMoreEntries() {
      const id = get().openId
      if (id === null || !get().entriesHasMore || loadingMoreEntries) return
      loadingMoreEntries = true
      const request = entriesRequest
      try {
        const { data } = await api.get<{ data: AccountEntry[] }>(`/accounts/${id}/entries`, {
          params: { limit: PAGE, offset: get().entries.length },
        })
        if (get().openId === id && request === entriesRequest) {
          set({
            entries: [...get().entries, ...data.data],
            entriesHasMore: data.data.length === PAGE,
          })
        }
      } finally {
        loadingMoreEntries = false
      }
    },

    async addAccount(payload) {
      await api.post('/accounts', payload)
      await get().load()
    },

    async updateAccount(id, payload) {
      await api.patch(`/accounts/${id}`, payload)
      await get().load()
    },

    async deleteAccount(id) {
      await api.delete(`/accounts/${id}`)
      if (get().openId === id) get().closeAccount()
      await get().load()
    },

    async addEntry(accountId, payload) {
      await api.post(`/accounts/${accountId}/entries`, payload)
      await reloadAll()
    },

    async adjustBalance(accountId, payload) {
      await api.post(`/accounts/${accountId}/adjustments`, payload)
      await reloadAll()
    },

    async updateEntry(accountId, entryId, payload) {
      await api.patch(`/accounts/${accountId}/entries/${entryId}`, payload)
      await reloadAll()
    },

    async transfer(payload) {
      await api.post('/accounts/transfers', payload)
      await reloadAll()
    },

    async deleteEntry(accountId, entryId) {
      await api.delete(`/accounts/${accountId}/entries/${entryId}`)
      await reloadAll()
    },

    async loadMembers(accountId) {
      const { data } = await api.get<{ data: AccountMember[] }>(`/accounts/${accountId}/members`)
      return data.data
    },

    async share(accountId, email) {
      const { data } = await api.post<{ data: AccountMember }>(`/accounts/${accountId}/members`, { email })
      return data.data
    },

    async removeMember(accountId, memberId) {
      await api.delete(`/accounts/${accountId}/members/${memberId}`)
    },
  }
})
