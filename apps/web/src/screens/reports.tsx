import { ChevronLeftIcon, ChevronRightIcon, DownloadIcon, PlusIcon, RepeatIcon, SearchIcon } from 'lucide-react'
import { useEffect, useState } from 'react'
import { CategoryIcon } from '@/components/app/category-icon'
import { DateField } from '@/components/app/date-picker'
import { ErrorText, Section } from '@/components/app/section'
import { SelectField } from '@/components/app/select-field'
import { Button } from '@/components/ui/button'
import { DeleteButton } from '@/components/ui/delete-button'
import { Input } from '@/components/ui/input'
import { InputGroup, InputGroupAddon, InputGroupInput, InputGroupText } from '@/components/ui/input-group'
import { toast } from '@/components/ui/toast'
import { api } from '@/lib/api'
import { errorMessage } from '@/lib/errors'
import { currencySymbol, formatMoneyFromCents, formatShortDate, monthLabel, todayIso } from '@/lib/format'
import { useT } from '@/lib/i18n'
import { tintFg } from '@/lib/overview'
import type { Expense, MonthBalances, RecurringExpense, YearlySummary } from '@/lib/types'
import { useAccounts } from '@/stores/accounts'
import { useAuth } from '@/stores/auth'
import { useCategoryById, useExpenses } from '@/stores/expenses'
import { useActiveGroup, useGroups } from '@/stores/groups'
import { useUi } from '@/stores/ui'

/** The API caps search results at this many (`searchResultLimit`). */
const SEARCH_LIMIT = 2000
const DEFAULT_WALLET = 'default'

function useCurrency(): string {
  return useActiveGroup()?.currency ?? 'USD'
}

/** `alice@gmail.com` -> `alice`, or "you". */
function useMemberName(): (userId: number, email: string) => string {
  const t = useT()
  const me = useAuth((s) => s.user?.id)
  return (userId, email) => (userId === me ? t('common.you').replace(/[()]/g, '') : email.split('@')[0] || email)
}

/** A small "< label >" switcher, for a month or a year. */
function Stepper({ label, onPrev, onNext, prevLabel, nextLabel }: { label: string; onPrev(): void; onNext(): void; prevLabel: string; nextLabel: string }) {
  return (
    <div className="flex items-center justify-center gap-2">
      <Button variant="ghost" size="icon" className="rounded-lg" aria-label={prevLabel} onClick={onPrev}>
        <ChevronLeftIcon />
      </Button>
      <span className="min-w-24 text-center text-base font-semibold tabular-nums">{label}</span>
      <Button variant="ghost" size="icon" className="rounded-lg" aria-label={nextLabel} onClick={onNext}>
        <ChevronRightIcon />
      </Button>
    </div>
  )
}

/* ---------- Recurring expenses ---------- */

