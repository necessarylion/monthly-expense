import { CalendarDaysIcon, ChevronLeftIcon, ChevronRightIcon, XIcon } from 'lucide-react'
import { useEffect, useMemo, useRef, useState } from 'react'
import { CategoryIcon } from '@/components/app/category-icon'
import { ConfirmDialog } from '@/components/app/confirm-dialog'
import { Money } from '@/components/app/money'
import { Sparkline } from '@/components/app/sparkline'
import { Button } from '@/components/ui/button'
import { toast } from '@/components/ui/toast'
import { type MonthCompare, useMonthCompare } from '@/hooks/use-month-compare'
import { type QuickAdd, useQuickAdds } from '@/hooks/use-quick-adds'
import { errorMessage } from '@/lib/errors'
import { currentMonthKey, formatMoneyCompactFromCents, formatMoneyFromCents, formatShortDate, todayIso } from '@/lib/format'
import { useLocale, useT } from '@/lib/i18n'
import { buildRows, monthDayCount, monthTodayIndex, NO_CATEGORY_ID, tintFg } from '@/lib/overview'
import type { Category, Expense, Group } from '@/lib/types'
import { cn } from '@/lib/utils'
import { useCategoryById, useExpenses } from '@/stores/expenses'
import { useAuth } from '@/stores/auth'
import { useActiveGroup, useGroups } from '@/stores/groups'
import { useUi } from '@/stores/ui'
import { MonthInsightButton } from '@/sheets/month-insight-sheet'
import { SmartAddButton } from '@/sheets/smart-add-sheet'
import { Page } from './page'
import { SettleCard } from './reports'

/** Bucket an expense's category: unknown or missing ids all go to "no category". */
function bucketOf(e: Expense, known: Map<number, Category>): number {
  return e.categoryId !== null && known.has(e.categoryId) ? e.categoryId : NO_CATEGORY_ID
}

/* ---------- 1. How much can I spend? ---------- */

/** Days from `from` to `to` (both `YYYY-MM-DD`); same day is 0. */
function daysBetween(from: string, to: string): number {
  return Math.round((Date.parse(`${to}T00:00:00Z`) - Date.parse(`${from}T00:00:00Z`)) / 86_400_000)
}

