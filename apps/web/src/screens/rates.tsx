import { ArrowUpDownIcon, ChevronLeftIcon, ChevronRightIcon } from 'lucide-react'
import { useEffect, useState } from 'react'
import { Button } from '@/components/ui/button'
import { Card, CardContent } from '@/components/ui/card'
import { InputGroup, InputGroupAddon, InputGroupInput, InputGroupText } from '@/components/ui/input-group'
import { Label } from '@/components/ui/label'
import { GoldBar } from '@/components/app/gold-bar'
import { SelectField } from '@/components/app/select-field'
import { Skeleton } from '@/components/ui/skeleton'
import { useFxCurrency } from '@/hooks/use-fx-currency'
import { CURRENCIES, currencySymbol, relativeTime } from '@/lib/format'
import { type FxTable, getFxTable } from '@/lib/fx'
import { useLive } from '@/lib/live'
import { useT } from '@/lib/i18n'
import { Page } from './page'

/** MMK is quoted per lakh (100,000); everything else per 1 unit. */
function unitFactor(code: string): number {
  return code === 'MMK' ? 100_000 : 1
}

function fmtAmount(v: number): string {
  return v >= 1
    ? v.toLocaleString('en-US', { maximumFractionDigits: 2 })
    : v.toLocaleString('en-US', { maximumSignificantDigits: 4 })
}

function fmtInput(v: number): string {
  return String(Number(v.toFixed(v >= 1 ? 2 : 6)))
}

function nameOf(code: string): string {
  return CURRENCIES.find((c) => c.code === code)?.name ?? code
}

function CurrencyBadge({ code }: { code: string }) {
  return (
    <span className="flex size-10 shrink-0 items-center justify-center rounded-full bg-muted text-sm font-semibold">
      {code === 'GLD' ? <GoldBar className="size-6" /> : currencySymbol(code)}
    </span>
  )
}

function Converter({ code, base, table, onBack }: { code: string; base: string; table: FxTable; onBack(): void }) {
  const t = useT()
  const rate = 1 / table.rates[code] // base per 1 `code`
  const [from, setFrom] = useState('1')
  const [to, setTo] = useState(() => fmtInput(rate))

  // The table reloaded (new rates): recompute from the top field.
  useEffect(() => {
    const v = Number(from)
    setTo(from === '' || Number.isNaN(v) ? '' : fmtInput(v * rate))
    // eslint-disable-next-line react-hooks/exhaustive-deps -- only when the rate changes
  }, [rate])

  function editFrom(v: string) {
    setFrom(v)
    const n = Number(v)
    setTo(v === '' || Number.isNaN(n) ? '' : fmtInput(n * rate))
  }

  function editTo(v: string) {
    setTo(v)
    const n = Number(v)
    setFrom(v === '' || Number.isNaN(n) ? '' : fmtInput(n / rate))
  }

  const unit = unitFactor(code)
  return (
    <>
      <div className="flex items-center gap-1">
        <Button variant="ghost" size="icon" className="-ml-2 rounded-full" aria-label={t('common.back')} onClick={onBack}>
          <ChevronLeftIcon />
        </Button>
        <h2 className="text-lg font-semibold">
          {code} → {base}
        </h2>
      </div>
      <Card>
        <CardContent className="flex flex-col gap-3">
          {[
            { c: code, value: from, onChange: editFrom },
            { c: base, value: to, onChange: editTo },
          ].map((row, i) => (
            <div key={row.c} className="flex flex-col gap-2">
              {i === 1 && (
                <div className="flex justify-center">
                  <ArrowUpDownIcon className="size-4 text-muted-foreground" />
                </div>
              )}
              <Label>{nameOf(row.c)}</Label>
              <InputGroup className="h-14 rounded-xl">
                <InputGroupAddon>
                  <InputGroupText className="text-base">
                    {row.c === 'GLD' ? <GoldBar className="size-5" /> : currencySymbol(row.c)}
                  </InputGroupText>
                </InputGroupAddon>
                <InputGroupInput
                  inputMode="decimal"
                  value={row.value}
                  onChange={(e) => row.onChange(e.target.value)}
                  aria-label={nameOf(row.c)}
                  className="text-2xl num font-semibold"
                />
                <InputGroupAddon align="inline-end">
                  <InputGroupText>{row.c}</InputGroupText>
                </InputGroupAddon>
              </InputGroup>
            </div>
          ))}
        </CardContent>
      </Card>
      <p className="px-1 text-center text-sm text-muted-foreground tabular-nums">
        {unit === 1 ? '1' : t('rates.lakh')} {code} = {currencySymbol(base)} {fmtAmount((unit * rate))}
      </p>
    </>
  )
}

