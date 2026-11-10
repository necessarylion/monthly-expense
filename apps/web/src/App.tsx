import { useEffect, useState } from 'react'
import { Toaster } from '@/components/ui/toast'
import { TooltipProvider } from '@/components/ui/tooltip'
import { Dashboard } from '@/screens/dashboard'
import { LoginScreen } from '@/screens/login'
import { OAUTH_CONSENT_PATH, OAuthConsentScreen } from '@/screens/oauth-consent'
import { SplashScreen } from '@/screens/splash'
import { useAuth } from '@/stores/auth'

/**
 * The splash covers the cold start: Firebase, then /me. Groups and the first
 * month load behind the dashboard. It latches off for good.
 */
function useBooted(): boolean {
  const [booted, setBooted] = useState(false)
  const loading = useAuth((s) => s.loading)
  const booting = useAuth((s) => s.booting)

  if (!loading && !booting && !booted) setBooted(true)

  useEffect(() => {
    // ponytail: hard cap so a hung request never strands the user on the splash.
    // It outlasts the auth store's 8s Firebase give-up.
    const timer = setTimeout(() => setBooted(true), 12000)
    return () => clearTimeout(timer)
  }, [])

  return booted
}

/** An MCP client sent the browser here to sign in. No router: the path is read once. */
const IS_CONSENT = window.location.pathname === OAUTH_CONSENT_PATH

export function App() {
  const loading = useAuth((s) => s.loading)
  const user = useAuth((s) => s.user)
  const mfaRequired = useAuth((s) => s.mfaRequired)
  const booted = useBooted()
  // The consent page loads no month, so it only waits for Firebase.
  const showSplash = IS_CONSENT ? loading : !booted

  useEffect(() => {
    function onUnauthorized() {
      void useAuth.getState().logout()
    }
    window.addEventListener('auth:unauthorized', onUnauthorized)
    return () => window.removeEventListener('auth:unauthorized', onUnauthorized)
  }, [])

  return (
    <TooltipProvider>
      {/* Mounted behind the splash, so the dashboard's first fetches start right away. */}
      {/* The login screen also asks for the two-step code. */}
      {!loading && (user && !mfaRequired ? IS_CONSENT ? <OAuthConsentScreen /> : <Dashboard /> : <LoginScreen />)}
      {showSplash && <SplashScreen />}
      <Toaster position="top-center" />
    </TooltipProvider>
  )
}