function Allowance({ currency, group }: { currency: string; group: Group | null }) {
  const t = useT()
  const month = useExpenses((s) => s.month)
  const summary = useExpenses((s) => s.summary)
  const expenses = useExpenses((s) => s.expenses)
  const goToBudget = useUi((s) => s.goToBudget)
  const openGroups = useUi((s) => s.openGroups)
  const trip = group?.kind === 'trip'

  const spent = summary?.totalCents ?? 0
  const budget = summary?.monthlyBudgetCents ?? 0
  const remaining = budget - spent
  // The days the budget is spread over: the month, or the trip (when its days are set).
  const first = trip ? group?.tripStart : `${month}-01`
  const days = trip ? (group?.tripDays ?? 0) : monthDayCount(month)
  const hasSpan = !!first && days > 0
  /** 1 on the first day; below 1 before it starts, above `days` after it ends. */
  const todayIndex = hasSpan ? daysBetween(first, todayIso()) + 1 : 0
  const today = todayIndex >= 1 && todayIndex <= days ? todayIndex : null
  const isPast = hasSpan && todayIndex > days
  const trend = useMemo(() => {
    // Through today, or every day once it is over; nothing before it starts.
    const last = isPast ? days : today
    if (!last || !first) return []
    const daily = new Array<number>(last).fill(0)
    for (const e of expenses) {
      const d = daysBetween(first, e.occurredOn) + 1
      if (d >= 1 && d <= last) daily[d - 1] += e.amountCents
    }
    // With a budget: what is left after each day, starting from the full budget. Without: spent so far.
    let running = budget > 0 ? budget : 0
    const out = [running]
    for (const v of daily) {
      running += budget > 0 ? -v : v
      out.push(running)
    }
    return out
  }, [expenses, first, budget, days, today, isPast])
  const ratio = budget > 0 ? Math.min(1, spent / budget) : 0
  const spentOf = t('home.spentOf', { spent: formatMoneyFromCents(spent, currency), budget: formatMoneyFromCents(budget, currency) })

  let label: string
  let cents: number
  let tone = ''
  let detail: string

  if (budget <= 0) {
    label = trip ? t('reports.tripSpent') : t('home.spentThisMonth')
    cents = spent
    detail = ''
  } else if (remaining < 0) {
    label = t('home.overBudget')
    cents = -remaining
    tone = 'text-destructive'
    detail = spentOf
  } else if (!hasSpan) {
    // A trip without its days: no daily budget yet.
    label = t('reports.tripLeft')
    cents = remaining
    detail = spentOf
  } else if (isPast) {
    label = t('home.leftOver')
    cents = remaining
    detail = spentOf
  } else {
    // Spread what is left (before today's spending) over the days still to come, today included.
    const spentToday = today ? expenses.filter((e) => e.occurredOn === todayIso()).reduce((n, e) => n + e.amountCents, 0) : 0
    const daysLeft = today ? days - today + 1 : days
    const share = Math.floor((remaining + spentToday) / daysLeft)
    const leftToday = share - spentToday
    if (leftToday >= 0) {
      label = today ? t('home.canSpendToday') : t('home.dailyShare')
      cents = today ? leftToday : share
    } else {
      label = t('home.overToday')
      cents = -leftToday
      tone = 'text-destructive'
    }
    detail = t('home.leftOfDays', { left: formatMoneyFromCents(remaining, currency), n: daysLeft })
  }

  return (
    <section className="flex flex-col gap-3 pt-3">
      <div className="relative flex flex-col">
        <Sparkline
          values={trend}
          className={cn('pointer-events-none absolute inset-x-0 bottom-1 h-16 w-full', remaining < 0 ? 'text-destructive/35' : 'text-primary/35')}
        />
        <span className="text-base font-medium text-muted-foreground">{label}</span>
        <Money cents={cents} currency={currency} whole className={cn('num text-[4.5rem] leading-none font-bold', tone)} />
      </div>
      {budget > 0 ? (
        <>
          <div className="relative h-2 overflow-hidden rounded-full bg-muted" role="progressbar" aria-valuenow={Math.round(ratio * 100)} aria-label={t('budget.progressAria')}>
            <div
              className={cn('h-full rounded-full transition-[width] duration-700', remaining < 0 ? 'bg-destructive' : 'bg-primary')}
              style={{ width: `${Math.max(spent > 0 ? 2 : 0, ratio * 100)}%` }}
            />
          </div>
          <p className="text-sm text-muted-foreground tabular-nums">{detail}</p>
          {trip && !hasSpan && (
            <button type="button" onClick={() => openGroups('manage')} className="self-start text-sm font-medium text-foreground underline decoration-primary decoration-2 underline-offset-4">
              {t('reports.tripDaysHint')}
            </button>
          )}
        </>
      ) : (
        <button type="button" onClick={goToBudget} className="self-start text-sm font-medium text-foreground underline decoration-primary decoration-2 underline-offset-4">
          {trip ? t('reports.tripBudgetHint') : t('home.setBudgetHint')}
        </button>
      )}
    </section>
  )
}

/* ---------- 2. The month at a glance ---------- */

