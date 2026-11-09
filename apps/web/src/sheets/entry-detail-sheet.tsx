import { ArrowDownIcon, ArrowUpIcon } from 'lucide-react'
import { useState, type ReactNode } from 'react'
import { GoldBar } from '@/components/app/gold-bar'
import { Sheet } from '@/components/app/sheet'
import { Button } from '@/components/ui/button'
import { DeleteButton } from '@/components/ui/delete-button'
import { toast } from '@/components/ui/toast'
import { errorMessage } from '@/lib/errors'
import { formatMoneyFromCents, formatShortDate } from '@/lib/format'
import { useT } from '@/lib/i18n'
import type { AccountEntry } from '@/lib/types'
import { cn } from '@/lib/utils'
import { useAccounts } from '@/stores/accounts'

/** Read-only view of one wallet transaction. It can only be deleted, not edited. */
export function EntryDetailSheet({ entry, onClose }: { entry: AccountEntry | null; onClose(): void }) {
  const t = useT()
  const accounts = useAccounts((s) => s.accounts)
  // Keep the last entry while the sheet animates closed.
  const [shown, setShown] = useState(entry)
  if (entry && entry !== shown) setShown(entry)

  const account = shown ? accounts.find((a) => a.id === shown.accountId) : undefined
  const currency = account?.currency ?? 'USD'
  const isIn = (shown?.amountCents ?? 0) >= 0
  const amount = shown ? formatMoneyFromCents(Math.abs(shown.amountCents), currency, true) : ''

  function remove() {
    if (!shown) return
    // Close first; the list reloads behind the sheet.
    onClose()
    useAccounts
      .getState()
      .deleteEntry(shown.accountId, shown.id)
      .then(() => toast.success(t('toast.entryDeleted')))
      .catch((e) => toast.error(errorMessage(e, t('common.delete'))))
  }

  return (
    <Sheet
      docked
      open={!!entry}
      onClose={onClose}
      title={t('accounts.entryTitle')}
      footer={
        <div className="flex items-center gap-2">
          <DeleteButton onConfirm={remove} className="shrink-0" />
          <Button size="lg" variant="secondary" className="h-12 flex-1 rounded-2xl text-base" onClick={onClose}>
            {t('common.close')}
          </Button>
        </div>
      }
    >
      {shown && (
        <div className="flex flex-col gap-5">
          <div className="flex flex-col items-center gap-2 pt-2">
            <span
              className={cn(
                'flex size-12 items-center justify-center rounded-full [&_svg]:size-6',
                isIn ? 'bg-success/15 text-success' : 'bg-destructive/15 text-destructive'
              )}
            >
              {isIn ? <ArrowDownIcon /> : <ArrowUpIcon />}
            </span>
            <p className={cn('num flex items-center text-4xl font-semibold tracking-tight', isIn ? 'text-success' : 'text-foreground')}>
              {isIn ? '+' : '−'}
              {currency === 'GLD' ? (
                <>
                  <GoldBar className="mx-1 size-7" />
                  {amount.replace('🥇', '').trim()}
                </>
              ) : (
                amount
              )}
            </p>
            {shown.note && <p className="max-w-full text-center text-base break-words text-muted-foreground">{shown.note}</p>}
          </div>

          <dl className="overflow-hidden rounded-2xl bg-muted/60 text-sm">
            <Row label={t('accounts.entryType')}>{isIn ? t('accounts.money_in') : t('accounts.money_out')}</Row>
            <Row label={t('accounts.account')}>
              {account ? (
                <span className="flex min-w-0 items-center gap-2">
                  <span className="size-2.5 shrink-0 rounded-full" style={{ background: account.color }} />
                  <span className="truncate">{account.name}</span>
                </span>
              ) : (
                '—'
              )}
            </Row>
            <Row label={t('expenseModal.date')}>
              {formatShortDate(shown.occurredOn)} {shown.occurredOn.slice(0, 4)}
            </Row>
          </dl>
        </div>
      )}
    </Sheet>
  )
}

function Row({ label, children }: { label: string; children: ReactNode }) {
  return (
    <div className="flex items-center justify-between gap-4 border-b border-border/60 px-4 py-3 last:border-b-0">
      <dt className="text-muted-foreground">{label}</dt>
      <dd className="flex min-w-0 justify-end font-medium">{children}</dd>
    </div>
  )
}
