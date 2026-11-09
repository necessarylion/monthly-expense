import { create } from 'zustand'
import { api, getActiveGroupId } from '@/lib/api'
import { onAuthChange, signInWithGoogle, signOut } from '@/lib/firebase'
import type { McpClient, User } from '@/lib/types'
import { useAccounts } from './accounts'
import { useGroups } from './groups'

/** Placeholder backend id while /me is still in flight; never matches a real row. */
const PENDING_ID = -1

interface AuthState {
  user: User | null
  loading: boolean
  /** True until the cold-start fetches (/me, /groups) have settled. Drives the splash. */
  booting: boolean
  error: string | null
  mcpUrl: string | null
  /** MCP clients that signed in with OAuth. */
  mcpClients: McpClient[]
  watch(): void
  login(): Promise<void>
  logout(): Promise<void>
  refreshMe(): Promise<void>
  loadMcpUrl(): Promise<void>
  /** Signs out every MCP client. */
  revokeAllMcpClients(): Promise<void>
  revokeMcpClient(id: number): Promise<void>
}

interface McpInfo {
  url: string
  clients?: McpClient[]
}

export const useAuth = create<AuthState>((set, get) => ({
  user: null,
  loading: true,
  booting: true,
  error: null,
  mcpUrl: null,
  mcpClients: [],

  async refreshMe() {
    try {
      const { data } = await api.get<{ data: User }>('/me')
      set({ user: data.data })
    } catch (e: any) {
      // Keep `user` as is. Firebase decides "signed in"; a real 401 fires
      // `auth:unauthorized`, which App turns into a logout.
      set({ error: e?.message ?? 'Failed to load profile' })
    }
  },

  async loadMcpUrl() {
    const { data } = await api.get<{ data: McpInfo }>('/me/mcp')
    set({ mcpUrl: data.data.url, mcpClients: data.data.clients ?? [] })
  },

  async revokeAllMcpClients() {
    const { data } = await api.post<{ data: McpInfo }>('/me/mcp/rotate')
    set({ mcpUrl: data.data.url, mcpClients: data.data.clients ?? [] })
  },

  async revokeMcpClient(id) {
    await api.delete(`/me/mcp/clients/${id}`)
    set({ mcpClients: get().mcpClients.filter((c) => c.id !== id) })
  },

  watch() {
    let hydratedUid: string | null = null

    // Offline or behind a blocking proxy Firebase never calls back. Give up
    // and treat it as signed out; the listener still fires later if a session shows up.
    const giveUp = setTimeout(() => set({ loading: false, booting: false }), 8000)

    onAuthChange(async (fbUser) => {
      clearTimeout(giveUp)
      if (!fbUser) {
        hydratedUid = null
        useGroups.getState().reset()
        set({ user: null, loading: false, booting: false })
        return
      }

      // Paint now from the Firebase user; only the backend `id` waits for /me.
      if (get().user?.firebaseUid !== fbUser.uid) {
        set({
          user: {
            id: PENDING_ID,
            firebaseUid: fbUser.uid,
            email: fbUser.email ?? '',
            displayName: fbUser.displayName,
            photoUrl: fbUser.photoURL,
          },
        })
      }
      set({ loading: false })

      // onIdTokenChanged also fires on every hourly token refresh.
      if (hydratedUid === fbUser.uid) return
      hydratedUid = fbUser.uid

      const groups = useGroups.getState()
      if (getActiveGroupId() !== null) {
        // Returning user: already provisioned server-side, so /me and /groups can race.
        void Promise.all([get().refreshMe(), groups.load()]).finally(() => set({ booting: false }))
      } else {
        // ponytail: first login stays serial; user provisioning on the server is not concurrency safe.
        await get().refreshMe()
        if (get().user) await groups.load()
        set({ booting: false })
      }
    })
  },

  async login() {
    set({ error: null })
    try {
      await signInWithGoogle()
    } catch (e: any) {
      set({ error: e?.message ?? 'Sign-in failed' })
    }
  },

  async logout() {
    await signOut()
    set({ user: null, mcpUrl: null, mcpClients: [] })
    useGroups.getState().reset()
    // Accounts are user-owned; clear them so the next sign-in can't see old balances.
    useAccounts.getState().clear()
  },
}))
