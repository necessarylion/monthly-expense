import {
  ArrowDownIcon,
  ArrowLeftRightIcon,
  ArrowUpIcon,
  ChevronLeftIcon,
  ChevronRightIcon,
  EqualIcon,
  MoreHorizontalIcon,
  PencilIcon,
  PlusIcon,
  RefreshCwIcon,
  Trash2Icon,
  UsersIcon,
  WalletIcon,
} from 'lucide-react'
import { type ComponentProps, type ReactNode, useCallback, useEffect, useRef, useState } from 'react'
import { ConfirmDialog } from '@/components/app/confirm-dialog'
import { Button } from '@/components/ui/button'
import { GoldBar } from '@/components/app/gold-bar'
import { Money } from '@/components/app/money'
import { Sparkline } from '@/components/app/sparkline'
import { ChoiceSheet } from '@/components/app/choice-sheet'
import { SelectField } from '@/components/app/select-field'
import { Skeleton } from '@/components/ui/skeleton'
import { useFxCurrency } from '@/hooks/use-fx-currency'
import { useLoadMore } from '@/hooks/use-load-more'
import { api } from '@/lib/api'
import { CURRENCIES, formatMoney, formatMoneyFromCents, formatShortDate } from '@/lib/format'
import { type AccountsTotal, getAccountsTotal } from '@/lib/fx'
import { useLive } from '@/lib/live'
import { useT } from '@/lib/i18n'
import type { Account, AccountEntry } from '@/lib/types'
import { useIsDesktop } from '@/hooks/use-is-desktop'
import { cn } from '@/lib/utils'
import { AccountFormSheet } from '@/sheets/account-form-sheet'
import { EntrySheet } from '@/sheets/entry-sheet'
import { TransferSheet } from '@/sheets/transfer-sheet'
import { useAccounts } from '@/stores/accounts'
import { Page } from './page'

type SheetState =
  | { kind: 'none' }
  | { kind: 'form'; account: Account | null }
  | { kind: 'entry'; entry: AccountEntry | null; accountId: number | null; mode?: 'set' }
  | { kind: 'transfer' }

interface History {
  from: string
  balances: Record<number, number[]>
}

/* ---------- Small parts ---------- */

/** A 30-day balance line. Flat when nothing changed. */
function ActionButton({ icon, label, ...props }: ComponentProps<'button'> & { icon: ReactNode; label: string }) {
  return (
    <button
      type="button"
      {...props}
      // Phone: a round icon over a label. Desktop: a pill button with the icon inline.
      className="flex flex-1 flex-col items-center gap-1.5 text-xs font-medium transition-opacity active:opacity-60 disabled:opacity-35 lg:h-10 lg:flex-none lg:flex-row lg:gap-2 lg:rounded-full lg:bg-secondary lg:px-4 lg:text-sm lg:transition-colors lg:enabled:hover:bg-secondary/70"
    >
      <span className="flex size-13 items-center justify-center rounded-full bg-secondary text-foreground lg:size-auto lg:bg-transparent [&_svg]:size-[22px] lg:[&_svg]:size-4">{icon}</span>
      {label}
    </button>
  )
}

function EntryRow({ entry, currency, account, onEdit }: { entry: AccountEntry; currency: string; account?: Account; onEdit(): void }) {
  const t = useT()
  const isIn = entry.amountCents >= 0
  return (
    <li className="border-b border-border/70 last:border-b-0">
      <button type="button" onClick={onEdit} aria-label={t('accounts.editEntryAria')} className="flex w-full items-center gap-3 px-3 py-2.5 text-left transition-colors active:bg-muted">
        <span
          className={cn('flex size-9 shrink-0 items-center justify-center rounded-full [&_svg]:size-[18px]', isIn ? 'bg-success/15 text-success' : 'bg-muted text-muted-foreground')}
        >
          {isIn ? <ArrowDownIcon /> : <ArrowUpIcon />}
        </span>
        <span className="flex min-w-0 flex-1 flex-col">
          <span className="truncate text-[15px] font-medium">{entry.note || (isIn ? t('accounts.money_in') : t('accounts.money_out'))}</span>
          <span className="truncate text-xs text-muted-foreground">
            {account ? `${account.name} · ` : ''}
            {formatShortDate(entry.occurredOn)}
          </span>
        </span>
        <span className={cn('num flex items-center text-base font-semibold', isIn && 'text-success')}>
          {isIn ? '+' : '−'}
          {currency === 'GLD' ? (
            <>
              <GoldBar className="mx-0.5 size-4" />
              {formatMoneyFromCents(Math.abs(entry.amountCents), currency, true).replace('🥇', '').trim()}
            </>
          ) : (
            formatMoneyFromCents(Math.abs(entry.amountCents), currency, true)
          )}
        </span>
      </button>
    </li>
  )
}

