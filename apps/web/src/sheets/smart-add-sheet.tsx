import { WandSparklesIcon } from 'lucide-react'
import { useState, type FormEvent } from 'react'
import { type A2uiAction, A2uiView } from '@/components/app/a2ui-view'
import { Sheet } from '@/components/app/sheet'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { toast } from '@/components/ui/toast'
import { api } from '@/lib/api'
import { errorMessage } from '@/lib/errors'
import { todayIso } from '@/lib/format'
import { useLocale, useT } from '@/lib/i18n'

/**
 * Smart add: type "lunch 5000, taxi 3000", get a card per expense
 * (`POST /smart-add`, A2UI), and tap Save on each. A tap sends the A2UI
 * action to `POST /smart-add/actions`, which saves it and marks it saved.
 */
export function SmartAddButton() {
  const t = useT()
  const [open, setOpen] = useState(false)
  return (
    <>
      <Button variant="outline" size="sm" className="rounded-lg" onClick={() => setOpen(true)}>
        <WandSparklesIcon />
        {t('smartAdd.open')}
      </Button>
      <SmartAddSheet open={open} onClose={() => setOpen(false)} />
    </>
  )
}

function SmartAddSheet({ open, onClose }: { open: boolean; onClose(): void }) {
  const t = useT()
  const lang = useLocale((s) => s.locale)
  const [text, setText] = useState('')
  const [messages, setMessages] = useState<unknown[] | null>(null)
  const [reading, setReading] = useState(false)

  async function read(e: FormEvent) {
    e.preventDefault()
    if (!text.trim() || reading) return
    setReading(true)
    try {
      const { data } = await api.post<{ data: { messages: unknown[] } }>('/smart-add', { text, today: todayIso(), lang })
      setMessages(data.data.messages)
    } catch (err) {
      toast.error(errorMessage(err, t('smartAdd.failed')))
    } finally {
      setReading(false)
    }
  }

  async function save(action: A2uiAction): Promise<unknown[] | undefined> {
    try {
      const { data } = await api.post<{ data: { messages: unknown[] } }>('/smart-add/actions', {
        name: action.name,
        sourceComponentId: action.sourceComponentId,
        context: action.context,
        lang,
      })
      return data.data.messages
    } catch (err) {
      toast.error(errorMessage(err, t('expenseModal.failedToSave')))
      return undefined
    }
  }

  function close() {
    onClose()
    setText('')
    setMessages(null)
  }

  return (
    <Sheet open={open} onClose={close} title={t('smartAdd.title')} view={messages ? 'cards' : 'form'}>
      <div className="flex flex-col gap-3 px-4 pb-4">
        <form onSubmit={read} className="flex gap-2">
          <Input value={text} onChange={(e) => setText(e.target.value)} placeholder={t('smartAdd.placeholder')} maxLength={500} autoFocus />
          <Button type="submit" disabled={reading || !text.trim()}>
            {reading ? t('smartAdd.reading') : t('smartAdd.read')}
          </Button>
        </form>
        {messages && <A2uiView messages={messages} onAction={save} />}
      </div>
    </Sheet>
  )
}
