import { SparklesIcon } from 'lucide-react'
import { useEffect, useState, type ReactNode } from 'react'
import { CategoryIcon } from '@/components/app/category-icon'
import { Sheet } from '@/components/app/sheet'
import { Button } from '@/components/ui/button'
import { api } from '@/lib/api'
import { errorMessage } from '@/lib/errors'
import { formatMoney, monthLabel } from '@/lib/format'
import { useLocale, useT } from '@/lib/i18n'
import { useExpenses } from '@/stores/expenses'

/** `GET /insights/month`. Money is in currency units, not cents. */
interface Insight {
  facts: {
    currency: string
    total: number
    expenseCount: number
    budget: number | null
    budgetUsedPercent: number | null
    budgetLeft: number | null
    byCategory: { categoryId: number | null; category: string; total: number; shareOfTotalPercent: number }[]
    biggestExpenses: { note: string | null; amount: number; categoryId: number | null; category: string | null }[]
  }
  summary: string
  tips: string[]
}

/**
 * "Explain my month": the month's numbers from the API, with a summary and
 * tips that Claude writes (`GET /insights/month`). Read-only.
 */
export function MonthInsightButton({ month }: { month: string }) {
  const t = useT()
  const [open, setOpen] = useState(false)
  return (
    <>
      <Button variant="outline" size="sm" className="rounded-lg" onClick={() => setOpen(true)}>
        <SparklesIcon />
        {t('insight.open')}
      </Button>
      <MonthInsightSheet month={month} open={open} onClose={() => setOpen(false)} />
    </>
  )
}

function MonthInsightSheet({ month, open, onClose }: { month: string; open: boolean; onClose(): void }) {
  const t = useT()
  const lang = useLocale((s) => s.locale)
  const [insight, setInsight] = useState<Insight | null>(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  // Ask again only when the month or the language changes.
  const [asked, setAsked] = useState<string | null>(null)
  const key = `${month}:${lang}`

  async function load() {
    setLoading(true)
    setError(null)
    setInsight(null)
    try {
      const { data } = await api.get<{ data: Insight }>('/insights/month', { params: { month, lang } })
      setInsight(data.data)
    } catch (e) {
      setError(errorMessage(e, t('insight.failed')))
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    if (!open || asked === key) return
    setAsked(key)
    void load()
    // eslint-disable-next-line react-hooks/exhaustive-deps -- load reads the same month and lang
  }, [open, key])

  return (
    <Sheet docked open={open} onClose={onClose} title={t('insight.title')} view={loading ? 'loading' : error ? 'error' : 'done'}>
      <div className="flex flex-col gap-3">
        {loading && <p className="py-8 text-center text-sm text-muted-foreground">{t('insight.loading')}</p>}
        {error && (
          <div className="flex flex-col items-center gap-3 py-6">
            <p className="text-sm text-destructive">{error}</p>
            <Button variant="outline" size="sm" onClick={() => void load()}>
              {t('insight.retry')}
            </Button>
          </div>
        )}
        {insight && (
          <>
            <InsightView month={month} insight={insight} />
            <p className="text-xs text-muted-foreground">{t('insight.note')}</p>
          </>
        )}
      </div>
    </Sheet>
  )
}

const TOP_CATEGORIES = 3
const TOP_EXPENSES = 5

function InsightView({ month, insight }: { month: string; insight: Insight }) {
  const t = useT()
  const categories = useExpenses((s) => s.categories)
  const { facts, summary, tips } = insight
  const money = (amount: number) => formatMoney(amount, facts.currency, !Number.isInteger(amount))
  const icon = (id: number | null) => {
    const category = categories.find((c) => c.id === id)
    return <CategoryIcon iconKey={category?.iconKey ?? null} color={category?.color ?? null} size={30} />
  }

  let budgetLine = t('insight.count', { n: facts.expenseCount })
  if (facts.budget !== null && facts.budgetLeft !== null) {
    const params = { percent: facts.budgetUsedPercent ?? 0, budget: money(facts.budget), amount: money(Math.abs(facts.budgetLeft)) }
    budgetLine = t(facts.budgetLeft < 0 ? 'insight.budgetOver' : 'insight.budgetLeft', params)
  }

  return (
    <div className="flex flex-col gap-4 text-[15px]">
      <div className="flex flex-col gap-1">
        <p className="text-xs text-muted-foreground">{t('insight.spentIn', { month: monthLabel(month) })}</p>
        <p className="font-display text-3xl font-semibold tabular-nums">{money(facts.total)}</p>
        <p className="text-xs text-muted-foreground">{budgetLine}</p>
        <p className="pt-2 leading-snug">{summary}</p>
      </div>
      {facts.byCategory.length > 0 && (
        <Section title={t('insight.topCategories')}>
          {facts.byCategory.slice(0, TOP_CATEGORIES).map((row) => (
            <Row key={row.categoryId ?? 0} icon={icon(row.categoryId)} label={row.category} value={`${money(row.total)} · ${row.shareOfTotalPercent}%`} />
          ))}
        </Section>
      )}
      {facts.biggestExpenses.length > 0 && (
        <Section title={t('insight.biggest')}>
          {facts.biggestExpenses.slice(0, TOP_EXPENSES).map((row, i) => (
            <Row key={i} icon={icon(row.categoryId)} label={row.note || row.category || ''} value={money(row.amount)} />
          ))}
        </Section>
      )}
      {tips.length > 0 && (
        <Section title={t('insight.tips')}>
          {tips.map((tip, i) => (
            <li key={i} className="py-2.5 leading-snug">
              {tip}
            </li>
          ))}
        </Section>
      )}
    </div>
  )
}

/** A heading over a card of rows with a line between them. */
function Section({ title, children }: { title: string; children: ReactNode }) {
  return (
    <section className="flex flex-col gap-2">
      <h3 className="text-sm font-semibold">{title}</h3>
      <ul className="flex flex-col divide-y divide-border rounded-xl border border-border bg-card px-3.5">{children}</ul>
    </section>
  )
}

function Row({ icon, label, value }: { icon: ReactNode; label: string; value: string }) {
  return (
    <li className="flex items-center gap-3 py-2.5">
      {icon}
      <span className="min-w-0 flex-1 truncate">{label}</span>
      <span className="shrink-0 font-medium tabular-nums">{value}</span>
    </li>
  )
}
