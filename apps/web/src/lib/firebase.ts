import { initializeApp } from 'firebase/app'
import {
  getAuth,
  GoogleAuthProvider,
  signInWithPopup,
  signOut as fbSignOut,
  onIdTokenChanged,
  type User as FirebaseUser,
} from 'firebase/auth'

const app = initializeApp({
  apiKey: import.meta.env.VITE_FIREBASE_API_KEY,
  authDomain: import.meta.env.VITE_FIREBASE_AUTH_DOMAIN,
  projectId: import.meta.env.VITE_FIREBASE_PROJECT_ID,
  appId: import.meta.env.VITE_FIREBASE_APP_ID,
})

export const auth = getAuth(app)
const googleProvider = new GoogleAuthProvider()

export async function signInWithGoogle() {
  await signInWithPopup(auth, googleProvider)
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