function MonthCalendar({
  totals,
  selectedDay,
  onSelect,
  currency,
}: {
  totals: number[]
  selectedDay: number | null
  onSelect(day: number | null): void
  currency: string
}) {
  const month = useExpenses((s) => s.month)
  const locale = useLocale((s) => s.locale)
  const today = monthTodayIndex(month)
  const isFuture = month > currentMonthKey()
  const [y, m] = month.split('-').map(Number)
  // Monday first: Sunday (0) becomes column 7.
  const lead = (new Date(y, m - 1, 1).getDay() + 6) % 7
  const peak = Math.max(0, ...totals)
  const weekdays = useMemo(() => {
    const fmt = new Intl.DateTimeFormat(locale, { weekday: 'narrow' })
    // 2024-01-01 was a Monday.
    return Array.from({ length: 7 }, (_, i) => fmt.format(new Date(2024, 0, 1 + i)))
  }, [locale])

  return (
    <section className="rounded-lg bg-card p-3 ring-1 ring-border">
      <div className="grid grid-cols-7 gap-1 pb-1 text-center text-[11px] font-medium text-muted-foreground">
        {weekdays.map((w, i) => (
          <span key={i}>{w}</span>
        ))}
      </div>
      <div className="grid grid-cols-7 gap-1">
        {Array.from({ length: lead }, (_, i) => (
          <span key={`lead-${i}`} />
        ))}
        {totals.map((value, i) => {
          const day = i + 1
          const future = isFuture || (today !== null && day > today)
          const selected = selectedDay === day
          // Saffron gets stronger with spending; empty days stay plain.
          const strength = value > 0 && peak > 0 ? 18 + Math.round((value / peak) * 72) : 0
          return (
            <button
              key={day}
              type="button"
              disabled={future}
              aria-pressed={selected}
              aria-label={`${day}: ${formatMoneyFromCents(value, currency)}`}
              onClick={() => onSelect(selected ? null : day)}
              className={cn(
                'relative flex h-12 flex-col items-center justify-center rounded-lg tabular-nums transition-[box-shadow,transform] active:scale-95 disabled:opacity-35',
                selected && 'ring-2 ring-ink ring-offset-2 ring-offset-card'
              )}
              style={{
                background: strength ? `color-mix(in srgb, var(--primary) ${strength}%, transparent)` : 'var(--muted)',
              }}
            >
              <span className={cn('text-sm leading-tight', today === day && 'font-bold')}>{day}</span>
              <span className="max-w-full truncate text-[9px] leading-tight opacity-70">{value > 0 ? formatMoneyCompactFromCents(value) : ' '}</span>
              {today === day && <span className="absolute top-1 right-1 size-1 rounded-full bg-ink" />}
            </button>
          )
        })}
      </div>
    </section>
  )
}

/** One line: how this month compares with last month so far. */
function CompareLine({ compare, currency }: { compare: MonthCompare | null; currency: string }) {
  const t = useT()
  const locale = useLocale((s) => s.locale)
  if (!compare || compare.diffCents === 0) return null
  const [y, m] = compare.previous.split('-').map(Number)
  const monthName = new Intl.DateTimeFormat(locale, { month: 'long' }).format(new Date(y, m - 1, 1))
  const less = compare.diffCents < 0
  const params = { amount: formatMoneyFromCents(Math.abs(compare.diffCents), currency), month: monthName, day: compare.upToDay ?? 0 }
  const key = compare.upToDay === null ? (less ? 'home.lessThanMonth' : 'home.moreThanMonth') : less ? 'home.lessThanByDay' : 'home.moreThanByDay'
  return (
    <p className={cn('-mt-3 flex items-center gap-1.5 text-sm font-medium', less ? 'text-success' : 'text-destructive')}>
      <span aria-hidden="true">{less ? '↓' : '↑'}</span>
      {t(key, params)}
    </p>
  )
}

/** Local date -> `YYYY-MM-DD`. */
function isoOf(d: Date): string {
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
}

/** Monday of the week that holds `iso`. */
function mondayOf(iso: string): Date {
  const [y, m, d] = iso.split('-').map(Number)
  const date = new Date(y, m - 1, d)
  date.setDate(date.getDate() - ((date.getDay() + 6) % 7))
  return date
}

/**
 * One week at a time over the days `from`..`to` (a month, or a whole trip).
 * A monthly group can open the month calendar.
 */
