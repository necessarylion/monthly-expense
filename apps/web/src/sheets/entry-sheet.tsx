import { EqualIcon, MinusIcon, PlusIcon } from 'lucide-react'
import { useEffect, useRef, useState } from 'react'
import { ChipRail } from '@/components/app/chip-rail'
import { DatePicker } from '@/components/app/date-picker'
import { NumberPad } from '@/components/app/number-pad'
import { Sheet } from '@/components/app/sheet'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { toast } from '@/components/ui/toast'
import { useAmountInput } from '@/hooks/use-amount-input'
import { errorMessage } from '@/lib/errors'
import { currencySymbol, formatMoneyFromCents, todayIso } from '@/lib/format'
import { useT } from '@/lib/i18n'
import { tintBg } from '@/lib/overview'
import { centerPressedChip } from '@/lib/scroll'
import { cn } from '@/lib/utils'
import { useAccounts } from '@/stores/accounts'
import { AmountDisplay } from './expense-sheet'

type Mode = 'in' | 'out' | 'set'

/**
 * Add money in, money out, or "set balance" (type the new balance, the server
 * books the difference). `accountId` preselects an account. Existing entries are
 * not edited here; `EntryDetailSheet` shows them read-only.
 */
export function EntrySheet({
  open,
  accountId: presetAccountId,
  initialMode = 'out',
  onClose,
}: {
  open: boolean
  accountId: number | null
  /** Open straight in this mode (e.g. 'set' for "Set balance"). */
  initialMode?: Mode
  onClose(): void
}) {
  const t = useT()
  const accounts = useAccounts((s) => s.accounts)
  const input = useAmountInput()
  const [accountId, setAccountId] = useState<number | null>(null)
  const [mode, setMode] = useState<Mode>('out')
  const [date, setDate] = useState(todayIso())
  const [note, setNote] = useState('')
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const chips = useRef<HTMLDivElement>(null)

  const account = accounts.find((a) => a.id === accountId) ?? null
  const currency = account?.currency ?? 'USD'

  useEffect(() => {
    if (!open) return
    setError(null)
    const id = presetAccountId ?? useAccounts.getState().accounts[0]?.id ?? null
    setAccountId(id)
    setMode(initialMode)
    if (initialMode === 'set') startFromBalance(id)
    else input.set('')
    setDate(todayIso())
    setNote('')
    requestAnimationFrame(() => centerPressedChip(chips.current))
    // eslint-disable-next-line react-hooks/exhaustive-deps -- only on open
  }, [open, presetAccountId, initialMode])

  /** Set balance starts from the current balance; the first key replaces it. */
  function startFromBalance(id: number | null) {
    const a = useAccounts.getState().accounts.find((x) => x.id === id)
    input.set(a ? (a.balanceCents / 100).toString() : '', true)
  }

  function chooseMode(next: Mode) {
    if (next === mode) return
    if (next === 'set') startFromBalance(accountId)
    else if (mode === 'set') input.set('')
    setMode(next)
  }

  function chooseAccount(id: number) {
    setAccountId(id)
    if (mode === 'set') startFromBalance(id)
  }

  const n = Number(input.amount)
  const diff = account && input.amount !== '' && Number.isFinite(n) ? Math.round(n * 100) - account.balanceCents : null
  const valid =
    accountId !== null && !!date && (mode === 'set' ? diff !== null && diff !== 0 : Number.isFinite(n) && n > 0)

  async function submit() {
    if (!valid || submitting || accountId === null) return
    setSubmitting(true)
    setError(null)
    try {
      const store = useAccounts.getState()
      if (mode === 'set') {
        await store.adjustBalance(accountId, {
          balance: n,
          occurredOn: date,
          note: note || t('accounts.balanceAdjustment'),
        })
      } else {
        const amount = mode === 'in' ? n : -n
        await store.addEntry(accountId, { amount, occurredOn: date, note: note || undefined })
      }
      toast.success(t('toast.entryAdded'))
      onClose()
    } catch (e) {
      setError(errorMessage(e, t('accounts.failedToRecord')))
    } finally {
      setSubmitting(false)
    }
  }

  const modes: { value: Mode; label: string; Icon: typeof PlusIcon }[] = [
    { value: 'in', label: t('accounts.money_in'), Icon: PlusIcon },
    { value: 'out', label: t('accounts.money_out'), Icon: MinusIcon },
    { value: 'set', label: t('accounts.setBalance'), Icon: EqualIcon },
  ]

  return (
    <Sheet
      docked
      open={open}
      onClose={onClose}
      title={t('accounts.addTransaction')}
      footer={
        <Button size="lg" className="h-12 w-full rounded-2xl text-base" disabled={!valid || submitting} onClick={() => void submit()}>
          {submitting ? t('common.saving') : mode === 'set' ? t('accounts.setBalance') : t('accounts.record')}
        </Button>
      }
    >
      <div className="flex flex-col gap-4">
        <div role="group" className="flex gap-1 rounded-full bg-muted p-1" data-vaul-no-drag="">
          {modes.map(({ value, label, Icon }) => (
            <button
              key={value}
              type="button"
              aria-pressed={mode === value}
              onClick={() => chooseMode(value)}
              className={cn(
                'flex h-9 flex-1 items-center justify-center gap-1.5 rounded-full text-sm font-medium transition-colors',
                mode === value ? 'bg-background text-foreground shadow-sm' : 'text-muted-foreground'
              )}
            >
              <Icon className="size-4" />
              {label}
            </button>
          ))}
        </div>

        <div className="flex flex-col items-center">
          <AmountDisplay
            symbol={currencySymbol(currency)}
            display={input.display}
            sizeClass={input.sizeClass}
            dim={!input.amount || input.replaceOnType}
            sign={
              mode === 'set'
                ? undefined
                : mode === 'in'
                  ? { text: '+', className: 'text-success' }
                  : { text: '−', className: 'text-destructive' }
            }
          />
          {mode === 'set' && account && (
            <p className="text-sm text-muted-foreground tabular-nums">
              {t('accounts.currentBalance')} {formatMoneyFromCents(account.balanceCents, currency, true)}
              {diff !== null && (
                <>
                  {' → '}
                  <span className={cn('font-semibold', diff === 0 ? '' : diff > 0 ? 'text-success' : 'text-destructive')}>
                    {diff === 0
                      ? t('accounts.sameBalance')
                      : `${diff > 0 ? '+' : '−'}${formatMoneyFromCents(Math.abs(diff), currency, true)}`}
                  </span>
                </>
              )}
            </p>
          )}
        </div>

        <ChipRail
          ref={chips}
          role="group"
          aria-label={t('accounts.account')}
          className={cn('grid auto-cols-max grid-flow-col gap-2', accounts.length > 4 ? 'grid-rows-2' : 'grid-rows-1')}
        >
          {accounts.map((a) => {
            const active = accountId === a.id
            return (
              <button
                key={a.id}
                type="button"
                aria-pressed={active}
                onClick={() => chooseAccount(a.id)}
                className={cn(
                  'flex items-center gap-2 rounded-full border py-1.5 pr-3.5 pl-2 text-sm transition-colors disabled:opacity-40',
                  active ? 'font-semibold' : 'bg-background'
                )}
                style={active ? { background: tintBg(a.color, 14), borderColor: a.color } : undefined}
              >
                <span className="size-2.5 rounded-full" style={{ background: a.color }} />
                <span className="max-w-32 truncate">{a.name}</span>
              </button>
            )
          })}
        </ChipRail>

        <DatePicker value={date} onChange={setDate} />

        <Input
          value={note}
          maxLength={500}
          onChange={(e) => setNote(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && void submit()}
          aria-label={t('expenseModal.note')}
          placeholder={t('expenseModal.notePlaceholder')}
          className="h-11 rounded-full px-4 text-base sm:text-sm"
        />

        {error && (
          <p role="alert" className="text-sm text-destructive">
            {error}
          </p>
        )}

        {open && (
          <NumberPad
            onKey={(k) => {
              setError(null)
              input.press(k)
            }}
            onEnter={() => void submit()}
            onEscape={onClose}
          />
        )}
      </div>
    </Sheet>
  )
}
