import { create } from 'zustand'
import { api, getActiveGroupId } from '@/lib/api'
import {
  onAuthChange,
  resetPassword,
  signInWithEmail,
  signInWithGoogle,
  signInWithToken,
  signOut,
} from '@/lib/firebase'
import { errorMessage } from '@/lib/errors'
import { t } from '@/lib/i18n'
import { startLive, stopLive } from '@/lib/live'
import { signInWithPasskeyToken } from '@/lib/passkey'
import type { McpClient, User } from '@/lib/types'
import { useAccounts } from './accounts'
import { useGroups } from './groups'

/** Placeholder backend id while /me is still in flight; never matches a real row. */
const PENDING_ID = -1

interface AuthState {
  user: User | null
  loading: boolean
  /** True until the cold-start /me has settled. Drives the splash. */
  booting: boolean
  error: string | null
  /** Signed in, but the API still wants the code from the authenticator app. */
  mfaRequired: boolean
  mcpUrl: string | null
  /** MCP clients that signed in with OAuth. */
  mcpClients: McpClient[]
  watch(): void
  login(): Promise<void>
  loginWithPasskey(): Promise<void>
  /** Returns 'verify' when a verify link was sent instead of signing in. */
  loginWithEmail(email: string, password: string, create: boolean): Promise<'ok' | 'verify' | 'error'>
  /** Sends a password reset link. Returns false on an error. */
  sendPasswordReset(email: string): Promise<boolean>
  /** Sends the two-step code. The page reloads when it is right. */
  verifyMfa(code: string): Promise<void>
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

/** Firebase errors look like "Firebase: Error (auth/...)". Show our own text for the known codes. */
function authError(e: any): string {
  const key = `app.authError.${String(e?.code).replace('auth/', '')}`
  const text = t(key)
  return text === key ? (e?.message ?? 'Sign-in failed') : text
}

export const useAuth = create<AuthState>((set, get) => ({
  user: null,
  loading: true,
  booting: true,
  error: null,
  mfaRequired: false,
  mcpUrl: null,
  mcpClients: [],

  async refreshMe() {
    try {
      const { data } = await api.get<{ data: User }>('/me')
      set({ user: data.data })
    } catch (e: any) {
      // Step one passed, but this user has two-step sign-in on: ask for the code.
      if (e?.response?.data?.code === 'mfa_required') return set({ mfaRequired: true })
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
        stopLive()
        useGroups.getState().reset()
        set({ user: null, mfaRequired: false, loading: false, booting: false })
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
      startLive()

      const groups = useGroups.getState()
      // Returning user: already provisioned server-side, so /me and /groups can race.
      const returning = getActiveGroupId() !== null
      if (returning) void groups.load()
      await get().refreshMe()
      // The splash only waits for /me. Groups and the month fill in after.
      set({ booting: false })
      // ponytail: first login stays serial; user provisioning on the server is not concurrency safe.
      if (!returning && get().user) await groups.load()
    })
  },

  async login() {
    set({ error: null })
    try {
      await signInWithGoogle()
    } catch (e: any) {
      set({ error: authError(e) })
    }
  },

  async loginWithPasskey() {
    set({ error: null })
    try {
      await signInWithToken(await signInWithPasskeyToken())
    } catch (e: any) {
      // The user closed the browser's passkey prompt: not an error.
      if (e?.name === 'NotAllowedError' || e?.name === 'AbortError') return
      set({ error: authError(e) })
    }
  },

  async loginWithEmail(email, password, create) {
    set({ error: null })
    try {
      return (await signInWithEmail(email, password, create)) ? 'ok' : 'verify'
    } catch (e: any) {
      set({ error: authError(e) })
      return 'error'
    }
  },

  async sendPasswordReset(email) {
    set({ error: null })
    try {
      await resetPassword(email)
      return true
    } catch (e: any) {
      set({ error: authError(e) })
      return false
    }
  },

  async verifyMfa(code) {
    set({ error: null })
    try {
      const { data } = await api.post<{ data: { token: string } }>('/me/totp/verify', { code })
      await signInWithToken(data.data.token)
      // ponytail: reload instead of restarting every store and the live socket by hand.
      // Firebase keeps the new session, so the app starts clean with it.
      window.location.reload()
    } catch (e: any) {
      set({ error: errorMessage(e, 'Sign-in failed') })
    }
  },

  async logout() {
    await signOut()
    set({ user: null, mfaRequired: false, error: null, mcpUrl: null, mcpClients: [] })
    useGroups.getState().reset()
    // Accounts are user-owned; clear them so the next sign-in can't see old balances.
    useAccounts.getState().clear()
  },
}))