function WeekStrip({
  from,
  to,
  totals,
  selected,
  onSelect,
  currency,
  calendarMonth,
}: {
  from: string
  to: string
  /** Spent per `YYYY-MM-DD`. */
  totals: Map<string, number>
  selected: string | null
  onSelect(iso: string | null): void
  currency: string
  /** `YYYY-MM` when the full month calendar is available. */
  calendarMonth?: string
}) {
  const t = useT()
  const locale = useLocale((s) => s.locale)
  const today = todayIso()
  // Start on the picked day, else today, else the nearest end of the range.
  const anchor = selected ?? (today < from ? from : today > to ? to : today)
  const range = `${from}|${to}`
  const [week, setWeek] = useState(() => ({ range, start: mondayOf(anchor) }))
  const [expanded, setExpanded] = useState(false)
  if (week.range !== range) setWeek({ range, start: mondayOf(anchor) })

  const cells = Array.from({ length: 7 }, (_, i) => {
    const d = new Date(week.start)
    d.setDate(d.getDate() + i)
    return d
  })
  const peak = Math.max(0, ...totals.values())
  const weekday = new Intl.DateTimeFormat(locale, { weekday: 'narrow' })

  const canPrev = isoOf(cells[0]) > from
  const canNext = isoOf(cells[6]) < to
  const touch = useRef<{ x: number; y: number } | null>(null)

  function move(by: number) {
    const start = new Date(week.start)
    start.setDate(start.getDate() + by * 7)
    setWeek({ range, start })
  }

  function onTouchStart(e: React.TouchEvent) {
    touch.current = { x: e.touches[0].clientX, y: e.touches[0].clientY }
  }

  /** A sideways swipe of 40px or more moves one week, like the arrows. */
  function onTouchEnd(e: React.TouchEvent) {
    if (!touch.current) return
    const dx = e.changedTouches[0].clientX - touch.current.x
    const dy = e.changedTouches[0].clientY - touch.current.y
    touch.current = null
    if (Math.abs(dx) < 40 || Math.abs(dx) < Math.abs(dy)) return
    if (dx < 0 && canNext) move(1)
    if (dx > 0 && canPrev) move(-1)
  }

  if (expanded && calendarMonth) {
    const days = monthDayCount(calendarMonth)
    const monthTotals = Array.from({ length: days }, (_, i) => totals.get(`${calendarMonth}-${String(i + 1).padStart(2, '0')}`) ?? 0)
    const selectedDay = selected?.startsWith(calendarMonth) ? Number(selected.slice(8, 10)) : null
    return (
      <div className="flex flex-col gap-2">
        <MonthCalendar
          totals={monthTotals}
          selectedDay={selectedDay}
          onSelect={(day) => onSelect(day === null ? null : `${calendarMonth}-${String(day).padStart(2, '0')}`)}
          currency={currency}
        />
        <Button variant="ghost" size="sm" className="self-center rounded-lg" onClick={() => setExpanded(false)}>
          {t('home.showWeek')}
        </Button>
      </div>
    )
  }

  return (
    <section className="flex items-center gap-1 rounded-lg bg-card p-2 ring-1 ring-border">
      <button type="button" aria-label={t('home.previousWeek')} disabled={!canPrev} onClick={() => move(-1)} className="flex h-16 w-6 items-center justify-center text-muted-foreground disabled:opacity-25">
        <ChevronLeftIcon className="size-4" />
      </button>
      {/* touch-pan-y: the page still scrolls up and down; sideways is our swipe. */}
      <div className="grid flex-1 touch-pan-y grid-cols-7 gap-1" onTouchStart={onTouchStart} onTouchEnd={onTouchEnd}>
        {cells.map((date) => {
          const iso = isoOf(date)
          const inRange = iso >= from && iso <= to
          const value = inRange ? (totals.get(iso) ?? 0) : 0
          // A future day is only worth a tap when something is booked on it.
          const future = iso > today && value === 0
          const isSelected = selected === iso
          const day = date.getDate()
          return (
            <button
              key={iso}
              type="button"
              disabled={!inRange || future}
              aria-pressed={isSelected}
              aria-label={`${formatShortDate(iso)}: ${formatMoneyFromCents(value, currency)}`}
              onClick={() => onSelect(isSelected ? null : iso)}
              className={cn(
                'flex h-16 flex-col items-center justify-between rounded-lg py-1.5 transition-colors disabled:opacity-30',
                isSelected ? 'bg-ink text-ink-foreground' : 'active:bg-muted'
              )}
            >
              <span className={cn('text-[11px]', isSelected ? 'opacity-70' : 'text-muted-foreground')}>{weekday.format(date)}</span>
              <span className={cn('text-sm tabular-nums', iso === today && 'font-bold')}>{day}</span>
              {/* Amount spent; stronger on bigger days. */}
              <span
                className={cn('max-w-full truncate text-[10px] leading-none tabular-nums', isSelected ? 'text-ink-foreground' : 'text-primary')}
                style={{ opacity: isSelected ? 0.85 : value > 0 && peak > 0 ? 0.6 + (value / peak) * 0.4 : 0 }}
              >
                {value > 0 ? formatMoneyCompactFromCents(value) : ' '}
              </span>
            </button>
          )
        })}
      </div>
      <div className="flex flex-col items-center">
        <button type="button" aria-label={t('home.nextWeek')} disabled={!canNext} onClick={() => move(1)} className="flex h-8 w-6 items-center justify-center text-muted-foreground disabled:opacity-25">
          <ChevronRightIcon className="size-4" />
        </button>
        {calendarMonth && (
          <button type="button" aria-label={t('home.showMonth')} onClick={() => setExpanded(true)} className="flex h-8 w-6 items-center justify-center text-muted-foreground">
            <CalendarDaysIcon className="size-4" />
          </button>
        )}
      </div>
    </section>
  )
}

