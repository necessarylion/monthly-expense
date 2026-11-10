import type { User } from './types'

/**
 * The API token (from `POST /auth/token` or a passkey sign-in) and the last
 * /me answer. Both stay across reloads, so a returning user's first calls
 * go out at once, without waiting for Firebase. Firebase is only the sign-in
 * step; its ID token is never stored.
 */
const TOKEN_KEY = 'monthlyExpense.apiToken'
const TOKEN_AT_KEY = 'monthlyExpense.apiTokenAt'
const USER_KEY = 'monthlyExpense.user'

/**
 * A token lasts 30 days on the server. Trade it for a new one once it is a
 * day old, so anyone who opens the app within 30 days stays signed in.
 */
const REFRESH_AFTER_MS = 24 * 60 * 60 * 1000

function read(key: string): string | null {
  try {
    return localStorage.getItem(key)
  } catch {
    return null
  }
}

function write(key: string, value: string | null) {
  try {
    if (value === null) localStorage.removeItem(key)
    else localStorage.setItem(key, value)
  } catch {
    // private mode or blocked storage: the session lasts until a reload
  }
}

// Storage can be blocked, so keep the token in memory too.
let token: string | null = read(TOKEN_KEY)

/** Read from storage each time: another tab may have refreshed it. */
export function getApiToken(): string | null {
  return read(TOKEN_KEY) ?? token
}

export function setApiToken(value: string) {
  token = value
  write(TOKEN_KEY, value)
  write(TOKEN_AT_KEY, String(Date.now()))
}

/** The token is a day old (or from before we kept its age). */
export function tokenNeedsRefresh(): boolean {
  const at = Number(read(TOKEN_AT_KEY))
  return !Number.isFinite(at) || at <= 0 || Date.now() - at > REFRESH_AFTER_MS
}

export function getCachedUser(): User | null {
  const raw = read(USER_KEY)
  if (!raw) return null
  try {
    const user = JSON.parse(raw) as User
    return typeof user?.id === 'number' ? user : null
  } catch {
    return null
  }
}

export function setCachedUser(user: User) {
  write(USER_KEY, JSON.stringify(user))
}

export function clearSession() {
  token = null
  write(TOKEN_KEY, null)
  write(TOKEN_AT_KEY, null)
  write(USER_KEY, null)
}
