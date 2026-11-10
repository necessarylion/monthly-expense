import { KeyRoundIcon } from 'lucide-react'
import { useState, type FormEvent } from 'react'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { useT } from '@/lib/i18n'
import { passkeySupported } from '@/lib/passkey'
import { useAuth } from '@/stores/auth'

function GoogleMark() {
  return (
    <svg viewBox="0 0 48 48" className="size-5" aria-hidden="true">
      <path
        fill="#FFC107"
        d="M43.6 20.5H42V20H24v8h11.3C33.7 32.7 29.2 36 24 36c-6.6 0-12-5.4-12-12s5.4-12 12-12c3.1 0 5.8 1.2 7.9 3.1l5.7-5.7C34 6.1 29.3 4 24 4 12.9 4 4 12.9 4 24s8.9 20 20 20 20-8.9 20-20c0-1.3-.1-2.4-.4-3.5z"
      />
      <path
        fill="#FF3D00"
        d="M6.3 14.7l6.6 4.8C14.7 15.1 19 12 24 12c3.1 0 5.8 1.2 7.9 3.1l5.7-5.7C34 6.1 29.3 4 24 4 16.3 4 9.7 8.3 6.3 14.7z"
      />
      <path
        fill="#4CAF50"
        d="M24 44c5.2 0 9.9-2 13.4-5.2l-6.2-5.2C29.2 35.1 26.7 36 24 36c-5.2 0-9.6-3.3-11.3-8l-6.5 5C9.5 39.6 16.2 44 24 44z"
      />
      <path
        fill="#1976D2"
        d="M43.6 20.5H42V20H24v8h11.3c-.8 2.2-2.2 4.2-4.1 5.6l6.2 5.2C37 39.2 44 34 44 24c0-1.3-.1-2.4-.4-3.5z"
      />
    </svg>
  )
}

export function LoginScreen() {
  const t = useT()
  const login = useAuth((s) => s.login)
  const loginWithPasskey = useAuth((s) => s.loginWithPasskey)
  const loginWithEmail = useAuth((s) => s.loginWithEmail)
  const sendPasswordReset = useAuth((s) => s.sendPasswordReset)
  const error = useAuth((s) => s.error)
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [creating, setCreating] = useState(false)
  const [busy, setBusy] = useState(false)
  const [notice, setNotice] = useState<string | null>(null)

  async function submit(e: FormEvent) {
    e.preventDefault()
    setNotice(null)
    setBusy(true)
    const result = await loginWithEmail(email, password, creating)
    setBusy(false)
    if (result !== 'verify') return
    setNotice(t('app.verifySent', { email }))
    setCreating(false)
    setPassword('')
  }

  async function forgot() {
    if (!email) return setNotice(t('app.enterEmail'))
    setNotice(null)
    if (await sendPasswordReset(email)) setNotice(t('app.resetSent', { email }))
  }

  return (
    <main className="relative flex min-h-dvh flex-col overflow-hidden bg-background px-6 pt-safe pb-safe">
      {/* Soft grid backdrop; fades out toward the bottom. */}
      <div
        aria-hidden="true"
        className="pointer-events-none absolute inset-0 [background-image:linear-gradient(var(--border)_1px,transparent_1px),linear-gradient(90deg,var(--border)_1px,transparent_1px)] [background-size:32px_32px] [mask-image:radial-gradient(ellipse_at_top,black,transparent_70%)]"
      />
      <div className="relative mx-auto flex w-full max-w-sm flex-1 flex-col justify-center gap-10">
        <div className="flex flex-col gap-5">
          <img src="/icon.svg" alt="" className="size-14 rounded-2xl shadow-sm" />
          <div className="flex flex-col gap-2">
            <h1 className="text-4xl font-semibold tracking-tight">Monthly Expense</h1>
            <p className="text-lg text-muted-foreground">{t('app.tagline')}</p>
          </div>
        </div>
        <div className="flex flex-col gap-3">
          <form className="flex flex-col gap-3" onSubmit={(e) => void submit(e)}>
            <Input
              type="email"
              required
              autoComplete="email"
              aria-label={t('app.email')}
              placeholder={t('app.email')}
              className="h-12 rounded-xl px-4"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            />
            <Input
              type="password"
              required
              minLength={6}
              autoComplete={creating ? 'new-password' : 'current-password'}
              aria-label={t('app.password')}
              placeholder={t('app.password')}
              className="h-12 rounded-xl px-4"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
            <Button type="submit" size="lg" className="h-12 rounded-xl text-base" disabled={busy}>
              {t(creating ? 'app.createAccount' : 'app.signInEmail')}
            </Button>
            <div className="flex justify-between text-sm text-muted-foreground">
              <button type="button" className="underline-offset-4 hover:underline" onClick={() => setCreating(!creating)}>
                {t(creating ? 'app.haveAccount' : 'app.createAccount')}
              </button>
              {!creating && (
                <button type="button" className="underline-offset-4 hover:underline" onClick={() => void forgot()}>
                  {t('app.forgotPassword')}
                </button>
              )}
            </div>
          </form>
          {notice && (
            <p role="status" className="text-sm text-muted-foreground">
              {notice}
            </p>
          )}
          <div className="flex items-center gap-3 text-sm text-muted-foreground">
            <span className="h-px flex-1 bg-border" />
            {t('app.or')}
            <span className="h-px flex-1 bg-border" />
          </div>
          <Button size="lg" variant="outline" className="h-12 rounded-xl text-base" onClick={() => void login()}>
            <GoogleMark />
            {t('app.signIn')}
          </Button>
          {passkeySupported && (
            <Button size="lg" variant="ghost" className="h-12 rounded-xl text-base" onClick={() => void loginWithPasskey()}>
              <KeyRoundIcon />
              {t('app.signInPasskey')}
            </Button>
          )}
          {error && (
            <p role="alert" className="text-sm text-destructive">
              {error}
            </p>
          )}
        </div>
      </div>
    </main>
  )
}