/* ---------- 3. One-tap repeats ---------- */

function QuickAddChip({ q, category, currency }: { q: QuickAdd; category?: Category; currency: string }) {
  const t = useT()
  const openExpense = useUi((s) => s.openExpense)
  const timer = useRef<ReturnType<typeof setTimeout> | null>(null)
  const longPressed = useRef(false)
  const [busy, setBusy] = useState(false)
  const [confirming, setConfirming] = useState(false)
  const label = q.note || category?.name || ''
  const amount = formatMoneyFromCents(q.amountCents, currency)

  function startPress() {
    longPressed.current = false
    timer.current = setTimeout(() => {
      longPressed.current = true
      openExpense(null, { categoryId: q.categoryId, amount: q.amountCents / 100, note: q.note })
    }, 450)
  }

  function endPress() {
    if (timer.current) clearTimeout(timer.current)
  }

  /** A tap only asks first: a stray touch while scrolling must not add an expense. */
  function tap() {
    if (longPressed.current || busy) return
    if (q.categoryId === null) {
      openExpense(null, { categoryId: null, amount: q.amountCents / 100, note: q.note })
      return
    }
    setConfirming(true)
  }

  async function add() {
    if (q.categoryId === null) return
    setBusy(true)
    try {
      const store = useExpenses.getState()
      const created = await store.addExpense({
        categoryId: q.categoryId,
        amount: q.amountCents / 100,
        occurredOn: todayIso(),
        note: q.note ?? undefined,
      })
      toast.success(t('home.added', { what: label, amount }), {
        action: {
          label: t('home.undo'),
          onClick: () => void useExpenses.getState().deleteExpense(created.id),
        },
      })
    } catch (e) {
      toast.error(errorMessage(e, t('expenseModal.failedToSave')))
    } finally {
      setBusy(false)
      setConfirming(false)
    }
  }

  return (
    <>
    <button
      type="button"
      onPointerDown={startPress}
      onPointerUp={endPress}
      onPointerLeave={endPress}
      onContextMenu={(e) => e.preventDefault()}
      onClick={tap}
      disabled={busy}
      className="flex shrink-0 items-center gap-2 rounded-lg bg-card py-2 pr-3.5 pl-2 text-left ring-1 ring-border transition-transform select-none active:scale-95 disabled:opacity-60"
    >
      <CategoryIcon iconKey={category?.iconKey ?? null} color={category?.color ?? null} size={32} />
      <span className="flex flex-col leading-tight">
        <span className="max-w-28 truncate text-sm font-medium">{q.note || category?.name || t('overview.noCategory')}</span>
        <span className="num text-sm text-muted-foreground">{amount}</span>
      </span>
    </button>
    <ConfirmDialog
      open={confirming}
      title={t('home.confirmAddTitle')}
      message={t('home.confirmAddMessage', { what: label, amount })}
      confirmLabel={t('home.confirmAdd')}
      loading={busy}
      onConfirm={() => void add()}
      onCancel={() => setConfirming(false)}
    />
    </>
  )
}

