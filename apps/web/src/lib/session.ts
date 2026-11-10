import type { User } from './types'

/**
 * The API token (from `POST /auth/token` or a passkey sign-in) and the last
 * /me answer. Both stay across reloads, so a returning user's first calls
 * go out at once, without waiting for Firebase. Firebase is only the sign-in
 * step; its ID token is never stored.
 */
const TOKEN_KEY = 'monthlyExpense.apiToken'
const USER_KEY = 'monthlyExpense.user'

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

// Read once; storage can be blocked, so keep the token in memory too.
let token: string | null = read(TOKEN_KEY)

export function getApiToken(): string | null {
  return token
}

export function setApiToken(value: string) {
  token = value
  write(TOKEN_KEY, value)
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
  write(USER_KEY, null)
}