export function RatesScreen() {
  const t = useT()
  const base = useFxCurrency((s) => s.code)
  const setBase = useFxCurrency((s) => s.set)
  const [table, setTable] = useState<FxTable | null>(null)
  const [failed, setFailed] = useState(false)
  const [converting, setConverting] = useState<string | null>(null)
  const ratesVersion = useLive((s) => s.rates)

  // A new base clears the table. New rates swap it in place, no flash.
  useEffect(() => {
    setTable(null)
  }, [base])

  useEffect(() => {
    let live = true
    setFailed(false)
    getFxTable(base)
      .then((tb) => live && setTable(tb))
      .catch(() => live && setFailed(true))
    return () => {
      live = false
    }
  }, [base, ratesVersion])

  // Converting into the new base itself makes no sense: leave the converter.
  const activeConverter = converting === base ? null : converting

  function rateText(code: string): string | null {
    const r = table?.rates[code]
    if (!r || !Number.isFinite(r)) return null
    return `${currencySymbol(base)} ${fmtAmount(unitFactor(code) / r)}`
  }

  if (table && activeConverter && table.rates[activeConverter]) {
    return (
      <Page className="gap-3">
        <Converter code={activeConverter} base={base} table={table} onBack={() => setConverting(null)} />
      </Page>
    )
  }

  const thb = table?.rates.THB
  const gold = table?.gold
  const rows = CURRENCIES.filter((c) => c.code !== base && c.code !== 'GLD')

  return (
    <Page className="gap-3">
      <div className="flex items-center justify-between gap-3 px-1">
        <span className="text-sm text-muted-foreground">{t('rates.perUnit')}</span>
        <SelectField size="sm" aria-label={t('settings.currency')} className="rounded-full" value={base} onChange={setBase} options={CURRENCIES.map((c) => ({ value: c.code, label: c.code, hint: c.name }))} />
      </div>

      {failed ? (
        <p className="px-1 py-8 text-center text-sm text-destructive">{t('rates.failed')}</p>
      ) : !table ? (
        <div className="flex flex-col gap-2">
          {[0, 1, 2, 3, 4].map((i) => (
            <Skeleton key={i} className="h-16 rounded-2xl" />
          ))}
        </div>
      ) : (
        <>
          {base !== 'GLD' && (
            <button
              type="button"
              onClick={() => setConverting('GLD')}
              className="flex flex-col gap-3 rounded-2xl border bg-gradient-to-br from-amber-500/15 to-amber-500/0 p-4 text-left transition-colors hover:bg-amber-500/10"
            >
              <div className="flex items-center gap-3">
                <CurrencyBadge code="GLD" />
                <span className="flex-1 font-medium">{nameOf('GLD')}</span>
                <span className="num font-semibold">{rateText('GLD') ?? '—'}</span>
              </div>
              {gold && thb && gold.buyOrnament !== gold.sellOrnament && (
                <div className="grid grid-cols-2 gap-2 text-sm">
                  <span className="rounded-xl bg-background/70 px-3 py-2">
                    <span className="block text-xs text-muted-foreground">{t('rates.buy')}</span>
                    <span className="num font-semibold">
                      {currencySymbol(base)} {fmtAmount(gold.buyOrnament / thb)}
                    </span>
                  </span>
                  <span className="rounded-xl bg-background/70 px-3 py-2">
                    <span className="block text-xs text-muted-foreground">{t('rates.sell')}</span>
                    <span className="num font-semibold">
                      {currencySymbol(base)} {fmtAmount(gold.sellOrnament / thb)}
                    </span>
                  </span>
                </div>
              )}
            </button>
          )}
          <ul className="overflow-hidden rounded-2xl border bg-card">
            {rows.map((c) => (
              <li key={c.code} className="border-b last:border-b-0">
                <button
                  type="button"
                  onClick={() => setConverting(c.code)}
                  className="flex w-full items-center gap-3 px-3 py-3 text-left transition-colors hover:bg-muted/50"
                >
                  <CurrencyBadge code={c.code} />
                  <span className="flex min-w-0 flex-1 flex-col">
                    <span className="font-medium">
                      {c.code}
                      {unitFactor(c.code) !== 1 && (
                        <span className="ml-1.5 text-xs text-muted-foreground">{t('rates.lakh')}</span>
                      )}
                    </span>
                    <span className="truncate text-sm text-muted-foreground">{c.name}</span>
                  </span>
                  <span className="num font-semibold">{rateText(c.code) ?? '—'}</span>
                  <ChevronRightIcon className="size-4 text-muted-foreground" />
                </button>
              </li>
            ))}
          </ul>
          <p className="text-center text-xs text-muted-foreground">
            {t('overview.updated', { time: relativeTime(table.at) })}
          </p>
        </>
      )}
    </Page>
  )
}
