import { create } from 'zustand'
import { api, getActiveGroupId } from '@/lib/api'
import type { User as FirebaseUser } from 'firebase/auth'
import { errorMessage } from '@/lib/errors'
import { t } from '@/lib/i18n'
import { startLive, stopLive } from '@/lib/live'
import { signInWithPasskeyToken } from '@/lib/passkey'
import {
  clearSession,
  getApiToken,
  getCachedUser,
  setApiToken,
  setCachedUser,
  tokenNeedsRefresh,
} from '@/lib/session'
import type { McpClient, User } from '@/lib/types'
import { useAccounts } from './accounts'
import { useGroups } from './groups'

/**
 * Sign-in: Firebase (Google, or email and password) once, then the API
 * trades its ID token for our own API token (`POST /auth/token`). A passkey
 * gives an API token directly. Every call after sends the API token, which
 * is kept across reloads (`lib/session.ts`): a returning user's data starts
 * loading at once, with no wait for Firebase.
 *
 * Firebase is used only to sign in. Right after the trade the app signs out
 * of it, and renews the API token itself (`POST /auth/token/refresh`). The
 * Firebase SDK is loaded only when it is needed (the login screen).
 */

let firebaseLoad: Promise<typeof import('@/lib/firebase')> | null = null

/** The Firebase SDK, loaded on first use. Its listener trades a new sign-in. */
function firebase() {
  firebaseLoad ??= import('@/lib/firebase').then((fb) => {
    fb.onAuthChange(onFirebaseUser)
    return fb
  })
  return firebaseLoad
}

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
  /** Sends the two-step code. Signs in when it is right. */
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
      setCachedUser(data.data)
      set({ user: data.data, mfaRequired: false })
    } catch (e: any) {
      // Signed in, but this user has two-step sign-in on: ask for the code.
      if (e?.response?.data?.code === 'mfa_required') return set({ mfaRequired: true })
      // Keep `user` as is. A real 401 fires `auth:unauthorized`, which App turns into a logout.
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
    // Keep the API token fresh while the app is open.
    document.addEventListener('visibilitychange', () => {
      if (document.visibilityState === 'visible') void refreshToken()
    })
    setInterval(() => void refreshToken(), 60 * 60 * 1000)

    // Signed in before: paint from the last /me and load right away. No Firebase.
    if (getApiToken()) {
      const cached = getCachedUser()
      if (cached) set({ user: cached, loading: false })
      void start()
      return
    }

    // Signed out: load Firebase. It may still hold a session from before
    // API tokens; its listener trades that. Offline or behind a blocking
    // proxy Firebase never calls back, so give up and show the login.
    giveUp = setTimeout(() => set({ loading: false, booting: false }), 8000)
    void firebase()
  },

  async login() {
    set({ error: null })
    try {
      await (await firebase()).signInWithGoogle()
    } catch (e: any) {
      set({ error: authError(e) })
    }
  },

  async loginWithPasskey() {
    set({ error: null })
    try {
      setApiToken(await signInWithPasskeyToken())
      await start()
    } catch (e: any) {
      // The user closed the browser's passkey prompt: not an error.
      if (e?.name === 'NotAllowedError' || e?.name === 'AbortError') return
      set({ error: authError(e) })
    }
  },

  async loginWithEmail(email, password, create) {
    set({ error: null })
    try {
      return (await (await firebase()).signInWithEmail(email, password, create)) ? 'ok' : 'verify'
    } catch (e: any) {
      set({ error: authError(e) })
      return 'error'
    }
  },

  async sendPasswordReset(email) {
    set({ error: null })
    try {
      await (await firebase()).resetPassword(email)
      return true
    } catch (e: any) {
      set({ error: authError(e) })
      return false
    }
  },

  async verifyMfa(code) {
    set({ error: null })
    try {
      // Marks this browser's API token: from now on it passes.
      await api.post('/me/totp/verify', { code })
    } catch (e: any) {
      return set({ error: errorMessage(e, 'Sign-in failed') })
    }
    set({ mfaRequired: false })
    // The socket was refused while the code was missing.
    stopLive()
    started = false
    await start()
  },

  async logout() {
    const token = getApiToken()
    clearSession()
    stopLive()
    started = false
    set({ user: null, mfaRequired: false, error: null, mcpUrl: null, mcpClients: [], loading: false, booting: false })
    useGroups.getState().reset()
    // Accounts are user-owned; clear them so the next sign-in can't see old balances.
    useAccounts.getState().clear()
    // End the API token on the server too. Already gone after a 401: no matter.
    if (token) void api.delete('/auth/token', { token }).catch(() => {})
    // Normally signed out of Firebase already; this also loads it for the login screen.
    await (await firebase()).signOut().catch(() => {})
  },
}))

let started = false
let exchanging = false
let refreshing = false
let giveUp: ReturnType<typeof setTimeout> | null = null

/** Firebase only matters while there is no API token: right after a Google or email sign-in. */
function onFirebaseUser(fbUser: FirebaseUser | null) {
  if (giveUp) clearTimeout(giveUp)
  giveUp = null
  if (getApiToken() || exchanging) return
  if (!fbUser) return useAuth.setState({ user: null, mfaRequired: false, loading: false, booting: false })
  void exchange(fbUser)
}

/** Trades the API token for a new 30-day one once it is a day old. A 401 signs out (App). */
async function refreshToken() {
  const token = getApiToken()
  if (!token || refreshing || !tokenNeedsRefresh()) return
  refreshing = true
  try {
    const { data } = await api.post<{ data: { token: string } }>('/auth/token/refresh')
    // Signed out meanwhile: drop it.
    if (getApiToken() === token) setApiToken(data.data.token)
  } catch {
    // offline or the server is down: try again later
  } finally {
    refreshing = false
  }
}

/** Signed in (an API token is stored): /me, the groups and the live socket. */
async function start() {
  if (started) return
  started = true
  const auth = useAuth.getState
  startLive()
  const groups = useGroups.getState()
  // Returning user: already provisioned server-side, so /me and /groups can race.
  const returning = getActiveGroupId() !== null
  if (returning) void groups.load()
  await auth().refreshMe()
  // The splash only waits for /me. Groups and the month fill in after.
  useAuth.setState({ loading: false, booting: false })
  void refreshToken()
  // ponytail: first login stays serial; user provisioning on the server is not concurrency safe.
  if (!returning && auth().user && !auth().mfaRequired) await groups.load()
}

/** Trades the Firebase ID token for an API token, once per sign-in. */
async function exchange(fbUser: FirebaseUser) {
  exchanging = true
  useAuth.setState({ error: null })
  try {
    const idToken = await fbUser.getIdToken()
    const { data } = await api.post<{ data: { token: string; user: User } }>('/auth/token', undefined, {
      token: idToken,
    })
    setApiToken(data.data.token)
    // Done with Firebase: from now on the API token renews itself.
    void firebase().then((fb) => fb.signOut()).catch(() => {})
    // With two-step sign-in on, /me decides first whether the code is still needed.
    if (!data.data.user.twoFactorEnabled) {
      setCachedUser(data.data.user)
      useAuth.setState({ user: data.data.user })
    }
    await start()
  } catch (e: any) {
    useAuth.setState({ error: errorMessage(e, 'Sign-in failed'), loading: false, booting: false })
    // Firebase said yes but the API said no (not allowed): sign out of Firebase too.
    if (e?.response?.status === 401) await (await firebase()).signOut().catch(() => {})
  } finally {
    exchanging = false
  }
}