/* ---------- Cards ---------- */

const CARD =
  'relative flex h-48 w-[86%] shrink-0 snap-center flex-col justify-between overflow-hidden rounded-2xl p-5 lg:w-[360px] lg:cursor-pointer lg:snap-start'
/** Desktop picks by click, not by the middle card, so the picked one gets a ring. */
const PICKED = 'lg:ring-2 lg:ring-foreground lg:ring-offset-2 lg:ring-offset-background'

function TotalCard({ total, failed, refreshing, onRefresh, count, picked }: {
  picked: boolean
  total: AccountsTotal | null
  failed: boolean
  refreshing: boolean
  onRefresh(): void
  count: number
}) {
  const t = useT()
  const code = useFxCurrency((s) => s.code)
  const setCode = useFxCurrency((s) => s.set)
  return (
    <div className={cn(CARD, 'bg-primary text-primary-foreground', picked && PICKED)}>
      {/* A soft ring in the corner, so the card reads as a card and not a banner. */}
      <span aria-hidden="true" className="absolute -top-16 -right-16 size-48 rounded-full border-[28px] border-primary-foreground/8" />
      <div className="relative flex items-center justify-between">
        <span className="text-sm font-semibold opacity-75">{t('accounts.total')}</span>
        <div className="flex items-center gap-1">
          <SelectField
            size="sm"
            aria-label={t('settings.currency')}
            className="rounded-full border-primary-foreground/25 bg-transparent text-primary-foreground dark:bg-transparent [&_svg]:text-primary-foreground/70"
            value={code}
            onChange={setCode}
            options={CURRENCIES.map((c) => ({ value: c.code, label: c.code, hint: c.name }))}
          />
          <button type="button" aria-label={t('common.refresh')} onClick={onRefresh} className="flex size-7 items-center justify-center rounded-full active:bg-primary-foreground/10">
            <RefreshCwIcon className={cn('size-4', refreshing && 'animate-spin')} />
          </button>
        </div>
      </div>
      <div className="relative flex flex-col">
        {total ? (
          <Money cents={total.totalCents} currency={code} className="num text-[2.75rem] leading-none font-bold" symbolClassName="text-primary-foreground/60" />
        ) : failed ? (
          <span className="num text-[2.75rem] leading-none font-bold">—</span>
        ) : (
          <Skeleton className="h-11 w-44 bg-primary-foreground/15" />
        )}
        <span className="mt-1 text-sm opacity-70">{t('accounts.walletCount', { n: count })}</span>
      </div>
    </div>
  )
}

function WalletCard({ account, equivalent, sub, history, picked }: {
  account: Account
  /** The balance in the total card's currency, when that differs from the wallet's. */
  equivalent: string | null
  sub: string | null
  history?: number[]
  picked: boolean
}) {
  const t = useT()
  return (
    <div
      className={cn(CARD, 'text-white', picked && PICKED)}
      style={{ background: `linear-gradient(140deg, ${account.color}, color-mix(in srgb, ${account.color} 55%, #1a1714))` }}
    >
      <div className="flex items-start justify-between gap-2">
        <span className="flex min-w-0 items-center gap-1.5">
          <span className="truncate text-base font-semibold">{account.name}</span>
          {account.shared && <UsersIcon className="size-4 shrink-0 opacity-80" aria-label={t('accounts.shared')} />}
        </span>
        <span className="rounded-full bg-white/20 px-2 py-0.5 text-xs font-semibold">{account.currency}</span>
      </div>
      {history && <Sparkline values={history} className="absolute inset-x-0 bottom-16 h-14 w-full text-white/40" />}
      <div className="relative flex flex-col">
        <Money cents={account.balanceCents} currency={account.currency} className="num text-[2.5rem] leading-none font-bold" symbolClassName="text-white/70" />
        <span className="mt-1 h-5 truncate text-[15px] font-semibold text-white/90 tabular-nums">{equivalent ?? ''}</span>
        <span className="h-4 truncate text-xs text-white/70 tabular-nums">{sub ?? ''}</span>
      </div>
    </div>
  )
}

