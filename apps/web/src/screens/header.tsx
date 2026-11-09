import { ChevronDownIcon, ChevronLeftIcon, ChevronRightIcon, PlusIcon, UsersIcon } from 'lucide-react'
import { useState } from 'react'
import { type ChoiceItem, ChoiceSheet } from '@/components/app/choice-sheet'
import { Button } from '@/components/ui/button'
import { monthLabel, shiftMonth } from '@/lib/format'
import { useT } from '@/lib/i18n'
import { useExpenses } from '@/stores/expenses'
import { useActiveGroup, useGroups } from '@/stores/groups'
import { useUi } from '@/stores/ui'
import { SETTINGS_TITLES } from './settings'

function GroupSwitcher() {
  const t = useT()
  const groups = useGroups((s) => s.groups)
  const activeId = useGroups((s) => s.activeId)
  const setActive = useGroups((s) => s.setActive)
  const active = useActiveGroup()
  const openGroups = useUi((s) => s.openGroups)
  const [open, setOpen] = useState(false)

  const items: ChoiceItem[] = groups.map((g) => ({ value: String(g.id), label: g.name, hint: g.currency }))
  items.push(
    { value: 'create', label: t('groups.newGroupShort'), icon: <PlusIcon />, divider: true },
    { value: 'manage', label: t('groups.manageMembers'), icon: <UsersIcon /> }
  )

  function onSelect(value: string) {
    if (value === 'create' || value === 'manage') openGroups(value)
    else setActive(Number(value))
  }

  return (
    <>
      <button
        type="button"
        aria-haspopup="dialog"
        onClick={() => setOpen(true)}
        className="flex min-w-0 items-center gap-2 rounded-full py-1 pr-2.5 pl-1 transition-colors hover:bg-muted"
      >
        <span className="flex size-8 shrink-0 items-center justify-center rounded-full bg-primary text-sm font-semibold text-primary-foreground">
          {(active?.name ?? '?').slice(0, 1).toUpperCase()}
        </span>
        <span className="truncate text-[15px] font-semibold">{active?.name ?? t('groups.noGroup')}</span>
        <ChevronDownIcon className="size-4 shrink-0 text-muted-foreground" />
      </button>
      <ChoiceSheet
        open={open}
        onClose={() => setOpen(false)}
        title={t('groups.switchGroup')}
        items={items}
        value={activeId === null ? undefined : String(activeId)}
        onSelect={onSelect}
      />
    </>
  )
}

function MonthSwitcher() {
  const month = useExpenses((s) => s.month)
  const loadMonth = useExpenses((s) => s.loadMonth)
  return (
    <div className="flex shrink-0 items-center rounded-full border bg-background">
      <Button variant="ghost" size="icon" className="rounded-full" aria-label="Previous month" onClick={() => void loadMonth(shiftMonth(month, -1))}>
        <ChevronLeftIcon />
      </Button>
      <span className="min-w-[4.75rem] text-center text-sm font-semibold tabular-nums">{monthLabel(month)}</span>
      <Button variant="ghost" size="icon" className="rounded-full" aria-label="Next month" onClick={() => void loadMonth(shiftMonth(month, 1))}>
        <ChevronRightIcon />
      </Button>
    </div>
  )
}

const TITLES = { accounts: 'tabs.accounts', list: 'shopping.title', settings: 'tabs.settings' } as const

export function Header() {
  const t = useT()
  const tab = useUi((s) => s.tab)
  const settingsPage = useUi((s) => s.settingsTab)
  const setSettingsPage = useUi((s) => s.setSettingsTab)
  const subPage = tab === 'settings' && settingsPage !== 'root' ? settingsPage : null
  // A trip has no months.
  const trip = useActiveGroup()?.kind === 'trip'

  return (
    // iOS 26 Safari tints the status bar with a sticky/fixed top bar's solid color.
    // Without `sticky` (or with a translucent bg) it blurs the page under it instead.
    // The bg is a solid 3% mix (not an alpha tint), so it stays opaque for Safari.
    // On desktop the sidebar carries the tinted color, so the header goes plain with a line.
    <header className="sticky top-0 z-30 shrink-0 bg-[color-mix(in_oklab,var(--background),var(--foreground)_3%)] pt-safe lg:border-b lg:bg-background">
      {/* Same width as the page below: Home and Wallet are wide on desktop. */}
      <div className={`mx-auto flex h-14 max-w-2xl items-center justify-between gap-3 px-4 lg:h-16 lg:px-8 ${tab === 'home' || tab === 'accounts' ? 'lg:max-w-6xl' : ''}`}>
        {tab === 'home' ? (
          <>
            <GroupSwitcher />
            <MonthSwitcher />
          </>
        ) : subPage ? (
          <div className="flex min-w-0 items-center gap-1">
            <Button variant="ghost" size="icon-lg" className="-ml-2 rounded-full" aria-label={t('common.back')} onClick={() => setSettingsPage('root')}>
              <ChevronLeftIcon className="size-6" />
            </Button>
            <h1 className="truncate font-display text-xl font-semibold">{t(trip && subPage === 'budget' ? 'reports.tripBudget' : SETTINGS_TITLES[subPage])}</h1>
          </div>
        ) : (
          // Large, left-aligned title, like a native app's top bar.
          <h1 className="font-display text-[1.75rem] leading-none font-bold tracking-tight">{t(TITLES[tab])}</h1>
        )}
      </div>
    </header>
  )
}