export function RecurringPage() {
  const t = useT()
  const currency = useCurrency()
  const categories = useExpenses((s) => s.categories)
  const categoryById = useCategoryById()
  const accounts = useAccounts((s) => s.accounts)
  const activeId = useGroups((s) => s.activeId)
  const [rows, setRows] = useState<RecurringExpense[] | null>(null)
  const [categoryId, setCategoryId] = useState<string>('')
  const [amount, setAmount] = useState('')
  const [day, setDay] = useState(String(new Date().getDate()))
  const [note, setNote] = useState('')
  const [wallet, setWallet] = useState(DEFAULT_WALLET)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)

  async function load() {
    const { data } = await api.get<{ data: RecurringExpense[] }>('/recurring')
    setRows(data.data)
  }

  useEffect(() => {
    if (activeId) load().catch((e) => setError(errorMessage(e, t('reports.failedToLoad'))))
    // eslint-disable-next-line react-hooks/exhaustive-deps -- reload per group
  }, [activeId])

  useEffect(() => {
    if (!categoryId && categories[0]) setCategoryId(String(categories[0].id))
  }, [categories, categoryId])

  const num = Number(amount.replace(',', '.'))
  const dayNum = Number(day)
  const valid = !!categoryId && num > 0 && Number.isInteger(dayNum) && dayNum >= 1 && dayNum <= 31

  async function add() {
    if (!valid || saving) return
    setSaving(true)
    setError(null)
    try {
      await api.post('/recurring', {
        categoryId: Number(categoryId),
        amount: num,
        dayOfMonth: dayNum,
        note: note.trim() || undefined,
        accountId: wallet === DEFAULT_WALLET ? undefined : Number(wallet),
      })
      setAmount('')
      setNote('')
      toast.success(t('reports.recurringAdded'))
      await load()
      // Today's run adds an expense at once.
      await useExpenses.getState().loadMonth()
    } catch (e) {
      setError(errorMessage(e, t('settings.failedToSave')))
    } finally {
      setSaving(false)
    }
  }

  async function remove(id: number) {
    try {
      await api.delete(`/recurring/${id}`)
      setRows((list) => list?.filter((r) => r.id !== id) ?? null)
      toast.success(t('reports.recurringRemoved'))
    } catch (e) {
      setError(errorMessage(e, t('common.delete')))
    }
  }

  return (
    <>
      <Section title={t('reports.recurring')} description={t('reports.recurringNote')}>
        {rows === null ? (
          <p className="text-sm text-muted-foreground">{t('common.loading')}</p>
        ) : rows.length === 0 ? (
          <p className="text-sm text-muted-foreground">{t('reports.recurringNone')}</p>
        ) : (
          <ul className="flex flex-col divide-y divide-border/70">
            {rows.map((r) => {
              const category = r.categoryId === null ? undefined : categoryById.get(r.categoryId)
              return (
                <li key={r.id} className="flex items-center gap-3 py-2.5">
                  <CategoryIcon iconKey={category?.iconKey ?? null} color={category?.color ?? null} size={36} />
                  <div className="min-w-0 flex-1">
                    <p className="truncate text-[15px] font-medium">{r.note || category?.name || t('overview.noCategory')}</p>
                    <p className="text-xs text-muted-foreground">
                      {t('reports.everyMonth', { day: r.dayOfMonth })} · {t('reports.nextOn', { date: formatShortDate(r.nextOn) })}
                    </p>
                  </div>
                  <span className="num text-base font-semibold">{formatMoneyFromCents(r.amountCents, currency)}</span>
                  <DeleteButton onConfirm={() => void remove(r.id)} className="shrink-0" />
                </li>
              )
            })}
          </ul>
        )}
      </Section>

      <Section title={t('reports.newRecurring')}>
        <SelectField
          size="lg"
          className="w-full rounded-lg"
          aria-label={t('expenseModal.category')}
          value={categoryId}
          onChange={setCategoryId}
          options={categories.map((c) => ({ value: String(c.id), label: c.name }))}
        />
        <div className="flex gap-2">
          <InputGroup className="h-11 flex-1 rounded-lg">
            <InputGroupAddon>
              <InputGroupText>{currencySymbol(currency)}</InputGroupText>
            </InputGroupAddon>
            <InputGroupInput
              inputMode="decimal"
              aria-label={t('reports.amount')}
              placeholder={t('reports.amount')}
              value={amount}
              onChange={(e) => setAmount(e.target.value)}
              className="text-base tabular-nums"
            />
          </InputGroup>
          <InputGroup className="h-11 w-32 rounded-lg">
            <InputGroupAddon>
              <InputGroupText>{t('reports.day')}</InputGroupText>
            </InputGroupAddon>
            <InputGroupInput
              type="number"
              min={1}
              max={31}
              inputMode="numeric"
              aria-label={t('reports.dayOfMonth')}
              value={day}
              onChange={(e) => setDay(e.target.value)}
              className="text-base tabular-nums"
            />
          </InputGroup>
        </div>
        {Number.isInteger(dayNum) && dayNum >= 1 && dayNum <= 31 && (
          <p className="-mt-1 px-1 text-xs text-muted-foreground">{t('reports.everyMonth', { day: dayNum })}</p>
        )}
        {accounts.length > 0 && (
          <SelectField
            size="lg"
            className="w-full rounded-lg"
            aria-label={t('expenseModal.payFrom')}
            value={wallet}
            onChange={setWallet}
            options={[{ value: DEFAULT_WALLET, label: t('reports.defaultWallet') }, ...accounts.map((a) => ({ value: String(a.id), label: a.name }))]}
          />
        )}
        <Input
          value={note}
          maxLength={500}
          onChange={(e) => setNote(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && void add()}
          placeholder={t('expenseModal.notePlaceholder')}
          aria-label={t('expenseModal.note')}
          className="h-11 rounded-lg text-base sm:text-sm"
        />
        <ErrorText>{error}</ErrorText>
        <Button className="self-end rounded-lg" disabled={!valid || saving} onClick={() => void add()}>
          <PlusIcon />
          {saving ? t('common.saving') : t('reports.addRecurring')}
        </Button>
      </Section>
    </>
  )
}

/* ---------- Search and CSV export ---------- */

