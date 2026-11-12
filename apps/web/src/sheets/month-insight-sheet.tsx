import { SparklesIcon } from 'lucide-react'
import { useEffect, useState } from 'react'
import { A2uiView } from '@/components/app/a2ui-view'
import { Sheet } from '@/components/app/sheet'
import { Button } from '@/components/ui/button'
import { api } from '@/lib/api'
import { errorMessage } from '@/lib/errors'
import { useLocale, useT } from '@/lib/i18n'

/**
 * "Explain my month": Claude writes a small screen about the month in A2UI
 * (`GET /insights/month`), and `@a2ui/react` draws it. Read-only.
 */
export function MonthInsightButton({ month }: { month: string }) {
  const t = useT()
  const [open, setOpen] = useState(false)
  return (
    <>
      <Button variant="outline" size="sm" className="rounded-lg" onClick={() => setOpen(true)}>
        <SparklesIcon />
        {t('insight.open')}
      </Button>
      <MonthInsightSheet month={month} open={open} onClose={() => setOpen(false)} />
    </>
  )
}

function MonthInsightSheet({ month, open, onClose }: { month: string; open: boolean; onClose(): void }) {
  const t = useT()
  const lang = useLocale((s) => s.locale)
  const [messages, setMessages] = useState<unknown[] | null>(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  // Ask again only when the month or the language changes.
  const [asked, setAsked] = useState<string | null>(null)
  const key = `${month}:${lang}`

  async function load() {
    setLoading(true)
    setError(null)
    setMessages(null)
    try {
      const { data } = await api.get<{ data: { messages: unknown[] } }>('/insights/month', { params: { month, lang } })
      setMessages(data.data.messages)
    } catch (e) {
      setError(errorMessage(e, t('insight.failed')))
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    if (!open || asked === key) return
    setAsked(key)
    void load()
    // eslint-disable-next-line react-hooks/exhaustive-deps -- load reads the same month and lang
  }, [open, key])

  return (
    <Sheet open={open} onClose={onClose} title={t('insight.title')} view={loading ? 'loading' : error ? 'error' : 'done'}>
      <div className="flex flex-col gap-3">
        {loading && <p className="py-8 text-center text-sm text-muted-foreground">{t('insight.loading')}</p>}
        {error && (
          <div className="flex flex-col items-center gap-3 py-6">
            <p className="text-sm text-destructive">{error}</p>
            <Button variant="outline" size="sm" onClick={() => void load()}>
              {t('insight.retry')}
            </Button>
          </div>
        )}
        {messages && (
          <>
            <A2uiView messages={messages} />
            <p className="text-xs text-muted-foreground">{t('insight.note')}</p>
          </>
        )}
      </div>
    </Sheet>
  )
}
