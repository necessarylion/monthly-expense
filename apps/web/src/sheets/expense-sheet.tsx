import { WalletIcon } from 'lucide-react'
import { useEffect, useRef, useState } from 'react'
import { ChipRail } from '@/components/app/chip-rail'
import { CategoryIcon } from '@/components/app/category-icon'
import { DatePicker } from '@/components/app/date-picker'
import { NumberPad } from '@/components/app/number-pad'
import { FullScreen, FullScreenSave } from '@/components/app/full-screen'
import { Textarea } from '@/components/ui/textarea'
import { SelectField } from '@/components/app/select-field'
import { toast } from '@/components/ui/toast'
import { useAmountInput } from '@/hooks/use-amount-input'
import { errorMessage } from '@/lib/errors'
import { currencySymbol, todayIso } from '@/lib/format'
import { useT } from '@/lib/i18n'
import { tintBg } from '@/lib/overview'
import { centerPressedChip } from '@/lib/scroll'
import { cn } from '@/lib/utils'
import { useAccounts } from '@/stores/accounts'
import { useExpenses } from '@/stores/expenses'
import { useActiveGroup } from '@/stores/groups'
import { useUi } from '@/stores/ui'

const NONE = 'none'

export function AmountDisplay({
  symbol,
  display,
  sizeClass,
  dim,
  sign,
}: {
  symbol: string
  display: string
  sizeClass: string
  dim: boolean
  sign?: { text: string; className: string }
}) {
  return (
    <output aria-live="polite" className="my-auto flex h-20 shrink-0 items-center justify-center gap-1.5 overflow-hidden">
      {sign && <span className={cn('text-4xl font-semibold', sign.className)}>{sign.text}</span>}
      <span className="text-3xl font-medium text-muted-foreground">{symbol}</span>
      <span
        className={cn(
          'truncate font-semibold tracking-tighter tabular-nums transition-colors',
          sizeClass,
          dim ? 'text-muted-foreground/60' : 'text-foreground'
        )}
      >
        {display}
      </span>
    </output>
  )
}

