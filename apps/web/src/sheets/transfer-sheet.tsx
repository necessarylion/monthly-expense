import { ArrowDownIcon } from 'lucide-react'
import { useEffect, useState } from 'react'
import { ChipRail } from '@/components/app/chip-rail'
import { DatePicker } from '@/components/app/date-picker'
import { Sheet } from '@/components/app/sheet'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { InputGroup, InputGroupAddon, InputGroupInput, InputGroupText } from '@/components/ui/input-group'
import { Label } from '@/components/ui/label'
import { toast } from '@/components/ui/toast'
import { errorMessage } from '@/lib/errors'
import { currencySymbol, todayIso } from '@/lib/format'
import { useT } from '@/lib/i18n'
import { tintBg } from '@/lib/overview'
import type { Account } from '@/lib/types'
import { cn } from '@/lib/utils'
import { useAccounts } from '@/stores/accounts'

function AccountChips({
  accounts,
  value,
  disabledId,
  onChange,
}: {
  accounts: Account[]
  value: number | null
  disabledId?: number | null
  onChange(id: number): void
}) {
  return (
    <ChipRail className="flex gap-2">
      {accounts.map((a) => {
        const active = value === a.id
        return (
          <button
            key={a.id}
            type="button"
            aria-pressed={active}
            disabled={a.id === disabledId}
            onClick={() => onChange(a.id)}
            className={cn(
              'flex shrink-0 items-center gap-2 rounded-lg border py-1.5 pr-3.5 pl-2 text-sm transition-colors disabled:opacity-35',
              active ? 'font-semibold' : 'bg-background'
            )}
            style={active ? { background: tintBg(a.color, 14), borderColor: a.color } : undefined}
          >
            <span className="size-2.5 rounded-full" style={{ background: a.color }} />
            <span className="max-w-32 truncate">{a.name}</span>
            <span className="text-xs text-muted-foreground">{a.currency}</span>
          </button>
        )
      })}
    </ChipRail>
  )
}

function AmountField({
  label,
  currency,
  value,
  onChange,
  onEnter,
}: {
  label: string
  currency: string
  value: string
  onChange(v: string): void
  onEnter(): void
}) {
  return (
    <div className="flex flex-col gap-2">
      <Label>{label}</Label>
      <InputGroup className="h-12 rounded-lg">
        <InputGroupAddon>
          <InputGroupText className="text-base">{currencySymbol(currency)}</InputGroupText>
        </InputGroupAddon>
        <InputGroupInput
          inputMode="decimal"
          value={value}
          onChange={(e) => onChange(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && onEnter()}
          placeholder="0"
          aria-label={label}
          className="text-xl font-semibold tabular-nums"
        />
      </InputGroup>
    </div>
  )
}

export function TransferSheet({ open, onClose }: { open: boolean; onClose(): void }) {
  const t = useT()
  const accounts = useAccounts((s) => s.accounts)
  const [fromId, setFromId] = useState<number | null>(null)
  const [toId, setToId] = useState<number | null>(null)
  const [amount, setAmount] = useState('')
  const [toAmount, setToAmount] = useState('')
  const [date, setDate] = useState(todayIso())
  const [note, setNote] = useState('')
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (!open) return
    const s = useAccounts.getState()
    const from = s.openId ?? s.accounts[0]?.id ?? null
    setFromId(from)
    setToId(s.accounts.find((a) => a.id !== from)?.id ?? null)
    setAmount('')
    setToAmount('')
    setDate(todayIso())
    setNote('')
    setError(null)
  }, [open])

  const from = accounts.find((a) => a.id === fromId) ?? null
  const to = accounts.find((a) => a.id === toId) ?? null
  // Different currencies: the user types what arrives, there is no auto conversion.
  const crossCurrency = !!from && !!to && from.currency !== to.currency
  const sent = Number(amount)
  const received = Number(toAmount)
  const valid =
    fromId !== null &&
    toId !== null &&
    fromId !== toId &&
    Number.isFinite(sent) &&
    sent > 0 &&
    !!date &&
    (!crossCurrency || (Number.isFinite(received) && received > 0))

  function chooseFrom(id: number) {
    setFromId(id)
    if (toId === id) setToId(null)
  }

  async function submit() {
    if (!valid || submitting || fromId === null || toId === null) return
    setSubmitting(true)
    setError(null)
    try {
      await useAccounts.getState().transfer({
        fromAccountId: fromId,
        toAccountId: toId,
        amount: sent,
        toAmount: crossCurrency ? received : undefined,
        occurredOn: date,
        note: note || undefined,
      })
      toast.success(t('toast.transferDone'))
      onClose()
    } catch (e) {
      setError(errorMessage(e, t('accounts.failedToTransfer')))
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <Sheet
      open={open}
      onClose={onClose}
      title={t('accounts.transfer')}
      footer={
        <Button size="lg" className="h-12 w-full rounded-lg text-base" disabled={!valid || submitting} onClick={() => void submit()}>
          {submitting ? t('common.working') : t('accounts.transfer')}
        </Button>
      }
    >
      <div className="flex flex-col gap-4">
        <div className="flex flex-col gap-2">
          <Label>{t('accounts.transferFrom')}</Label>
          <AccountChips accounts={accounts} value={fromId} onChange={chooseFrom} />
        </div>
        <div className="flex justify-center">
          <span className="flex size-8 items-center justify-center rounded-full bg-muted text-muted-foreground">
            <ArrowDownIcon className="size-4" />
          </span>
        </div>
        <div className="flex flex-col gap-2">
          <Label>{t('accounts.transferTo')}</Label>
          <AccountChips accounts={accounts} value={toId} disabledId={fromId} onChange={setToId} />
        </div>
        <AmountField
          label={crossCurrency ? t('accounts.amountOut') : t('accounts.amountPlaceholder')}
          currency={from?.currency ?? 'USD'}
          value={amount}
          onChange={setAmount}
          onEnter={() => void submit()}
        />
        {crossCurrency && to && (
          <AmountField
            label={t('accounts.amountIn')}
            currency={to.currency}
            value={toAmount}
            onChange={setToAmount}
            onEnter={() => void submit()}
          />
        )}
        <DatePicker value={date} onChange={setDate} />
        <Input
          value={note}
          maxLength={500}
          onChange={(e) => setNote(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && void submit()}
          placeholder={t('accounts.notePlaceholder')}
          className="h-11 text-base sm:text-sm"
        />
        {error && (
          <p role="alert" className="text-sm text-destructive">
            {error}
          </p>
        )}
      </div>
    </Sheet>
  )
}