function QuickAdds({ currency }: { currency: string }) {
  const t = useT()
  const quick = useQuickAdds()
  const categoryById = useCategoryById()
  if (quick.length === 0) return null
  return (
    <section className="flex flex-col gap-2">
      <h2 className="font-display text-lg font-semibold">{t('home.quickAdd')}</h2>
      <div className="no-scrollbar -mx-4 flex gap-2 overflow-x-auto px-4 py-1">
        {quick.map((q) => (
          <QuickAddChip key={`${q.categoryId}-${q.amountCents}-${q.note}`} q={q} category={q.categoryId === null ? undefined : categoryById.get(q.categoryId)} currency={currency} />
        ))}
      </div>
      <p className="text-xs text-muted-foreground">{t('home.quickAddHint')}</p>
    </section>
  )
}

/* ---------- 4. Where it went ---------- */

/** "↑ 20%" in red (spending more), "↓ 45%" in green, "new" when last month had none. */
function ChangeBadge({ change }: { change: number | 'new' | undefined }) {
  const t = useT()
  if (change === undefined || change === 0) return null
  if (change === 'new') return <span className="text-xs font-medium text-muted-foreground">{t('home.newThisMonth')}</span>
  const up = change > 0
  return (
    <span className={cn('text-xs font-semibold tabular-nums', up ? 'text-destructive' : 'text-success')}>
      {up ? '↑' : '↓'} {Math.abs(change)}%
    </span>
  )
}

function CategoryBar({
  selected,
  onSelect,
  currency,
  compare,
}: {
  selected: number | null
  onSelect(id: number | null): void
  currency: string
  compare: MonthCompare | null
}) {
  const t = useT()
  const categories = useExpenses((s) => s.categories)
  const summary = useExpenses((s) => s.summary)
  const [showAll, setShowAll] = useState(false)
  const total = summary?.totalCents ?? 0
  const rows = buildRows(categories, summary?.byCategory ?? [], total, t('overview.noCategory')).filter((r) => r.totalCents > 0)
  if (rows.length === 0) return null
  const shown = showAll ? rows : rows.slice(0, 4)

  return (
    <section className="flex flex-col gap-3">
      <h2 className="font-display text-lg font-semibold">{t('home.whereItWent')}</h2>
      <div className="flex h-3 gap-0.5 overflow-hidden rounded-full" aria-hidden="true">
        {rows.map((r) => (
          <span
            key={r.id}
            className="h-full transition-opacity first:rounded-l-full last:rounded-r-full"
            style={{ flexGrow: r.totalCents, background: tintFg(r.color), opacity: selected === null || selected === r.id ? 1 : 0.25 }}
          />
        ))}
      </div>
      <ul className="flex flex-col">
        {shown.map((r) => {
          const active = selected === r.id
          const budget = categories.find((c) => c.id === r.id)?.budgetCents ?? null
          const used = budget ? r.totalCents / budget : 0
          return (
            <li key={r.id}>
              <button
                type="button"
                aria-pressed={active}
                onClick={() => onSelect(active ? null : r.id)}
                className={cn('-mx-2 flex w-[calc(100%+1rem)] items-center gap-3 rounded-lg px-2 py-2 text-left transition-colors', active ? 'bg-accent' : 'hover:bg-muted/60')}
              >
                <CategoryIcon iconKey={r.iconKey} color={r.color} size={34} />
                <span className="flex min-w-0 flex-1 flex-col">
                  <span className="truncate text-[15px] font-medium">{r.name}</span>
                  <span className="flex items-center gap-2 text-xs text-muted-foreground tabular-nums">
                    {r.percent}%
                    <ChangeBadge change={compare?.byCategory.get(r.id)} />
                    {budget !== null && budget > 0 && (
                      <span className={cn('font-medium', used > 1 ? 'text-destructive' : used >= 0.8 ? 'text-amber-600 dark:text-amber-400' : '')}>
                        {t('reports.ofBudget', { spent: formatMoneyFromCents(r.totalCents, currency), budget: formatMoneyFromCents(budget, currency) })}
                      </span>
                    )}
                  </span>
                </span>
                <span className="num w-24 text-right text-base font-semibold">{formatMoneyFromCents(r.totalCents, currency)}</span>
              </button>
            </li>
          )
        })}
      </ul>
      {rows.length > 4 && (
        <Button variant="ghost" size="sm" className="self-start rounded-lg" onClick={() => setShowAll(!showAll)}>
          {showAll ? t('home.showLess') : t('home.showAll', { n: rows.length })}
        </Button>
      )}
    </section>
  )
}