export function ExpenseSheet() {
  const t = useT()
  const expense = useUi((s) => s.expenseSheet)
  const close = useUi((s) => s.closeExpense)
  const categories = useExpenses((s) => s.categories)
  const accounts = useAccounts((s) => s.accounts)
  const defaultAccountId = useAccounts((s) => s.defaultAccountId)
  const currency = useActiveGroup()?.currency ?? 'USD'
  const input = useAmountInput()
  const [categoryId, setCategoryId] = useState<number | null>(null)
  const [date, setDate] = useState(todayIso())
  const [note, setNote] = useState('')
  /** Account the money-out entry books to; null = none. New expenses only. */
  const [payFromId, setPayFromId] = useState<number | null>(null)
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const chips = useRef<HTMLDivElement>(null)

  const open = expense !== undefined
  const isEdit = !!expense

  // Reset the form each time the sheet opens.
  useEffect(() => {
    if (expense === undefined) return
    setError(null)
    if (expense) {
      setCategoryId(expense.categoryId)
      input.set((expense.amountCents / 100).toString(), true) // the first key replaces it
      setDate(expense.occurredOn)
      setNote(expense.note ?? '')
    } else {
      const draft = useUi.getState().expenseDraft
      setCategoryId(draft ? draft.categoryId : (useExpenses.getState().categories[0]?.id ?? null))
      const amount = draft?.amount ?? null
      input.set(amount === null ? '' : String(amount), amount !== null) // a draft amount is replaced by the first key
      setDate(todayIso())
      setNote(draft?.note ?? '')
      const acc = useAccounts.getState()
      if (!acc.loaded) acc.load().catch(() => {})
      setPayFromId(acc.defaultAccountId)
      acc
        .loadDefaultAccount()
        .then(() => setPayFromId(useAccounts.getState().defaultAccountId))
        .catch(() => {})
    }
    requestAnimationFrame(() => centerPressedChip(chips.current))
    // eslint-disable-next-line react-hooks/exhaustive-deps -- only on open
  }, [expense])

  // Default account first, the rest keep their order.
  const payFrom = [...accounts].sort(
    (a, b) => Number(b.id === defaultAccountId) - Number(a.id === defaultAccountId)
  )

  const amount = Number(input.amount)
  const valid = categoryId !== null && Number.isFinite(amount) && amount > 0 && !!date

  async function submit() {
    if (!valid || categoryId === null || submitting) return
    setSubmitting(true)
    setError(null)
    try {
      const store = useExpenses.getState()
      if (expense) {
        await store.updateExpense(expense.id, { categoryId, amount, occurredOn: date, note: note || null })
        toast.success(t('toast.expenseSaved'))
      } else {
        await store.addExpense({ categoryId, amount, occurredOn: date, note: note || undefined, accountId: payFromId })
        toast.success(t('toast.expenseAdded'))
      }
      close()
    } catch (e) {
      setError(errorMessage(e, t('expenseModal.failedToSave')))
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <FullScreen
      open={open}
      onClose={close}
      title={isEdit ? t('expenseModal.titleEdit') : t('expenseModal.titleNew')}
      top={<DatePicker value={date} onChange={setDate} />}
      fields={
        <>
          {!isEdit && accounts.length > 0 && (
            <SelectField
              size="lg"
              aria-label={t('expenseModal.payFrom')}
              className="w-full shrink-0"
              icon={<WalletIcon className="text-muted-foreground" />}
              value={payFromId === null ? NONE : String(payFromId)}
              onChange={(v) => setPayFromId(v === NONE ? null : Number(v))}
              options={[{ value: NONE, label: t('accounts.none') }, ...payFrom.map((a) => ({ value: String(a.id), label: a.name }))]}
            />
          )}

          <ChipRail
            ref={chips}
            role="group"
            aria-label={t('expenseModal.category')}
            className="grid auto-cols-max grid-flow-col grid-rows-2 gap-2"
          >
            {categories.map((c) => {
              const active = categoryId === c.id
              return (
                <button
                  key={c.id}
                  type="button"
                  aria-pressed={active}
                  onClick={() => setCategoryId(c.id)}
                  className={cn(
                    'flex items-center gap-2 rounded-lg border py-1 pr-3.5 pl-1 text-sm transition-colors',
                    active ? 'font-semibold' : 'bg-background'
                  )}
                  style={active ? { background: tintBg(c.color, 14), borderColor: c.color } : undefined}
                >
                  <CategoryIcon iconKey={c.iconKey} color={c.color} size={28} />
                  <span className="max-w-28 truncate">{c.name}</span>
                </button>
              )
            })}
          </ChipRail>

          <Textarea
            value={note}
            maxLength={500}
            onChange={(e) => setNote(e.target.value)}
            rows={2}
            // Enter saves. It does not add a new line.
            onKeyDown={(e) => {
              if (e.key !== 'Enter') return
              e.preventDefault()
              void submit()
            }}
            aria-label={t('expenseModal.note')}
            placeholder={t('expenseModal.notePlaceholder')}
            className="field-sizing-fixed h-16 min-h-0 shrink-0 resize-none text-base sm:text-sm"
          />
        </>
      }
      footer={
        <FullScreenSave
          label={submitting ? t('common.saving') : isEdit ? t('expenseModal.saveEdit') : t('expenseModal.saveNew')}
          disabled={!valid || submitting}
          onClick={() => void submit()}
        />
      }
    >
      <AmountDisplay
        symbol={currencySymbol(currency)}
        display={input.display}
        sizeClass={input.sizeClass}
        dim={!input.amount || input.replaceOnType}
      />

      {error && (
        <p role="alert" className="px-5 pb-2 text-center text-sm text-destructive">
          {error}
        </p>
      )}

      {open && (
        <NumberPad
          flat
          onKey={(k) => {
            setError(null)
            input.press(k)
          }}
          onEnter={() => void submit()}
          onEscape={close}
        />
      )}
    </FullScreen>
  )
}
