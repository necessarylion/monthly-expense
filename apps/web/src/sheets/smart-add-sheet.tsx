import { WandSparklesIcon } from 'lucide-react'
import { useState, type FormEvent, type ReactNode } from 'react'
import { type A2uiAction, A2uiView } from '@/components/app/a2ui-view'
import { Sheet } from '@/components/app/sheet'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Textarea } from '@/components/ui/textarea'
import { toast } from '@/components/ui/toast'
import { api } from '@/lib/api'
import { errorMessage } from '@/lib/errors'
import { todayIso } from '@/lib/format'
import { t, useLocale, useT } from '@/lib/i18n'
import { cn } from '@/lib/utils'
import { useAccounts } from '@/stores/accounts'
import { useExpenses } from '@/stores/expenses'
import { useGroups } from '@/stores/groups'

/**
 * Smart add: type "lunch 5000, taxi 3000", get a list of the expenses with
 * their category and wallet (`POST /smart-add`, A2UI), and tap Save on each. A tap sends the A2UI
 * action to `POST /smart-add/actions`, which saves it and marks it saved.
 * Edit is answered here, not by the API: a small form changes the row's
 * data model, and its Save button then sends the edited values.
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
  const [editing, setEditing] = useState<Editing | null>(null)

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

  async function onAction(action: A2uiAction): Promise<unknown[] | undefined> {
    if (action.name !== 'edit_expense') return save(action)
    // The row waits until the form is done; the reply updates its data.
    return new Promise((resolve) => {
      setEditing({ index: Number(action.sourceComponentId.slice('edit_'.length)), item: action.context as unknown as EditItem, resolve })
    })
  }

  function finishEdit(item: EditItem | null) {
    editing?.resolve(item ? rowUpdate(editing.index, item) : undefined)
    setEditing(null)
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
    finishEdit(null)
    onClose()
    setText('')
    setMessages(null)
  }

  return (
    <Sheet docked open={open} onClose={close} title={t('smartAdd.title')} view={messages ? 'cards' : 'form'}>
      {/* pt-1: room for the focus ring; the sheet body clips what sits outside it. */}
      <div className="flex flex-col gap-3 pt-1">
        {editing && <EditForm item={editing.item} onDone={finishEdit} />}
        <form onSubmit={read} className={cn('flex flex-col gap-2', editing && 'hidden')}>
          <Textarea
            value={text}
            onChange={(e) => setText(e.target.value)}
            // Enter adds a line (one expense per line is fine); Cmd/Ctrl+Enter reads.
            onKeyDown={(e) => {
              if (e.key === 'Enter' && (e.metaKey || e.ctrlKey)) void read(e)
            }}
            placeholder={t('smartAdd.placeholder')}
            maxLength={500}
            rows={3}
            className="field-sizing-fixed resize-none"
            autoFocus
          />
          <Button type="submit" className="self-end" disabled={reading || !text.trim()}>
            {reading ? t('smartAdd.reading') : t('smartAdd.read')}
          </Button>
        </form>
        {/* Hidden, not unmounted, while editing: it keeps which rows are saved. */}
        {messages && <A2uiView messages={messages} onAction={onAction} className={cn('a2ui-smart-add', editing && 'hidden')} />}
      </div>
    </Sheet>
  )
}

/** A row's values, with the keys of `POST /expenses`. The form does not change the date. */
interface EditItem {
  note: string
  occurredOn: string
  amount: number
  accountId: number | null
  categoryId: number | null
}

interface Editing {
  index: number
  item: EditItem
  resolve(reply: unknown[] | undefined): void
}

/** The A2UI update that writes the edited item into row `index`, with the texts the row shows. */
function rowUpdate(index: number, item: EditItem): unknown[] {
  const groups = useGroups.getState()
  const currency = groups.groups.find((g) => g.id === groups.activeId)?.currency ?? ''
  const category = useExpenses.getState().categories.find((c) => c.id === item.categoryId)
  const wallet = useAccounts.getState().accounts.find((a) => a.id === item.accountId)
  const walletName = wallet?.name ?? t('smartAdd.noWallet')
  const whole = Number.isInteger(item.amount)
  const number = item.amount.toLocaleString('en-US', {
    minimumFractionDigits: whole ? 0 : 2,
    maximumFractionDigits: 2,
  })
  return [
    {
      version: 'v0.9',
      updateDataModel: {
        surfaceId: 'smart-add',
        path: `/items/${index}`,
        value: {
          ...item,
          amountText: `${number} ${currency}`.trim(),
          details: category ? `${category.name} · ${walletName}` : walletName,
        },
      },
    },
  ]
}

const selectClass =
  'h-10 w-full rounded-lg border border-input bg-transparent px-2.5 text-base outline-none focus-visible:border-ring focus-visible:ring-3 focus-visible:ring-ring/50 md:text-sm dark:bg-input/30'

function EditForm({ item, onDone }: { item: EditItem; onDone(item: EditItem | null): void }) {
  const t = useT()
  const categories = useExpenses((s) => s.categories)
  const accounts = useAccounts((s) => s.accounts)
  const [note, setNote] = useState(item.note)
  const [amount, setAmount] = useState(String(item.amount))
  const [categoryId, setCategoryId] = useState(item.categoryId)
  const [accountId, setAccountId] = useState(item.accountId)

  // The limits of POST /expenses.
  const n = Math.round(Number(amount) * 100) / 100
  const valid = note.trim().length > 0 && n >= 0.01 && n <= 10_000_000

  function submit(e: FormEvent) {
    e.preventDefault()
    if (valid) onDone({ ...item, note: note.trim(), amount: n, accountId, categoryId })
  }

  return (
    <form onSubmit={submit} className="flex flex-col gap-3">
      <Field label={t('expenseModal.note')}>
        <Input value={note} maxLength={500} onChange={(e) => setNote(e.target.value)} className="h-10" autoFocus />
      </Field>
      <Field label={t('expenseModal.amount')}>
        <Input
          type="number"
          inputMode="decimal"
          step="0.01"
          min="0.01"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
          className="h-10"
        />
      </Field>
      <Field label={t('expenseModal.category')}>
        <select
          value={categoryId ?? ''}
          onChange={(e) => setCategoryId(e.target.value ? Number(e.target.value) : null)}
          className={selectClass}
        >
          <option value="">{t('smartAdd.autoCategory')}</option>
          {categories.map((c) => (
            <option key={c.id} value={c.id}>
              {c.name}
            </option>
          ))}
        </select>
      </Field>
      <Field label={t('accounts.account')}>
        <select
          value={accountId ?? ''}
          onChange={(e) => setAccountId(e.target.value ? Number(e.target.value) : null)}
          className={selectClass}
        >
          <option value="">{t('smartAdd.noWallet')}</option>
          {accounts.map((a) => (
            <option key={a.id} value={a.id}>
              {a.name}
            </option>
          ))}
        </select>
      </Field>
      <div className="flex gap-2 pt-1">
        <Button type="button" variant="secondary" className="flex-1" onClick={() => onDone(null)}>
          {t('common.cancel')}
        </Button>
        <Button type="submit" className="flex-1" disabled={!valid}>
          {t('smartAdd.done')}
        </Button>
      </div>
    </form>
  )
}

function Field({ label, children }: { label: string; children: ReactNode }) {
  return (
    <Label className="flex flex-col items-stretch gap-1.5">
      <span className="text-sm text-muted-foreground">{label}</span>
      {children}
    </Label>
  )
}
