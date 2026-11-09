import { GoldBar } from '@/components/app/gold-bar'
import { AnimatedCounter } from '@/components/ui/animated-counter'
import { bigMoneyParts } from '@/lib/format'
import { cn } from '@/lib/utils'

/**
 * A money amount that rolls to its new value like an odometer.
 * Uses the currency's own decimals (none for JPY, MMK, …).
 */
export function Money({
  cents,
  currency,
  className,
  symbolClassName,
  whole,
}: {
  cents: number
  currency: string
  className?: string
  symbolClassName?: string
  /** Drop the decimals (for rough figures like a daily allowance). */
  whole?: boolean
}) {
  const { symbol, fraction } = bigMoneyParts(cents, currency)
  const decimals = whole || fraction === null ? 0 : fraction.length
  return (
    <span className={cn('inline-flex items-baseline tabular-nums', className)}>
      {cents < 0 && <span>−</span>}
      {currency.toUpperCase() === 'GLD' ? (
        <GoldBar className="mr-1.5 size-[0.8em] shrink-0 self-center" />
      ) : (
        <span className={cn('mr-0.5 text-[0.6em] font-medium text-muted-foreground', symbolClassName)}>{symbol}</span>
      )}
      <AnimatedCounter value={whole ? Math.floor(Math.abs(cents) / 100) : Math.abs(cents) / 100} decimals={decimals} />
    </span>
  )
}
