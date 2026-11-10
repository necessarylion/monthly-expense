import { initializeApp } from 'firebase/app'
import {
  getAuth,
  GoogleAuthProvider,
  signInWithPopup,
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  sendEmailVerification,
  sendPasswordResetEmail,
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

/**
 * Signs in (or makes the account when `create` is set). Returns false when
 * the email is not verified yet: it then sends the verify link and signs
 * out again, because the API refuses an email that is not verified.
 */
export async function signInWithEmail(email: string, password: string, create: boolean): Promise<boolean> {
  const { user } = create
    ? await createUserWithEmailAndPassword(auth, email, password)
    : await signInWithEmailAndPassword(auth, email, password)
  if (user.emailVerified) return true
  try {
    await sendEmailVerification(user)
  } finally {
    await fbSignOut(auth)
  }
  return false
}

export async function resetPassword(email: string) {
  await sendPasswordResetEmail(auth, email)
}

export async function signOut() {
  await fbSignOut(auth)
}

export function onAuthChange(cb: (user: FirebaseUser | null) => void) {
  // A user whose email is not verified counts as signed out (see signInWithEmail).
  return onIdTokenChanged(auth, (user) => cb(user?.email && !user.emailVerified ? null : user))
}