/* ---------- 5. Every expense, by day ---------- */

function ExpenseList({
  list,
  currency,
  filters,
  payerName,
}: {
  list: Expense[]
  currency: string
  filters: React.ReactNode
  /** Set when the group splits costs: who paid each expense. */
  payerName?: (e: Expense) => string | null
}) {
  const t = useT()
  const categoryById = useCategoryById()
  const openDetail = useUi((s) => s.openExpenseDetail)

  const groups = useMemo(() => {
    const out: { date: string; total: number; items: Expense[] }[] = []
    for (const e of list) {
      const last = out[out.length - 1]
      if (last && last.date === e.occurredOn) {
        last.items.push(e)
        last.total += e.amountCents
      } else out.push({ date: e.occurredOn, total: e.amountCents, items: [e] })
    }
    return out
  }, [list])

  return (
    <section className="flex flex-col gap-2">
      <div className="flex items-center justify-between gap-2">
        <h2 className="font-display text-lg font-semibold">{t('transactions.title')}</h2>
        {filters}
      </div>
      {groups.length === 0 && <p className="rounded-lg bg-muted/60 p-6 text-center text-sm text-muted-foreground">{t('home.nothingHere')}</p>}
      {groups.map((g) => (
        <div key={g.date} className="flex flex-col">
          <div className="flex items-baseline justify-between px-1 pt-2 pb-1 text-sm text-muted-foreground">
            <span className="font-medium">{formatShortDate(g.date)}</span>
            <span className="tabular-nums">{formatMoneyFromCents(g.total, currency)}</span>
          </div>
          <ul className="flex flex-col overflow-hidden rounded-lg bg-card ring-1 ring-border">
            {g.items.map((e) => {
              const category = e.categoryId === null ? undefined : categoryById.get(e.categoryId)
              return (
                <li key={e.id} className="border-b border-border/70 last:border-b-0">
                  <button type="button" onClick={() => openDetail(e)} className="flex w-full items-center gap-3 px-3 py-2.5 text-left transition-colors active:bg-muted">
                    <CategoryIcon iconKey={category?.iconKey ?? null} color={category?.color ?? null} size={38} />
                    <span className="flex min-w-0 flex-1 flex-col">
                      <span className="truncate text-[15px] font-medium">{e.note || category?.name || t('overview.noCategory')}</span>
                      {(e.note || payerName) && (
                        <span className="truncate text-xs text-muted-foreground">
                          {[e.note ? (category?.name ?? t('overview.noCategory')) : null, payerName?.(e)].filter(Boolean).join(' · ')}
                        </span>
                      )}
                    </span>
                    <span className="num text-base font-semibold">{formatMoneyFromCents(e.amountCents, currency)}</span>
                  </button>
                </li>
              )
            })}
          </ul>
        </div>
      ))}
    </section>
  )
}

function FilterChip({ label, onClear }: { label: string; onClear(): void }) {
  return (
    <button type="button" onClick={onClear} className="flex items-center gap-1 rounded-md bg-ink py-1 pr-2 pl-3 text-xs font-medium text-ink-foreground">
      {label}
      <XIcon className="size-3.5" />
    </button>
  )
}

