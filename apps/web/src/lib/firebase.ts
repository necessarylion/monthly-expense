import { initializeApp } from 'firebase/app'
import {
  getAuth,
  GoogleAuthProvider,
  signInWithPopup,
  signInWithCustomToken,
  signOut as fbSignOut,
  onIdTokenChanged,
  type User as FirebaseUser,
} from 'firebase/auth'

declare global {
  interface Window {
    // Set by `/config.js`, which the API makes from its env (see index.html).
    __APP_CONFIG__?: { apiKey: string; authDomain: string; projectId: string; appId: string }
  }
}

const app = initializeApp(window.__APP_CONFIG__ ?? {})

export const auth = getAuth(app)
const googleProvider = new GoogleAuthProvider()

export async function signInWithGoogle() {
  await signInWithPopup(auth, googleProvider)
}

/** After a passkey sign-in: the API gives a custom token for the user. */
export async function signInWithToken(token: string) {
  await signInWithCustomToken(auth, token)
}

export async function signOut() {
  await fbSignOut(auth)
}

export function onAuthChange(cb: (user: FirebaseUser | null) => void) {
  return onIdTokenChanged(auth, cb)
}

export async function getIdToken(): Promise<string | null> {
  const u = auth.currentUser
  return u ? u.getIdToken() : null
}
