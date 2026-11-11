import { CirclePlusIcon, HouseIcon, ListChecksIcon, PlusIcon, UserRoundIcon, WalletIcon } from 'lucide-react'
import { AnimatePresence, motion, useReducedMotion } from 'motion/react'
import { useEffect, useRef } from 'react'
import useMeasure from 'react-use-measure'
import { Button } from '@/components/ui/button'
import { useT } from '@/lib/i18n'
import { cn } from '@/lib/utils'
import { CategoriesSheet } from '@/sheets/categories-sheet'
import { ExpenseDetailSheet } from '@/sheets/expense-detail-sheet'
import { ExpenseSheet } from '@/sheets/expense-sheet'
import { useExpenses } from '@/stores/expenses'
import { useGroups } from '@/stores/groups'
import { TABS, type Tab, useUi } from '@/stores/ui'
import { AccountsScreen } from './accounts'
import { Header } from './header'
import { HomeScreen } from './home'
import { SettingsScreen } from './settings'
import { ShoppingScreen } from './shopping'

const TAB_ICONS: Record<Tab, typeof HouseIcon> = {
  home: HouseIcon,
  accounts: WalletIcon,
  list: ListChecksIcon,
  settings: UserRoundIcon,
}

/** Slot order in the bar. `add` is an action (opens the expense sheet), never the active tab. */
const SLOTS = ['home', 'accounts', 'add', 'list', 'settings'] as const
type Slot = (typeof SLOTS)[number]

const SPRING = { type: 'spring', stiffness: 420, damping: 34 } as const
/** Notch: radius around the bubble (bubble 56px + 6px gap), and the soft shoulder width. */
const NOTCH_R = 34
const SHOULDER = 16

/**
 * The bar's outline with a round notch dipping down at `cx`. Always the same
 * commands, so motion can animate `d` from one tab to the next.
 */
function barPath(w: number, h: number, cx: number): string {
  const l = cx - NOTCH_R
  const r = cx + NOTCH_R
  const d = NOTCH_R
  return `M0 0 H${l - SHOULDER} C${l} 0 ${l} ${d} ${cx} ${d} C${r} ${d} ${r} 0 ${r + SHOULDER} 0 H${w} V${h} H0 Z`
}

function SlotButton({ slot, active, onPress }: { slot: Slot; active: boolean; onPress(): void }) {
  const t = useT()
  const Icon = slot === 'add' ? CirclePlusIcon : TAB_ICONS[slot]
  return (
    <button
      type="button"
      aria-current={active ? 'page' : undefined}
      onClick={onPress}
      className={cn(
        'relative flex flex-1 flex-col items-center gap-1 pt-3 pb-1.5 text-[11px] select-none',
        active ? 'font-semibold text-foreground' : 'font-medium text-muted-foreground active:opacity-60'
      )}
    >
      {active && (
        <motion.span
          layoutId="tab-bubble"
          transition={SPRING}
          className="pointer-events-none absolute inset-x-0 -top-7 mx-auto size-14 rounded-full bg-primary shadow-lg"
        />
      )}
      <motion.span
        className={cn('relative flex size-6 items-center justify-center', active && 'text-primary-foreground')}
        animate={{ y: active ? -24 : 0 }}
        transition={SPRING}
      >
        <Icon className="size-[22px]" strokeWidth={active ? 2.2 : 1.8} />
      </motion.span>
      {t(`tabs.${slot}`)}
    </button>
  )
}

