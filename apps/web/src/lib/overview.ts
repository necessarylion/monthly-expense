import { currentMonthKey } from './format'
import type { Category, MonthlySummary } from './types'

/** "No category" bucket id. */
export const NO_CATEGORY_ID = 0

export interface CategoryRow {
  id: number
  name: string
  iconKey: string
  /** null == the "no category" bucket, drawn in `--muted-foreground`. */
  color: string | null
  totalCents: number
  count: number
  ratio: number
  percent: number
  avgCents: number
}

/**
 * Every category (zero-spend ones last, then alphabetical) plus a "no category"
 * row when it has spend. The spine is the same list filtered to spend > 0.
 */
export function buildRows(
  categories: Category[],
  byCategory: MonthlySummary['byCategory'],
  totalCents: number,
  noCategoryLabel: string
): CategoryRow[] {
  const totals = new Map<number, { cents: number; count: number }>()
  const other = { cents: 0, count: 0 }
  const known = new Set(categories.map((c) => c.id))

  for (const r of byCategory) {
    if (r.categoryId === null || !known.has(r.categoryId)) {
      other.cents += r.totalCents
      other.count += r.count
      continue
    }
    const hit = totals.get(r.categoryId) ?? { cents: 0, count: 0 }
    totals.set(r.categoryId, { cents: hit.cents + r.totalCents, count: hit.count + r.count })
  }

  const total = totalCents > 0 ? totalCents : 1
  const make = (
    id: number,
    name: string,
    iconKey: string,
    color: string | null,
    cents: number,
    count: number
  ): CategoryRow => ({
    id,
    name,
    iconKey,
    color,
    totalCents: cents,
    count,
    ratio: cents / total,
    percent: Math.round((cents / total) * 100),
    avgCents: count > 0 ? Math.round(cents / count) : 0,
  })

  const rows = categories.map((c) => {
    const hit = totals.get(c.id) ?? { cents: 0, count: 0 }
    return make(c.id, c.name, c.iconKey, c.color, hit.cents, hit.count)
  })
  rows.sort((a, b) =>
    a.totalCents === b.totalCents ? a.name.localeCompare(b.name) : b.totalCents - a.totalCents
  )

  if (other.cents > 0) {
    rows.push(make(NO_CATEGORY_ID, noCategoryLabel, '', null, other.cents, other.count))
  }
  return rows
}

/** Tinted fill for icon chips / bars. `null` colour falls back to the muted token. */
export function tintFg(color: string | null): string {
  return color ?? 'var(--muted-foreground)'
}

export function tintBg(color: string | null, percent = 16): string {
  return `color-mix(in srgb, ${tintFg(color)} ${percent}%, transparent)`
}

/** 28…31 for a "YYYY-MM" key. */
export function monthDayCount(month: string): number {
  const [y, m] = month.split('-').map(Number)
  if (!y || !m) return 30
  return new Date(y, m, 0).getDate()
}

/** 1-based day of the month today, or null when `month` isn't the current one. */
export function monthTodayIndex(month: string): number | null {
  return month === currentMonthKey() ? new Date().getDate() : null
}

/** Where the month is "supposed" to be: 0…1. Past months are done, future ones haven't started. */
export function monthElapsed(month: string): number {
  const today = monthTodayIndex(month)
  if (today !== null) return Math.min(1, today / monthDayCount(month))
  return month < currentMonthKey() ? 1 : 0
}
