import { create } from 'zustand'
import { api, getActiveGroupId, setActiveGroupId } from '@/lib/api'
import type { Group, GroupMember, GroupKind } from '@/lib/types'

interface GroupsState {
  groups: Group[]
  activeId: number | null
  members: GroupMember[]
  loading: boolean
  lastError: string | null
  load(): Promise<void>
  setActive(id: number): void
  create(payload: { name: string; currency?: string; kind?: GroupKind; tripStart?: string; tripDays?: number }): Promise<Group>
  update(id: number, payload: { name?: string; currency?: string; splitEnabled?: boolean; kind?: GroupKind; tripStart?: string; tripDays?: number }): Promise<Group>
  setBudget(
    id: number,
    month: string,
    budget: number | null
  ): Promise<{ month: string; monthlyBudgetCents: number | null }>
  loadMembers(id: number): Promise<void>
  invite(id: number, email: string): Promise<GroupMember>
  removeMember(id: number, memberId: number): Promise<void>
  leave(id: number): Promise<void>
  reset(): void
}

function persistActive(id: number | null): number | null {
  setActiveGroupId(id)
  return id
}

export const useGroups = create<GroupsState>((set, get) => ({
  groups: [],
  activeId: getActiveGroupId(),
  members: [],
  loading: false,
  lastError: null,

  async load() {
    set({ loading: true, lastError: null })
    try {
      const { data } = await api.get<{ data: Group[] }>('/groups')
      const groups = data.data
      let activeId = get().activeId
      // Keep the saved group if it still exists, else fall back to the first one.
      if (!activeId || !groups.some((g) => g.id === activeId)) {
        activeId = persistActive(groups[0]?.id ?? null)
      }
      set({ groups, activeId })
    } catch (e: any) {
      set({ lastError: e?.message ?? 'Failed to load groups' })
    } finally {
      set({ loading: false })
    }
  },

  setActive(id) {
    set({ activeId: persistActive(id) })
  },

  async create(payload) {
    const { data } = await api.post<{ data: Group }>('/groups', payload)
    set({ groups: [...get().groups, data.data], activeId: persistActive(data.data.id) })
    return data.data
  },

  async update(id, payload) {
    const { data } = await api.patch<{ data: Group }>(`/groups/${id}`, payload)
    set({ groups: get().groups.map((g) => (g.id === id ? data.data : g)) })
    return data.data
  },

  async setBudget(id, month, budget) {
    const { data } = await api.put<{ data: { month: string; monthlyBudgetCents: number | null } }>(
      `/groups/${id}/budget`,
      { month, budget }
    )
    return data.data
  },

  async loadMembers(id) {
    const { data } = await api.get<{ data: GroupMember[] }>(`/groups/${id}/members`)
    set({ members: data.data })
  },

  async invite(id, email) {
    const { data } = await api.post<{ data: GroupMember }>(`/groups/${id}/invitations`, { email })
    set({ members: [...get().members, data.data] })
    return data.data
  },

  async removeMember(id, memberId) {
    await api.delete(`/groups/${id}/members/${memberId}`)
    set({ members: get().members.filter((m) => m.id !== memberId) })
  },

  async leave(id) {
    await api.delete(`/groups/${id}/membership`)
    const groups = get().groups.filter((g) => g.id !== id)
    const activeId = get().activeId === id ? persistActive(groups[0]?.id ?? null) : get().activeId
    set({ groups, activeId })
  },

  reset() {
    set({ groups: [], members: [], activeId: persistActive(null) })
  },
}))

export function useActiveGroup(): Group | null {
  return useGroups((s) => s.groups.find((g) => g.id === s.activeId) ?? null)
}
