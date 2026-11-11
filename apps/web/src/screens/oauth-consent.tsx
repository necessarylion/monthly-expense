import { ShieldCheckIcon } from 'lucide-react'
import { useEffect, useState } from 'react'
import { Button } from '@/components/ui/button'
import { api } from '@/lib/api'
import { errorMessage } from '@/lib/errors'
import { useT } from '@/lib/i18n'
import { useAuth } from '@/stores/auth'

/** The page an MCP client (like Claude) sends the browser to, to sign in. */
export const OAUTH_CONSENT_PATH = '/oauth/authorize'

interface AskingClient {
  name: string
  /** Where the browser goes after the answer. Shown so the person can check it. */
  redirectHost: string
  /** The user already has the most MCP clients allowed. */
  full: boolean
}

/** The OAuth query of the client, as camelCase fields for the API. */
function readQuery() {
  const q = new URLSearchParams(window.location.search)
  return {
    responseType: q.get('response_type') ?? '',
    clientId: q.get('client_id') ?? '',
    redirectUri: q.get('redirect_uri') ?? '',
    state: q.get('state') ?? undefined,
    codeChallenge: q.get('code_challenge') ?? '',
    codeChallengeMethod: q.get('code_challenge_method') ?? '',
    resource: q.get('resource') ?? undefined,
  }
}

/**
 * Consent for an MCP client. The person is already signed in (App shows the
 * login first). The API checks the client and its redirect address before
 * anything is shown, so the browser is only ever sent to a checked address.
 */
export function OAuthConsentScreen() {
  const t = useT()
  const user = useAuth((s) => s.user)
  const [query] = useState(readQuery)
  const [client, setClient] = useState<AskingClient | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)

  useEffect(() => {
    if (query.responseType !== 'code') {
      setError(t('oauth.badRequest'))
      return
    }
    api
      .get<{ data: AskingClient }>('/oauth/client', {
        params: { client_id: query.clientId, redirect_uri: query.redirectUri },
      })
      .then(({ data }) => setClient(data.data))
      .catch((e) => setError(errorMessage(e, t('oauth.badRequest'))))
  }, [query, t])

  async function answer(allow: boolean) {
    setBusy(true)
    try {
      const { data } = allow
        ? await api.post<{ data: { url: string } }>('/oauth/approve', {
            clientId: query.clientId,
            redirectUri: query.redirectUri,
            codeChallenge: query.codeChallenge,
            codeChallengeMethod: query.codeChallengeMethod,
            state: query.state,
            resource: query.resource,
          })
        : await api.post<{ data: { url: string } }>('/oauth/deny', {
            clientId: query.clientId,
            redirectUri: query.redirectUri,
            state: query.state,
          })
      window.location.assign(data.data.url)
    } catch (e) {
      setError(errorMessage(e, t('oauth.failed')))
      setBusy(false)
    }
  }

  return (
    <main className="flex min-h-dvh flex-col bg-background px-6 pt-safe pb-safe">
      <div className="mx-auto flex w-full max-w-sm flex-1 flex-col justify-center gap-6">
        <div className="flex flex-col items-center gap-3 text-center">
          <span className="flex size-14 items-center justify-center rounded-lg bg-primary/10 text-primary">
            <ShieldCheckIcon className="size-7" />
          </span>
          <h1 className="text-xl font-semibold">
            {client ? t('oauth.title', { client: client.name }) : t('oauth.titleLoading')}
          </h1>
          {user && <p className="text-sm text-muted-foreground">{t('oauth.signedInAs', { email: user.email })}</p>}
        </div>

        {error && <p className="rounded-lg bg-destructive/10 p-3 text-sm text-destructive">{error}</p>}

        {client && !error && (
          <>
            <ul className="flex flex-col gap-2 text-sm">
              <li>{t('oauth.canRead')}</li>
              <li>{t('oauth.canWrite')}</li>
              <li className="text-muted-foreground">{t('oauth.revokeNote')}</li>
            </ul>
            <div className="rounded-lg border p-3 text-sm">
              <p className="text-muted-foreground">{t('oauth.returnsTo')}</p>
              <p className="font-mono font-medium break-all">{client.redirectHost}</p>
            </div>
            {client.full && <p className="text-sm text-destructive">{t('oauth.full')}</p>}
            <div className="flex gap-2">
              <Button variant="outline" className="h-12 flex-1 rounded-lg" disabled={busy} onClick={() => void answer(false)}>
                {t('oauth.deny')}
              </Button>
              <Button className="h-12 flex-1 rounded-lg" disabled={busy || client.full} onClick={() => void answer(true)}>
                {t('oauth.allow')}
              </Button>
            </div>
          </>
        )}
      </div>
    </main>
  )
}