function csvCell(value: string): string {
  // A cell starting with = + - @ (or a tab / CR) runs as a formula in Excel.
  // A leading ' keeps it as text.
  const safe = /^[=+\-@\t\r]/.test(value) ? `'${value}` : value
  return /[",\n\r]/.test(safe) ? `"${safe.replace(/"/g, '""')}"` : safe
}

function downloadCsv(name: string, rows: string[][]) {
  // The BOM makes Excel read the file as UTF-8 (Burmese notes, symbols).
  const text = '﻿' + rows.map((r) => r.map(csvCell).join(',')).join('\r\n')
  const url = URL.createObjectURL(new Blob([text], { type: 'text/csv;charset=utf-8' }))
  const link = document.createElement('a')
  link.href = url
  link.download = name
  link.click()
  URL.revokeObjectURL(url)
}

export function SearchPage() {
  const t = useT()
  const currency = useCurrency()
  const categories = useExpenses((s) => s.categories)
  const categoryById = useCategoryById()
  const members = useGroups((s) => s.members)
  const activeId = useGroups((s) => s.activeId)
  const [q, setQ] = useState('')
  const [categoryId, setCategoryId] = useState('all')
  const [from, setFrom] = useState(`${todayIso().slice(0, 4)}-01-01`)
  const [to, setTo] = useState(todayIso())
  const [rows, setRows] = useState<Expense[] | null>(null)
  const [error, setError] = useState<string | null>(null)

  // Search as the filters change; a short wait while typing.
  useEffect(() => {
    if (!activeId) return
    let stale = false
    const timer = setTimeout(() => {
      api
        .get<{ data: Expense[] }>('/expenses/search', {
          params: { q: q.trim() || undefined, categoryId: categoryId === 'all' ? undefined : categoryId, from: from || undefined, to: to || undefined },
        })
        .then(({ data }) => {
          if (stale) return
          setRows(data.data)
          setError(null)
        })
        .catch((e) => !stale && setError(errorMessage(e, t('reports.failedToLoad'))))
    }, 250)
    return () => {
      stale = true
      clearTimeout(timer)
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps -- t is stable enough
  }, [q, categoryId, from, to, activeId])

  const total = rows?.reduce((sum, e) => sum + e.amountCents, 0) ?? 0

  function exportCsv() {
    if (!rows) return
    const emailById = new Map(members.filter((m) => m.userId !== null).map((m) => [m.userId as number, m.email]))
    const header = ['Date', 'Category', 'Note', `Amount (${currency})`, 'Paid by']
    const lines = rows.map((e) => [
      e.occurredOn,
      (e.categoryId === null ? undefined : categoryById.get(e.categoryId)?.name) ?? '',
      e.note ?? '',
      (e.amountCents / 100).toFixed(2),
      e.paidByUserId === null ? '' : (emailById.get(e.paidByUserId) ?? ''),
    ])
    downloadCsv(`expenses-${from || 'start'}-to-${to || 'today'}.csv`, [header, ...lines])
  }

  return (
    <>
      <div className="flex flex-col gap-2">
        <InputGroup className="h-11 rounded-lg">
          <InputGroupAddon>
            <SearchIcon />
          </InputGroupAddon>
          <InputGroupInput
            type="search"
            autoFocus
            value={q}
            onChange={(e) => setQ(e.target.value)}
            placeholder={t('reports.searchPlaceholder')}
            aria-label={t('reports.search')}
            className="text-base sm:text-sm"
          />
        </InputGroup>
        <SelectField
          size="lg"
          className="w-full rounded-lg"
          aria-label={t('expenseModal.category')}
          value={categoryId}
          onChange={setCategoryId}
          options={[{ value: 'all', label: t('reports.allCategories') }, ...categories.map((c) => ({ value: String(c.id), label: c.name }))]}
        />
        <div className="grid grid-cols-2 gap-2">
          <label className="flex flex-col gap-1 text-xs text-muted-foreground">
            {t('reports.from')}
            <DateField aria-label={t('reports.from')} value={from} max={to} onChange={setFrom} />
          </label>
          <label className="flex flex-col gap-1 text-xs text-muted-foreground">
            {t('reports.to')}
            <DateField aria-label={t('reports.to')} value={to} min={from} onChange={setTo} />
          </label>
        </div>
      </div>

      <ErrorText>{error}</ErrorText>

      {rows && (
        <div className="flex items-center justify-between gap-2 px-1">
          <span className="text-sm text-muted-foreground tabular-nums">
            {t('reports.results', { n: rows.length, amount: formatMoneyFromCents(total, currency) })}
          </span>
          <Button variant="outline" size="sm" className="rounded-lg" disabled={rows.length === 0} onClick={exportCsv}>
            <DownloadIcon />
            {t('reports.exportCsv')}
          </Button>
        </div>
      )}
      {rows && rows.length >= SEARCH_LIMIT && <p className="px-1 text-xs text-muted-foreground">{t('reports.limitHit', { n: SEARCH_LIMIT })}</p>}

      {rows && rows.length === 0 && <p className="rounded-lg bg-muted/60 p-6 text-center text-sm text-muted-foreground">{t('reports.noResults')}</p>}
      {rows && rows.length > 0 && (
        <ul className="flex flex-col overflow-hidden rounded-lg bg-card ring-1 ring-border">
          {rows.map((e) => {
            const category = e.categoryId === null ? undefined : categoryById.get(e.categoryId)
            return (
              <li key={e.id} className="border-b border-border/70 last:border-b-0">
                <button
                  type="button"
                  onClick={() => useUi.getState().openExpenseDetail(e)}
                  className="flex w-full items-center gap-3 px-3 py-2.5 text-left transition-colors active:bg-muted"
                >
                  <CategoryIcon iconKey={category?.iconKey ?? null} color={category?.color ?? null} size={36} />
                  <span className="flex min-w-0 flex-1 flex-col">
                    <span className="truncate text-[15px] font-medium">{e.note || category?.name || t('overview.noCategory')}</span>
                    <span className="truncate text-xs text-muted-foreground">
                      {formatShortDate(e.occurredOn)} {e.occurredOn.slice(0, 4)} · {category?.name ?? t('overview.noCategory')}
                    </span>
                  </span>
                  <span className="num text-base font-semibold">{formatMoneyFromCents(e.amountCents, currency)}</span>
                </button>
              </li>
            )
          })}
        </ul>
      )}
    </>
  )
}

/* ---------- Year view ---------- */

export function YearPage() {
  const t = useT()
  const currency = useCurrency()
  const categoryById = useCategoryById()
  const activeId = useGroups((s) => s.activeId)
  const [year, setYear] = useState(new Date().getFullYear())
  const [data, setData] = useState<YearlySummary | null>(null)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (!activeId) return
    let stale = false
    setData(null)
    api
      .get<{ data: YearlySummary }>('/summary/year', { params: { year } })
      .then(({ data }) => !stale && setData(data.data))
      .catch((e) => !stale && setError(errorMessage(e, t('reports.failedToLoad'))))
    return () => {
      stale = true
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps -- t is stable enough
  }, [year, activeId])

  const max = Math.max(1, ...(data?.months.map((m) => m.totalCents) ?? [0]))
  const activeMonths = data?.months.filter((m) => m.totalCents > 0).length ?? 0

  function openMonth(month: string) {
    void useExpenses.getState().loadMonth(month)
    useUi.getState().setTab('home')
  }

  return (
    <>
      <Stepper
        label={String(year)}
        onPrev={() => setYear(year - 1)}
        onNext={() => setYear(year + 1)}
        prevLabel={t('reports.previousYear')}
        nextLabel={t('reports.nextYear')}
      />
      <ErrorText>{error}</ErrorText>
      {data && (
        <>
          <div className="flex flex-col gap-1 rounded-lg bg-card p-4 ring-1 ring-border">
            <span className="text-sm text-muted-foreground">{t('reports.yearTotal', { year })}</span>
            <span className="num text-3xl font-semibold tracking-tight">{formatMoneyFromCents(data.totalCents, currency)}</span>
            {activeMonths > 0 && (
              <span className="text-sm text-muted-foreground">
                {t('reports.monthlyAvg', { amount: formatMoneyFromCents(Math.round(data.totalCents / activeMonths), currency) })}
              </span>
            )}
          </div>

          <Section title={t('reports.byMonth')}>
            <div className="flex h-40 items-end gap-1">
              {data.months.map((m) => (
                <button
                  key={m.month}
                  type="button"
                  onClick={() => openMonth(m.month)}
                  title={`${monthLabel(m.month)}: ${formatMoneyFromCents(m.totalCents, currency)}`}
                  aria-label={`${monthLabel(m.month)}: ${formatMoneyFromCents(m.totalCents, currency)}`}
                  className="flex h-full flex-1 flex-col items-center justify-end gap-1"
                >
                  <span className="w-full rounded-t-md bg-primary transition-opacity hover:opacity-80" style={{ height: `${(m.totalCents / max) * 100}%`, minHeight: m.totalCents > 0 ? 3 : 0 }} />
                  <span className="text-[10px] text-muted-foreground">{monthLabel(m.month).split(' ')[0]}</span>
                </button>
              ))}
            </div>
          </Section>

          {data.byCategory.length > 0 && (
            <Section title={t('reports.byCategory')}>
              <ul className="flex flex-col">
                {data.byCategory.map((row) => {
                  const category = row.categoryId === null ? undefined : categoryById.get(row.categoryId)
                  const percent = data.totalCents ? Math.round((row.totalCents / data.totalCents) * 100) : 0
                  return (
                    <li key={row.categoryId ?? 'none'} className="flex items-center gap-3 py-2">
                      <CategoryIcon iconKey={category?.iconKey ?? null} color={category?.color ?? null} size={34} />
                      <span className="flex min-w-0 flex-1 flex-col gap-1">
                        <span className="flex justify-between gap-2 text-[15px] font-medium">
                          <span className="truncate">{category?.name ?? t('overview.noCategory')}</span>
                          <span className="num shrink-0 font-semibold">{formatMoneyFromCents(row.totalCents, currency)}</span>
                        </span>
                        <span className="h-1.5 overflow-hidden rounded-full bg-muted">
                          <span className="block h-full rounded-full" style={{ width: `${percent}%`, background: tintFg(category?.color ?? null) }} />
                        </span>
                      </span>
                    </li>
                  )
                })}
              </ul>
            </Section>
          )}
        </>
      )}
    </>
  )
}

/* ---------- Settle up (on Home) ---------- */

/**
 * Who owes whom for the month on Home. Shown only when the group splits
 * costs. Reloads when the month's expenses change.
 */
export function SettleCard() {
  const t = useT()
  const currency = useCurrency()
  const name = useMemberName()
  const group = useActiveGroup()
  const me = useAuth((s) => s.user?.id)
  const month = useExpenses((s) => s.month)
  const syncedAt = useExpenses((s) => s.syncedAt)
  const [data, setData] = useState<MonthBalances | null>(null)

  useEffect(() => {
    if (!group?.splitEnabled) return
    let stale = false
    api
      .get<{ data: MonthBalances }>('/balances', { params: { month } })
      .then(({ data }) => !stale && setData(data.data))
      .catch(() => !stale && setData(null))
    return () => {
      stale = true
    }
  }, [month, group?.id, group?.splitEnabled, syncedAt])

  if (!group?.splitEnabled || !data) return null
  const byId = new Map(data.members.map((m) => [m.userId, m]))
  const nameOf = (userId: number) => name(userId, byId.get(userId)?.email ?? '')

  return (
    <section className="flex flex-col gap-3">
      <h2 className="font-display text-lg font-semibold">{t('reports.settle')}</h2>
      {data.members.length < 2 ? (
        <p className="rounded-lg bg-muted/60 p-4 text-sm text-muted-foreground">{t('reports.soloGroup')}</p>
      ) : (
        <div className="flex flex-col overflow-hidden rounded-lg bg-card ring-1 ring-border">
          {data.transfers.length === 0 ? (
            <p className="border-b border-border/70 px-3 py-3 text-sm text-muted-foreground">{t('reports.allSettled')}</p>
          ) : (
            data.transfers.map((tr) => (
              <div key={`${tr.fromUserId}-${tr.toUserId}`} className="flex items-center gap-3 border-b border-border/70 bg-muted/40 px-3 py-2.5">
                <RepeatIcon className="size-4 shrink-0 text-muted-foreground" />
                <span className="min-w-0 flex-1 truncate text-[15px] font-medium">{tr.fromUserId === me ? t('reports.youPay', { to: nameOf(tr.toUserId) }) : t('reports.pays', { from: nameOf(tr.fromUserId), to: nameOf(tr.toUserId) })}</span>
                <span className="num font-semibold">{formatMoneyFromCents(tr.amountCents, currency)}</span>
              </div>
            ))
          )}
          {data.members.map((m) => (
            <div key={m.userId} className="flex items-center gap-3 border-b border-border/70 px-3 py-2.5 last:border-b-0">
              <span className="flex min-w-0 flex-1 flex-col">
                <span className="truncate text-[15px] font-medium">{name(m.userId, m.email)}</span>
                <span className="text-xs text-muted-foreground tabular-nums">
                  {t('reports.paid', { amount: formatMoneyFromCents(m.paidCents, currency) })} · {t('reports.share', { amount: formatMoneyFromCents(m.shareCents, currency) })}
                </span>
              </span>
              <span className={`num font-semibold ${m.netCents > 0 ? 'text-success' : m.netCents < 0 ? 'text-destructive' : 'text-muted-foreground'}`}>
                {m.netCents > 0 ? '+' : ''}
                {formatMoneyFromCents(m.netCents, currency)}
              </span>
            </div>
          ))}
        </div>
      )}
    </section>
  )
}
