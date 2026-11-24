import { WandSparklesIcon } from 'lucide-react'
import { useState, type FormEvent, type ReactNode } from 'react'
import { Sheet } from '@/components/app/sheet'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Textarea } from '@/components/ui/textarea'
import { toast } from '@/components/ui/toast'
import { api } from '@/lib/api'
import { errorMessage } from '@/lib/errors'
import { formatMoney, todayIso } from '@/lib/format'
import { useT } from '@/lib/i18n'
import { useAccounts } from '@/stores/accounts'
import { useExpenses } from '@/stores/expenses'
import { useGroups } from '@/stores/groups'

/**
 * Smart add: type "lunch 5000, taxi 3000", get a list of the expenses with
 * their category and wallet (`POST /smart-add`), and tap Save on each. Save
 * is a normal `POST /expenses`. Edit opens a small form that changes the row
 * before it is saved.
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

/** One read expense, with the keys of `POST /expenses`. The form does not change the date. */
interface EditItem {
  note: string
  occurredOn: string
  amount: number
  accountId: number | null
  categoryId: number | null
}

interface Row extends EditItem {
  state?: 'saving' | 'saved'
}

function SmartAddSheet({ open, onClose }: { open: boolean; onClose(): void }) {
  const t = useT()
  const [text, setText] = useState('')
  const [rows, setRows] = useState<Row[] | null>(null)
  const [reading, setReading] = useState(false)
  /** The index of the row in the edit form. */
  const [editing, setEditing] = useState<number | null>(null)
  const categories = useExpenses((s) => s.categories)
  const accounts = useAccounts((s) => s.accounts)
  const currency = useGroups((s) => s.groups.find((g) => g.id === s.activeId)?.currency ?? 'USD')

  function patch(index: number, change: Partial<Row>) {
    setRows((old) => old && old.map((row, i) => (i === index ? { ...row, ...change } : row)))
  }

  async function read(e: FormEvent) {
    e.preventDefault()
    if (!text.trim() || reading) return
    setReading(true)
    try {
      const { data } = await api.post<{ data: { items: EditItem[] } }>('/smart-add', { text, today: todayIso() })
      setRows(data.data.items)
    } catch (err) {
      toast.error(errorMessage(err, t('smartAdd.failed')))
    } finally {
      setReading(false)
    }
  }

  async function save(index: number, row: Row) {
    if (row.state) return
    patch(index, { state: 'saving' })
    try {
      await useExpenses.getState().addExpense({
        note: row.note,
        amount: row.amount,
        occurredOn: row.occurredOn,
        accountId: row.accountId,
        categoryId: row.categoryId ?? undefined,
      })
      patch(index, { state: 'saved' })
    } catch (err) {
      patch(index, { state: undefined })
      toast.error(errorMessage(err, t('expenseModal.failedToSave')))
    }
  }

  function close() {
    onClose()
    setText('')
    setRows(null)
    setEditing(null)
  }

  const edited = editing === null ? undefined : rows?.[editing]

  return (
    <Sheet docked open={open} onClose={close} title={t('smartAdd.title')} view={edited ? 'edit' : rows ? 'cards' : 'form'}>
      {/* pt-1: room for the focus ring; the sheet body clips what sits outside it. */}
      <div className="flex flex-col gap-3 pt-1">
        {edited ? (
          <EditForm
            item={edited}
            onDone={(item) => {
              if (item && editing !== null) patch(editing, item)
              setEditing(null)
            }}
          />
        ) : (
          <>
            <form onSubmit={read} className="flex flex-col gap-2">
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
            {rows?.length === 0 && <p className="py-2 text-sm text-muted-foreground">{t('smartAdd.nothing')}</p>}
            {rows && rows.length > 0 && (
              <ul className="flex flex-col divide-y divide-border rounded-xl border border-border bg-card px-3.5 text-[15px]">
                {rows.map((row, i) => {
                  const category = categories.find((c) => c.id === row.categoryId)
                  const wallet = accounts.find((a) => a.id === row.accountId)?.name ?? t('smartAdd.noWallet')
                  return (
                    <li key={i} className="flex items-center gap-2 py-3">
                      <span className="flex min-w-0 flex-1 flex-col">
                        <span className="truncate">{row.note}</span>
                        <span className="truncate text-xs text-muted-foreground">{category ? `${category.name} · ${wallet}` : wallet}</span>
                      </span>
                      <span className="shrink-0 font-semibold tabular-nums">{formatMoney(row.amount, currency, !Number.isInteger(row.amount))}</span>
                      {row.state === 'saved' ? (
                        <span className="shrink-0 px-2 text-xs text-muted-foreground">✓ {t('smartAdd.saved')}</span>
                      ) : (
                        <>
                          <Button variant="ghost" size="sm" disabled={row.state === 'saving'} onClick={() => setEditing(i)}>
                            {t('smartAdd.edit')}
                          </Button>
                          <Button size="sm" disabled={row.state === 'saving'} onClick={() => void save(i, row)}>
                            {t('common.save')}
                          </Button>
                        </>
                      )}
                    </li>
                  )
                })}
              </ul>
            )}
          </>
        )}
      </div>
    </Sheet>
  )
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