/* ---------- Screen ---------- */

export function AccountsScreen() {
  const t = useT()
  const accounts = useAccounts((s) => s.accounts)
  const recent = useAccounts((s) => s.recent)
  const recentHasMore = useAccounts((s) => s.recentHasMore)
  const entries = useAccounts((s) => s.entries)
  const entriesHasMore = useAccounts((s) => s.entriesHasMore)
  const loaded = useAccounts((s) => s.loaded)
  const lastError = useAccounts((s) => s.lastError)
  const openId = useAccounts((s) => s.openId)
  const code = useFxCurrency((s) => s.code)
  const ratesVersion = useLive((s) => s.rates)
  const [total, setTotal] = useState<AccountsTotal | null>(null)
  const [totalFailed, setTotalFailed] = useState(false)
  const [history, setHistory] = useState<History | null>(null)
  const [refreshing, setRefreshing] = useState(false)
  const [sheet, setSheet] = useState<SheetState>({ kind: 'none' })
  const [pendingDelete, setPendingDelete] = useState<Account | null>(null)
  const [moreOpen, setMoreOpen] = useState(false)
  const [deleting, setDeleting] = useState(false)
  const carousel = useRef<HTMLDivElement>(null)
  const desktop = useIsDesktop()
  const settleTimer = useRef<ReturnType<typeof setTimeout> | null>(null)

  const selected = accounts.find((a) => a.id === openId) ?? null
  const byId = new Map(accounts.map((a) => [a.id, a]))
  const sentinel = useLoadMore(
    selected ? entriesHasMore : recentHasMore,
    selected ? useAccounts.getState().loadMoreEntries : useAccounts.getState().loadMoreRecent
  )

  useEffect(() => {
    const s = useAccounts.getState()
    if (!s.loaded) void s.load()
    // Coming back to the tab: show the wallet that was selected before.
    const index = s.accounts.findIndex((a) => a.id === s.openId) + 1
    const card = carousel.current?.children[index] as HTMLElement | undefined
    if (index > 0 && card) carousel.current?.scrollTo({ left: card.offsetLeft - 16 })
  }, [])

  const loadTotal = useCallback(async () => {
    try {
      setTotal(await getAccountsTotal(code))
      setTotalFailed(false)
    } catch {
      setTotal(null)
      setTotalFailed(true)
    }
  }, [code])

  const loadHistory = useCallback(async () => {
    try {
      const { data } = await api.get<{ data: History }>('/accounts/history', { params: { days: 30 } })
      setHistory(data.data)
    } catch {
      /* the cards work without the line */
    }
  }, [])

  // Every wallet change reloads the list; the total and the lines follow it.
  useEffect(() => {
    void loadTotal()
    void loadHistory()
  }, [accounts, loadTotal, loadHistory])

  // New rates move the converted total.
  useEffect(() => {
    if (ratesVersion > 0) void loadTotal()
  }, [ratesVersion, loadTotal])

  /**
   * Pick the wallet only once the swipe settles. Picking mid-swipe loads its
   * entries and swaps the list below while the finger still moves, which stutters.
   */
  function onCarouselScroll() {
    if (desktop) return
    if (settleTimer.current) clearTimeout(settleTimer.current)
    settleTimer.current = setTimeout(selectMiddleCard, 120)
  }

  /** The card in the middle of the carousel is the selected one. Index 0 = all wallets. */
  function selectMiddleCard() {
    const el = carousel.current
    if (!el) return
    const cards = [...el.children] as HTMLElement[]
    const middle = el.scrollLeft + el.clientWidth / 2
    let index = 0
    cards.forEach((card, i) => {
      if (card.offsetLeft <= middle) index = i
    })
    const id = index === 0 ? null : (accounts[index - 1]?.id ?? null)
    const s = useAccounts.getState()
    if (id === s.openId) return
    if (id === null) s.closeAccount()
    else void s.openAccount(id)
  }

  /** Phone: a tap on a side card brings it to the middle. Desktop (a grid, no scroll): pick it. */
  function onCarouselClick(e: React.MouseEvent) {
    const index = [...(carousel.current?.children ?? [])].findIndex((c) => c.contains(e.target as Node))
    if (index < 0 || index > accounts.length) return
    if (!desktop) return scrollToCard(index)
    carousel.current?.children[index]?.scrollIntoView({ inline: 'nearest', block: 'nearest' })
    const s = useAccounts.getState()
    if (index === 0) s.closeAccount()
    else void s.openAccount(accounts[index - 1].id)
  }

  /** Desktop arrows: move about one card. */
  function scrollCards(direction: 1 | -1) {
    carousel.current?.scrollBy({ left: direction * 376 })
  }

  function scrollToCard(index: number) {
    const card = carousel.current?.children[index] as HTMLElement | undefined
    card?.scrollIntoView({ behavior: 'smooth', inline: 'center', block: 'nearest' })
  }

  async function refreshAll() {
    if (refreshing) return
    setRefreshing(true)
    const s = useAccounts.getState()
    try {
      await Promise.all([s.load(), s.openId !== null ? s.loadEntries() : null, s.loadDefaultAccount(), loadTotal(), loadHistory()])
    } finally {
      setRefreshing(false)
    }
  }

  async function confirmDelete() {
    if (!pendingDelete) return
    setDeleting(true)
    try {
      await useAccounts.getState().deleteAccount(pendingDelete.id)
      setPendingDelete(null)
      scrollToCard(0)
    } finally {
      setDeleting(false)
    }
  }

  function rateLine(a: Account): string | null {
    if (a.currency === 'GLD' && total?.gold) {
      return t('accounts.goldQuote', {
        buy: formatMoney(total.gold.buyOrnament, total.gold.currency),
        sell: formatMoney(total.gold.sellOrnament, total.gold.currency),
      })
    }
    const rate = total?.rates?.[a.currency]
    if (a.currency !== code && rate) return `1 ${a.currency} ≈ ${formatMoney(rate, code, true)}`
    return null
  }

  function equivalent(a: Account): string | null {
    const rate = total?.rates?.[a.currency]
    if (a.currency === code || !rate) return null
    return `≈ ${formatMoneyFromCents(Math.round(a.balanceCents * rate), code, true)}`
  }

  const list = selected ? entries : recent
  const listCurrency = (e: AccountEntry) => byId.get(e.accountId)?.currency ?? 'USD'

  return (
    // One column: cards, actions, then the list. Phone picks the middle card; desktop picks by click.
    <Page className="gap-5 px-0 lg:max-w-6xl lg:gap-6 lg:px-8">
      <div className="flex min-w-0 flex-col gap-5 lg:gap-6">
      {loaded && accounts.length === 0 ? (
        <div className="mx-4 flex flex-col items-center gap-4 rounded-2xl border border-dashed p-8 text-center lg:mx-0">
          <span className="flex size-14 items-center justify-center rounded-full bg-primary/20">
            <WalletIcon className="size-7" />
          </span>
          <p className="text-muted-foreground">{t('accounts.empty')}</p>
          <button type="button" onClick={() => setSheet({ kind: 'form', account: null })} className="rounded-full bg-primary px-5 py-2.5 font-semibold text-primary-foreground active:opacity-80">
            {t('accounts.addAccount')}
          </button>
        </div>
      ) : (
        <>
          <div className="flex flex-col gap-3">
            <div
              ref={carousel}
              onScroll={onCarouselScroll}
              onClick={onCarouselClick}
              className="no-scrollbar relative flex snap-x snap-mandatory gap-3 overflow-x-auto scroll-px-4 px-4 py-1 lg:snap-proximity lg:gap-4 lg:scroll-px-1 lg:px-1 lg:scroll-smooth"
            >
              <TotalCard total={total} failed={totalFailed} refreshing={refreshing} onRefresh={() => void refreshAll()} count={accounts.length} picked={openId === null} />
              {accounts.map((a) => (
                <WalletCard key={a.id} account={a} equivalent={equivalent(a)} sub={rateLine(a)} history={history?.balances[a.id]} picked={a.id === openId} />
              ))}
              {/* Lets the last card reach the middle. */}
              <span className="w-[7%] shrink-0 lg:hidden" aria-hidden="true" />
            </div>
            <div className="flex justify-center gap-1.5 lg:hidden" role="tablist">
              {[null, ...accounts].map((a, i) => {
                const active = (a?.id ?? null) === openId
                return (
                  <button
                    key={a?.id ?? 'all'}
                    type="button"
                    role="tab"
                    aria-selected={active}
                    aria-label={a?.name ?? t('accounts.total')}
                    onClick={() => scrollToCard(i)}
                    className={cn('h-1.5 rounded-full transition-all', active ? 'w-5 bg-foreground' : 'w-1.5 bg-muted-foreground/35')}
                  />
                )
              })}
            </div>
          </div>

          <div className="flex px-4 lg:items-center lg:gap-2 lg:px-0">
            <ActionButton
              icon={<PlusIcon />}
              label={t('accounts.addTransaction')}
              disabled={accounts.length === 0}
              onClick={() => setSheet({ kind: 'entry', entry: null, accountId: selected?.id ?? null })}
            />
            <ActionButton icon={<ArrowLeftRightIcon />} label={t('accounts.transfer')} disabled={accounts.length < 2} onClick={() => setSheet({ kind: 'transfer' })} />
            {selected ? (
              <>
                <ActionButton icon={<EqualIcon />} label={t('accounts.setBalance')} onClick={() => setSheet({ kind: 'entry', entry: null, accountId: selected.id, mode: 'set' })} />
                <ActionButton icon={<MoreHorizontalIcon />} label={t('accounts.more')} aria-haspopup="dialog" onClick={() => setMoreOpen(true)} />
                <ChoiceSheet
                  open={moreOpen}
                  onClose={() => setMoreOpen(false)}
                  title={selected.name}
                  items={[
                    { value: 'edit', label: t('accounts.editTitle'), icon: <PencilIcon /> },
                    { value: 'delete', label: t('common.delete'), icon: <Trash2Icon />, destructive: true, divider: true },
                  ]}
                  onSelect={(action) => (action === 'edit' ? setSheet({ kind: 'form', account: selected }) : setPendingDelete(selected))}
                />
              </>
            ) : (
              <ActionButton icon={<WalletIcon />} label={t('accounts.addAccount')} onClick={() => setSheet({ kind: 'form', account: null })} />
            )}
            {/* A mouse can't swipe: arrows move the carousel on desktop. */}
            <div className="ml-auto hidden gap-2 lg:flex">
              <Button variant="secondary" size="icon" className="size-10 rounded-full" aria-label={t('common.back')} onClick={() => scrollCards(-1)}>
                <ChevronLeftIcon />
              </Button>
              <Button variant="secondary" size="icon" className="size-10 rounded-full" aria-label={t('common.next')} onClick={() => scrollCards(1)}>
                <ChevronRightIcon />
              </Button>
            </div>
          </div>
        </>
      )}

      {lastError && <p className="px-4 text-sm text-destructive lg:px-0">{lastError}</p>}
      </div>

      {accounts.length > 0 && (
        <section className="flex min-w-0 flex-col gap-2 px-4 lg:px-0">
          <h2 className="font-display text-lg font-semibold">{selected ? t('accounts.history') : t('accounts.recent')}</h2>
          {list.length === 0 ? (
            <p className="rounded-2xl bg-muted/60 p-6 text-center text-sm text-muted-foreground">{t('accounts.noEntries')}</p>
          ) : (
            <ul className="overflow-hidden rounded-2xl bg-card ring-1 ring-border">
              {list.map((e) => (
                <EntryRow
                  key={e.id}
                  entry={e}
                  currency={listCurrency(e)}
                  account={selected ? undefined : byId.get(e.accountId)}
                  onEdit={() => setSheet({ kind: 'entry', entry: e, accountId: e.accountId })}
                />
              ))}
            </ul>
          )}
          {(selected ? entriesHasMore : recentHasMore) && <div ref={sentinel} className="h-8" />}
        </section>
      )}

      <AccountFormSheet open={sheet.kind === 'form'} account={sheet.kind === 'form' ? sheet.account : null} onClose={() => setSheet({ kind: 'none' })} />
      <EntrySheet
        open={sheet.kind === 'entry'}
        entry={sheet.kind === 'entry' ? sheet.entry : null}
        accountId={sheet.kind === 'entry' ? sheet.accountId : null}
        initialMode={sheet.kind === 'entry' ? sheet.mode : undefined}
        onClose={() => setSheet({ kind: 'none' })}
      />
      <TransferSheet open={sheet.kind === 'transfer'} onClose={() => setSheet({ kind: 'none' })} />
      <ConfirmDialog
        open={pendingDelete !== null}
        danger
        title={t('accounts.deleteTitle')}
        message={pendingDelete ? t('accounts.deleteWillRemove', { name: pendingDelete.name }) : undefined}
        confirmLabel={t('common.delete')}
        loading={deleting}
        onConfirm={() => void confirmDelete()}
        onCancel={() => setPendingDelete(null)}
      />
    </Page>
  )
}