/** A docked tab bar: the active tab's icon rises into a bubble that sits in a notch. */
function TabBar() {
  const tab = useUi((s) => s.tab)
  const setTab = useUi((s) => s.setTab)
  const openExpense = useUi((s) => s.openExpense)
  const [ref, { width, height }] = useMeasure()
  // The slots sit in a centered max-w row; the nav spans the screen from x = 0.
  const [rowRef, row] = useMeasure()
  const cx = row.left + (row.width / SLOTS.length) * (SLOTS.indexOf(tab) + 0.5)

  return (
    <nav className="absolute inset-x-0 bottom-0 z-40 pb-safe lg:hidden">
      {width > 0 && (
        <svg
          aria-hidden
          className="pointer-events-none absolute inset-0 size-full overflow-visible"
          viewBox={`0 0 ${width} ${height}`}
          style={{ filter: 'drop-shadow(0 -1px 0 var(--border))' }}
        >
          <motion.path
            className="fill-[color-mix(in_oklab,var(--background),var(--foreground)_3%)]"
            initial={false}
            animate={{ d: barPath(width, height, cx) }}
            transition={SPRING}
          />
        </svg>
      )}
      {/* Measure the full nav (incl. safe area) through this wrapper. */}
      <div ref={ref} className="absolute inset-0" />
      <div ref={rowRef} className="relative mx-auto flex max-w-2xl">
        {SLOTS.map((slot) => (
          <SlotButton
            key={slot}
            slot={slot}
            active={slot === tab}
            onPress={slot === 'add' ? () => openExpense(null) : () => setTab(slot)}
          />
        ))}
      </div>
    </nav>
  )
}

/** Desktop navigation (lg and up). Phones use the tab bar instead. */
function Sidebar() {
  const t = useT()
  const tab = useUi((s) => s.tab)
  const setTab = useUi((s) => s.setTab)
  const openExpense = useUi((s) => s.openExpense)
  return (
    <aside className="hidden w-60 shrink-0 flex-col gap-1 border-r bg-[color-mix(in_oklab,var(--background),var(--foreground)_3%)] p-4 lg:flex">
      <div className="mb-5 flex items-center gap-2.5 px-2 pt-1">
        <img src="/icon.svg" alt="" className="size-8 rounded-lg" />
        <span className="font-display text-lg font-bold tracking-tight">Monthly Expense</span>
      </div>
      <Button className="mb-4 h-11 rounded-lg text-sm" onClick={() => openExpense(null)}>
        <PlusIcon />
        {t('expenseModal.titleNew')}
      </Button>
      {TABS.map((item) => {
        const Icon = TAB_ICONS[item]
        const active = item === tab
        return (
          <button
            key={item}
            type="button"
            aria-current={active ? 'page' : undefined}
            onClick={() => setTab(item)}
            className={cn(
              'flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium transition-colors',
              active ? 'bg-primary/15 text-foreground' : 'text-muted-foreground hover:bg-muted hover:text-foreground'
            )}
          >
            <Icon className="size-5" strokeWidth={active ? 2.2 : 1.8} />
            {t(`tabs.${item}`)}
          </button>
        )
      })}
    </aside>
  )
}

function TabBody({ tab }: { tab: Tab }) {
  if (tab === 'home') return <HomeScreen />
  if (tab === 'accounts') return <AccountsScreen />
  if (tab === 'list') return <ShoppingScreen />
  return <SettingsScreen />
}

export function Dashboard() {
  const tab = useUi((s) => s.tab)
  const reduced = useReducedMotion() ?? false
  // Slide toward the tab you picked: right when moving forward, left when going back.
  const previous = useRef(tab)
  const direction = TABS.indexOf(tab) >= TABS.indexOf(previous.current) ? 1 : -1
  useEffect(() => {
    previous.current = tab
  }, [tab])

  useEffect(() => {
    const expenses = useExpenses.getState()
    if (useGroups.getState().activeId) {
      void Promise.all([expenses.loadCategories(), expenses.loadMonth()])
    }
  }, [])

  return (
    <div className="flex h-dvh bg-background">
      <Sidebar />
      <div className="relative flex min-w-0 flex-1 flex-col">
      <Header />
      <main className="relative min-h-0 flex-1 overflow-hidden">
        <AnimatePresence mode="popLayout" initial={false}>
          <motion.div
            key={tab}
            className="absolute inset-0"
            initial={reduced ? { opacity: 0 } : { opacity: 0, x: 16 * direction }}
            animate={{ opacity: 1, x: 0 }}
            exit={reduced ? { opacity: 0 } : { opacity: 0, x: -16 * direction }}
            transition={{ duration: 0.18, ease: [0.26, 0.08, 0.25, 1] }}
          >
            <TabBody tab={tab} />
          </motion.div>
        </AnimatePresence>
      </main>
      <TabBar />
      </div>
      <ExpenseSheet />
      <ExpenseDetailSheet />
      <CategoriesSheet />
    </div>
  )
}
