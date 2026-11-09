import { t, tm } from './i18n'

export function fromCents(cents: number): number {
  return cents / 100
}

/**
 * narrowSymbol collapses AUD/CAD/SGD/USD to "$" (and CNY/JPY to "¥"). Keep the
 * short symbol for the canonical owner, use the disambiguated one otherwise.
 */
function currencyDisplayFor(currency: string): 'narrowSymbol' | 'symbol' {
  const c = currency.toUpperCase()
  try {
    const narrow = new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: c,
      currencyDisplay: 'narrowSymbol',
    })
      .formatToParts(0)
      .find((p) => p.type === 'currency')?.value
    if (narrow === '$' && c !== 'USD') return 'symbol'
    if (narrow === '¥' && c !== 'JPY') return 'symbol'
  } catch {
    /* unknown code — either display works */
  }
  return 'narrowSymbol'
}

/** Local symbol overrides Intl doesn't know: MMK "K" → "Ks", GLD → "🥇". */
function symbolFix(formatted: string, currency: string): string {
  const c = currency.toUpperCase()
  if (c === 'MMK') return formatted.replace(/K(?=[\s\d])/, 'Ks')
  if (c === 'GLD') return formatted.replace('GLD', '🥇')
  return formatted
}

export function formatMoney(amount: number, currency = 'USD', withCents = false): string {
  return symbolFix(
    amount.toLocaleString('en-US', {
      style: 'currency',
      currency,
      currencyDisplay: currencyDisplayFor(currency),
      minimumFractionDigits: withCents ? 2 : 0,
      maximumFractionDigits: 2,
    }),
    currency
  )
}

export function formatMoneyFromCents(
  cents: number,
  currency = 'USD',
  withCents = false
): string {
  return formatMoney(fromCents(cents), currency, withCents)
}

/** Short amount without a symbol, at most 4 characters. Exact under 1,000 ("395", "43.5"), else "1.2K", "20K", "150M". */
export function formatMoneyCompactFromCents(cents: number): string {
  const amount = cents / 100
  return amount.toLocaleString('en-US', {
    notation: 'compact',
    maximumSignificantDigits: Math.abs(amount) < 1000 ? 3 : 2,
  })
}

/** Just the major-unit number as a string with locale grouping, no symbol. */
export function formatAmountInteger(cents: number): string {
  return Math.floor(cents / 100).toLocaleString('en-US')
}

/** Two-digit cents remainder. */
export function formatCentsRemainder(cents: number): string {
  return String(cents % 100).padStart(2, '0')
}

/** Currency symbol (e.g. "$", "€", "฿"). Falls back to the code itself. */
export function currencySymbol(currency: string): string {
  try {
    const parts = new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency,
      currencyDisplay: currencyDisplayFor(currency),
    }).formatToParts(0)
    const sym = parts.find((p) => p.type === 'currency')?.value ?? currency
    const c = currency.toUpperCase()
    if (c === 'GLD') return '🥇'
    return c === 'MMK' && sym === 'K' ? 'Ks' : sym
  } catch {
    return currency
  }
}

/**
 * Split a money value into the symbol, integer (with grouping), and the
 * fractional digits — used to render the oversized total on the dashboard
 * where the integer is large and the fraction is muted. Zero-decimal
 * currencies (JPY, MMK, …) return `fraction: null`.
 */
export function bigMoneyParts(cents: number, currency: string) {
  let fmt: Intl.NumberFormat
  try {
    fmt = new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency,
      currencyDisplay: currencyDisplayFor(currency),
    })
  } catch {
    fmt = new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
      currencyDisplay: 'narrowSymbol',
    })
  }
  const opts = fmt.resolvedOptions()
  const hasFraction = (opts.maximumFractionDigits ?? 0) > 0
  const value = cents / 100
  const parts = fmt.formatToParts(value)
  const rawSymbol = parts.find((p) => p.type === 'currency')?.value ?? ''
  const symbol =
    currency.toUpperCase() === 'GLD'
      ? '🥇'
      : currency.toUpperCase() === 'MMK' && rawSymbol === 'K'
        ? 'Ks'
        : rawSymbol
  const integer = parts
    .filter((p) => p.type === 'integer' || p.type === 'group')
    .map((p) => p.value)
    .join('')
  const fraction = hasFraction
    ? (parts.find((p) => p.type === 'fraction')?.value ?? '00')
    : null
  return { symbol, integer, fraction }
}


function shortMonths(): readonly string[] {
  return tm<readonly string[]>('months.short')
}

export function formatShortDate(iso: string): string {
  const [, mo, day] = iso.split('-')
  const monthName = shortMonths()[Number(mo) - 1] ?? ''
  return `${Number(day)} ${monthName}`
}

export function currentMonthKey(): string {
  const now = new Date()
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`
}

export function monthLabel(key: string): string {
  const [y, m] = key.split('-').map(Number)
  const name = shortMonths()[m - 1] ?? ''
  return `${name} ${y}`
}

export function shiftMonth(key: string, delta: number): string {
  const [y, m] = key.split('-').map(Number)
  const d = new Date(Date.UTC(y, m - 1 + delta, 1))
  return `${d.getUTCFullYear()}-${String(d.getUTCMonth() + 1).padStart(2, '0')}`
}

/** "just now", "5 min ago", "2 h ago", "3 d ago", … — localized. */
export function relativeTime(ms: number, now = Date.now()): string {
  const diff = Math.max(0, now - ms)
  if (diff < 60_000) return t('overview.justNow')
  if (diff < 3_600_000) return t('overview.minuteAgo', { n: Math.floor(diff / 60_000) })
  if (diff < 86_400_000) return t('overview.hourAgo', { n: Math.floor(diff / 3_600_000) })
  return t('overview.dayAgo', { n: Math.floor(diff / 86_400_000) })
}

export function todayIso(): string {
  const now = new Date()
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`
}

/**
 * A short list of currencies for dropdowns and the rates page, in the user's
 * priority order. `color` is a flag/identity-leaning tint for badges.
 */
export const CURRENCIES = [
  { code: 'GLD', name: 'Gold (Thai baht-gold)', color: '#D4A017' },
  { code: 'THB', name: 'Thai Baht', color: '#0891B2' },
  { code: 'MMK', name: 'Myanmar Kyat', color: '#059669' },
  { code: 'USD', name: 'US Dollar', color: '#2563EB' },
  { code: 'EUR', name: 'Euro', color: '#7C3AED' },
  { code: 'AUD', name: 'Australian Dollar', color: '#0D9488' },
  { code: 'GBP', name: 'British Pound', color: '#4F46E5' },
  { code: 'JPY', name: 'Japanese Yen', color: '#DC2626' },
  { code: 'CNY', name: 'Chinese Yuan', color: '#EA580C' },
  { code: 'INR', name: 'Indian Rupee', color: '#D97706' },
  { code: 'SGD', name: 'Singapore Dollar', color: '#DB2777' },
  { code: 'CAD', name: 'Canadian Dollar', color: '#E11D48' },
  { code: 'CHF', name: 'Swiss Franc', color: '#B91C1C' },
] as const

/** Badge tint for a currency code (falls back to a neutral gray). */
export function currencyColor(code: string): string {
  return CURRENCIES.find((c) => c.code === code)?.color ?? '#6b7280'
}