export function HomeScreen() {
  const t = useT()
  const month = useExpenses((s) => s.month)
  const expenses = useExpenses((s) => s.expenses)
  const lastError = useExpenses((s) => s.lastError)
  const categoryById = useCategoryById()
  const group = useActiveGroup()
  const currency = group?.currency ?? 'USD'
  const trip = group?.kind === 'trip'
  const split = group?.splitEnabled ?? false
  const members = useGroups((s) => s.members)
  const me = useAuth((s) => s.user?.id)
  const compare = useMonthCompare()
  /** The picked day, `YYYY-MM-DD`. */
  const [day, setDay] = useState<string | null>(null)
  const [category, setCategory] = useState<number | null>(null)

  // Filters belong to one month; drop them when the month changes.
  const [filterMonth, setFilterMonth] = useState(month)
  if (filterMonth !== month) {
    setFilterMonth(month)
    setDay(null)
    setCategory(null)
  }

  // Who paid shows by name, so the members must be loaded.
  const groupId = group?.id
  useEffect(() => {
    if (split && groupId) useGroups.getState().loadMembers(groupId).catch(() => {})
  }, [split, groupId])

  // The strip and the calendar show the picked month; a trip's totals still count every day.
  const from = `${month}-01`
  const to = `${month}-${String(monthDayCount(month)).padStart(2, '0')}`

  const totals = useMemo(() => {
    const out = new Map<string, number>()
    for (const e of expenses) {
      if (category !== null && bucketOf(e, categoryById) !== category) continue
      out.set(e.occurredOn, (out.get(e.occurredOn) ?? 0) + e.amountCents)
    }
    return out
  }, [expenses, category, categoryById])

  const list = expenses.filter((e) => (day === null || e.occurredOn === day) && (category === null || bucketOf(e, categoryById) === category))
  const categoryName = category === null ? null : category === NO_CATEGORY_ID ? t('overview.noCategory') : categoryById.get(category)?.name
  const emailById = new Map(members.filter((m) => m.userId !== null).map((m) => [m.userId as number, m.email]))
  const payerName = split
    ? (e: Expense) => {
        if (e.paidByUserId === null) return null
        const who = e.paidByUserId === me ? t('common.you').replace(/[()]/g, '') : (emailById.get(e.paidByUserId) ?? '').split('@')[0]
        return who ? t('reports.paidByName', { name: who }) : null
      }
    : undefined

  return (
    // Phone: one column. Desktop: summary on the left, the list on the right.
    <Page className="gap-6 lg:max-w-6xl lg:flex-row lg:items-start lg:gap-10">
      <div className="flex min-w-0 flex-col gap-6 lg:flex-1">
        <Allowance currency={currency} group={group} />
        {!trip && <CompareLine compare={compare} currency={currency} />}
        <div className="flex flex-wrap gap-2">
          <SmartAddButton />
          {!trip && <MonthInsightButton month={month} />}
        </div>
        {lastError && <p className="text-sm text-destructive">{lastError}</p>}
        <QuickAdds currency={currency} />
        <CategoryBar selected={category} onSelect={setCategory} currency={currency} compare={compare} />
        <SettleCard />
      </div>
      <div className="flex min-w-0 flex-col gap-6 lg:flex-1">
      {/* The day picker sits right above the list it filters. */}
      <WeekStrip from={from} to={to} totals={totals} selected={day} onSelect={setDay} currency={currency} calendarMonth={month} />
      <ExpenseList
        list={list}
        currency={currency}
        payerName={payerName}
        filters={
          (day !== null || category !== null) && (
            <div className="flex gap-1.5">
              {day !== null && <FilterChip label={formatShortDate(day)} onClear={() => setDay(null)} />}
              {categoryName && <FilterChip label={categoryName} onClear={() => setCategory(null)} />}
            </div>
          )
        }
      />
      </div>
    </Page>
  )
}
