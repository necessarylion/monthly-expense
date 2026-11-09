import {
  ArrowLeftRightIcon,
  CheckIcon,
  ChevronLeftIcon,
  ChevronRightIcon,
  CoinsIcon,
  CopyIcon,
  KeyRoundIcon,
  LanguagesIcon,
  LayersIcon,
  LogOutIcon,
  PencilIcon,
  PlusIcon,
  ShapesIcon,
  SparklesIcon,
  SunMoonIcon,
  TargetIcon,
  Trash2Icon,
  UsersIcon,
  WalletIcon,
  XIcon,
} from 'lucide-react'
import { AnimatePresence, motion, useReducedMotion } from 'motion/react'
import { useEffect, useState } from 'react'
import { ConfirmDialog } from '@/components/app/confirm-dialog'
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { DeleteButton } from '@/components/ui/delete-button'
import { Input } from '@/components/ui/input'
import { InputGroup, InputGroupAddon, InputGroupInput, InputGroupText } from '@/components/ui/input-group'
import { Label } from '@/components/ui/label'
import { SelectField } from '@/components/app/select-field'
import { DEFAULT_THEMES, ThemeSelector } from '@/components/ui/theme-selector'
import { toast } from '@/components/ui/toast'
import { errorMessage } from '@/lib/errors'
import { addPasskey, passkeySupported } from '@/lib/passkey'
import { api } from '@/lib/api'
import type { Passkey } from '@/lib/types'
import { currencySymbol, formatMoneyFromCents, monthLabel, relativeTime } from '@/lib/format'
import { LOCALE_OPTIONS, setLocale, useLocale, useT } from '@/lib/i18n'
import { setTheme, type ThemePref, useTheme } from '@/lib/theme'
import { cn } from '@/lib/utils'
import { CurrencySelect } from '@/sheets/account-form-sheet'
import { useAccounts } from '@/stores/accounts'
import { useAuth } from '@/stores/auth'
import { useExpenses } from '@/stores/expenses'
import { useActiveGroup, useGroups } from '@/stores/groups'
import { type SettingsTab, useUi } from '@/stores/ui'
import { Page } from './page'
import { RatesScreen } from './rates'

const THEMES = [
  {
    value: 'system',
    label: 'System',
    // Half light, half dark, so it reads as "follows the phone".
    colors: { ...DEFAULT_THEMES[1].colors, sidebar: DEFAULT_THEMES[0].colors.sidebar, tile: DEFAULT_THEMES[0].colors.tile },
  },
  { ...DEFAULT_THEMES[1], value: 'light' },
  { ...DEFAULT_THEMES[0], value: 'dark' },
  {
    value: 'pink',
    label: 'Lady pink',
    colors: { sidebar: '#FDE6EE', panel: '#FFF5F8', border: 'rgba(236, 106, 156, 0.15)', strong: '#EC6A9C', muted: '#F7C6D8', tile: '#FBD9E5' },
  },
  {
    value: 'mint',
    label: 'Mint',
    colors: { sidebar: '#E2F4E9', panel: '#F3FBF6', border: 'rgba(47, 166, 115, 0.15)', strong: '#2FA673', muted: '#BFE5CF', tile: '#D3EEDD' },
  },
  {
    value: 'ocean',
    label: 'Ocean',
    colors: { sidebar: '#E3EDF8', panel: '#F4F8FC', border: 'rgba(47, 127, 214, 0.15)', strong: '#2F7FD6', muted: '#C2D8F0', tile: '#D4E4F5' },
  },
  {
    value: 'lavender',
    label: 'Lavender',
    colors: { sidebar: '#ECE6FA', panel: '#F8F5FD', border: 'rgba(139, 108, 240, 0.15)', strong: '#8B6CF0', muted: '#D3C8F0', tile: '#E1D8F8' },
  },
  {
    value: 'midnight',
    label: 'Midnight',
    colors: { sidebar: '#171E2D', panel: '#0F1420', border: 'transparent', strong: '#6EA8FF', muted: '#273145', tile: '#1F2738' },
  },
  {
    value: 'forest',
    label: 'Forest',
    colors: { sidebar: '#1A241E', panel: '#121A15', border: 'transparent', strong: '#5FCF8C', muted: '#2A3A31', tile: '#223029' },
  },
]

function Section({ title, description, children }: { title: string; description?: string; children: React.ReactNode }) {
  return (
    <Card>
      <CardHeader>
        <CardTitle>{title}</CardTitle>
        {description && <CardDescription>{description}</CardDescription>}
      </CardHeader>
      <CardContent className="flex flex-col gap-3">{children}</CardContent>
    </Card>
  )
}

function ErrorText({ children }: { children: string | null }) {
  if (!children) return null
  return (
    <p role="alert" className="text-sm text-destructive">
      {children}
    </p>
  )
}

function Appearance() {
  const theme = useTheme((s) => s.pref)
  return <ThemeSelector className="grid grid-cols-2 gap-4 sm:grid-cols-4" themes={THEMES} value={theme} onChange={(v) => setTheme(v as ThemePref)} />
}

function Language() {
  const t = useT()
  const locale = useLocale((s) => s.locale)
  return (
    <Section title={t('settings.language')} description={t('settings.languageNote')}>
      <div className="flex flex-col">
        {LOCALE_OPTIONS.map((o) => (
          <button
            key={o.code}
            type="button"
            aria-pressed={locale === o.code}
            onClick={() => setLocale(o.code)}
            className="flex items-center justify-between border-b py-3 text-left text-[15px] last:border-b-0"
          >
            {o.label}
            {locale === o.code && <CheckIcon className="size-5 text-primary" strokeWidth={3} />}
          </button>
        ))}
      </div>
    </Section>
  )
}

function GroupNameField() {
  const t = useT()
  const active = useActiveGroup()
  const [editing, setEditing] = useState(false)
  const [value, setValue] = useState('')
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)

  async function save() {
    const name = value.trim()
    if (!active || !name || name === active.name) {
      setEditing(false)
      return
    }
    setSaving(true)
    setError(null)
    try {
      await useGroups.getState().update(active.id, { name })
      setEditing(false)
    } catch (e) {
      setError(errorMessage(e, t('groups.failedToRename')))
    } finally {
      setSaving(false)
    }
  }

  if (!editing) {
    return (
      <div className="flex items-center justify-between gap-2">
        <span className="truncate text-2xl font-semibold tracking-tight">{active?.name ?? '—'}</span>
        {active && (
          <Button
            variant="outline"
            size="sm"
            className="rounded-full"
            onClick={() => {
              setValue(active.name)
              setError(null)
              setEditing(true)
            }}
          >
            <PencilIcon />
            {t('common.rename')}
          </Button>
        )}
      </div>
    )
  }
  return (
    <div className="flex flex-col gap-2">
      <div className="flex gap-2">
        <Input
          autoFocus
          value={value}
          maxLength={80}
          onChange={(e) => setValue(e.target.value)}
          onKeyDown={(e) => {
            if (e.key === 'Enter') void save()
            if (e.key === 'Escape') setEditing(false)
          }}
          className="h-10 rounded-xl text-base"
        />
        <Button variant="ghost" size="icon-lg" className="rounded-xl" aria-label={t('common.cancel')} onClick={() => setEditing(false)}>
          <XIcon />
        </Button>
        <Button size="icon-lg" className="rounded-xl" aria-label={t('common.save')} disabled={saving || !value.trim()} onClick={() => void save()}>
          <CheckIcon />
        </Button>
      </div>
      <ErrorText>{error}</ErrorText>
    </div>
  )
}

function CurrencyField() {
  const t = useT()
  const active = useActiveGroup()
  const [draft, setDraft] = useState(active?.currency ?? 'USD')
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    setDraft(active?.currency ?? 'USD')
    setError(null)
  }, [active?.currency])

  async function save() {
    if (!active) return
    setSaving(true)
    setError(null)
    try {
      await useGroups.getState().update(active.id, { currency: draft })
      toast.success(t('toast.saved'))
    } catch (e) {
      setError(errorMessage(e, t('settings.failedToSave')))
    } finally {
      setSaving(false)
    }
  }

  return (
    <Section title={t('settings.currency')} description={t('settings.currencyNote')}>
      <CurrencySelect value={draft} onChange={setDraft} label={t('settings.currency')} />
      <ErrorText>{error}</ErrorText>
      <Button className="self-end rounded-xl" disabled={saving || !active || draft === active.currency} onClick={() => void save()}>
        {saving ? t('common.saving') : t('settings.saveCurrency')}
      </Button>
    </Section>
  )
}

function BudgetField() {
  const t = useT()
  const active = useActiveGroup()
  const month = useExpenses((s) => s.month)
  const current = useExpenses((s) => s.summary?.monthlyBudgetCents ?? null)
  const [draft, setDraft] = useState('')
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    setDraft(current === null ? '' : String(current / 100))
  }, [current, month])

  const normalized = draft.trim().replace(',', '.')
  const num = Number(normalized)
  const changed = normalized === '' ? current !== null : !Number.isNaN(num) && Math.round(num * 100) !== current

  async function save() {
    if (!active) return
    let budget: number | null = null
    if (normalized !== '') {
      if (Number.isNaN(num) || num < 0) {
        setError(t('settings.budgetPositive'))
        return
      }
      budget = num
    }
    setSaving(true)
    setError(null)
    try {
      await useGroups.getState().setBudget(active.id, month, budget)
      await useExpenses.getState().loadMonth()
      toast.success(t('toast.saved'))
    } catch (e) {
      setError(errorMessage(e, t('settings.failedToSave')))
    } finally {
      setSaving(false)
    }
  }

  return (
    <Section title={t('settings.budgetFor', { month: monthLabel(month) })} description={t('settings.budgetNote')}>
      <InputGroup className="h-11 rounded-xl">
        <InputGroupAddon>
          <InputGroupText>{currencySymbol(active?.currency ?? 'USD')}</InputGroupText>
        </InputGroupAddon>
        <InputGroupInput
          inputMode="decimal"
          value={draft}
          onChange={(e) => setDraft(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && changed && void save()}
          placeholder={t('settings.budgetEmptyPlaceholder')}
          className="text-base tabular-nums"
        />
      </InputGroup>
      <ErrorText>{error}</ErrorText>
      <Button className="self-end rounded-xl" disabled={saving || !changed} onClick={() => void save()}>
        {saving ? t('common.saving') : t('settings.saveBudget')}
      </Button>
    </Section>
  )
}

function DefaultAccountField() {
  const t = useT()
  const accounts = useAccounts((s) => s.accounts)
  const defaultAccountId = useAccounts((s) => s.defaultAccountId)
  return (
    <Section title={t('accounts.defaultForExpenses')} description={t('accounts.defaultForExpensesNote')}>
      <SelectField
        size="lg"
        className="w-full rounded-xl"
        aria-label={t('accounts.defaultForExpenses')}
        value={defaultAccountId === null ? 'none' : String(defaultAccountId)}
        onChange={(v) => void useAccounts.getState().setDefaultAccount(v === 'none' ? null : Number(v)).catch(() => {})}
        options={[{ value: 'none', label: t('accounts.none') }, ...accounts.map((a) => ({ value: String(a.id), label: `${a.name} (${a.currency})` }))]}
      />
    </Section>
  )
}

function Members() {
  const t = useT()
  const active = useActiveGroup()
  const members = useGroups((s) => s.members)
  const me = useAuth((s) => s.user?.id)
  const [email, setEmail] = useState('')
  const [inviting, setInviting] = useState(false)
  const [error, setError] = useState<string | null>(null)
  if (!active) return null

  async function invite() {
    const value = email.trim().toLowerCase()
    if (!value || !active) return
    if (!value.endsWith('@gmail.com')) {
      setError(t('groups.onlyGmail'))
      return
    }
    setInviting(true)
    setError(null)
    try {
      await useGroups.getState().invite(active.id, value)
      setEmail('')
      toast.success(t('toast.invited'))
    } catch (e) {
      setError(errorMessage(e, t('groups.failedToInvite')))
    } finally {
      setInviting(false)
    }
  }

  return (
    <Section title={t('groups.members')}>
      <ul className="flex flex-col">
        {members.map((m) => (
          <li key={m.id} className="flex items-center gap-3 py-2">
            <Avatar className="size-8">
              <AvatarFallback className="text-xs">{m.email.slice(0, 1).toUpperCase()}</AvatarFallback>
            </Avatar>
            <span className="flex min-w-0 flex-1 flex-col">
              <span className="truncate text-sm font-medium">
                {m.email} {m.userId === me && <span className="text-muted-foreground">{t('common.you')}</span>}
              </span>
              {m.pending && <span className="text-xs text-muted-foreground">{t('groups.pending')}</span>}
            </span>
            {m.userId !== me && (
              <Button
                variant="ghost"
                size="icon-sm"
                className="rounded-full text-muted-foreground"
                aria-label={m.pending ? t('groups.cancelInvite') : t('groups.remove')}
                title={m.pending ? t('groups.cancelInvite') : t('groups.remove')}
                onClick={() => void useGroups.getState().removeMember(active.id, m.id).catch(() => {})}
              >
                <Trash2Icon />
              </Button>
            )}
          </li>
        ))}
      </ul>
      <Label htmlFor="invite">{t('groups.inviteByGmail')}</Label>
      <div className="flex gap-2">
        <Input
          id="invite"
          type="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && void invite()}
          placeholder={t('groups.invitePlaceholder')}
          className="h-10 rounded-xl text-base sm:text-sm"
        />
        <Button className="h-10 rounded-xl" disabled={inviting || !email.trim()} onClick={() => void invite()}>
          {inviting ? t('groups.inviting') : t('groups.invite')}
        </Button>
      </div>
      <ErrorText>{error}</ErrorText>
    </Section>
  )
}

function GroupsList() {
  const t = useT()
  const view = useUi((s) => s.groupsView)
  const setView = useUi((s) => s.setGroupsView)
  const groups = useGroups((s) => s.groups)
  const activeId = useGroups((s) => s.activeId)
  const [name, setName] = useState('')
  const [currency, setCurrency] = useState('USD')
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [renaming, setRenaming] = useState<{ id: number; value: string } | null>(null)
  const [pendingLeave, setPendingLeave] = useState<number | null>(null)
  const [leaving, setLeaving] = useState(false)

  useEffect(() => {
    setError(null)
    if (view === 'create') {
      setName('')
      const s = useGroups.getState()
      setCurrency(s.groups.find((g) => g.id === s.activeId)?.currency ?? 'USD')
    } else {
      setRenaming(null)
    }
  }, [view])

  async function create() {
    const value = name.trim()
    if (!value || busy) return
    setBusy(true)
    setError(null)
    try {
      await useGroups.getState().create({ name: value, currency })
      toast.success(t('toast.groupCreated'))
      setView('list')
    } catch (e) {
      setError(errorMessage(e, t('groups.failedToCreate')))
    } finally {
      setBusy(false)
    }
  }

  async function rename() {
    if (!renaming) return
    const g = groups.find((x) => x.id === renaming.id)
    const value = renaming.value.trim()
    if (!g || !value || value === g.name) {
      setRenaming(null)
      return
    }
    setBusy(true)
    setError(null)
    try {
      await useGroups.getState().update(g.id, { name: value })
      setRenaming(null)
    } catch (e) {
      setError(errorMessage(e, t('groups.failedToRename')))
    } finally {
      setBusy(false)
    }
  }

  if (view === 'create') {
    return (
      <>
        <div className="flex items-center gap-1">
          <Button variant="ghost" size="icon" className="-ml-2 rounded-full" aria-label={t('common.back')} onClick={() => setView('list')}>
            <ChevronLeftIcon />
          </Button>
          <h2 className="text-lg font-semibold">{t('groups.titleCreate')}</h2>
        </div>
        <Card>
          <CardContent className="flex flex-col gap-4">
            <div className="flex flex-col gap-2">
              <Label htmlFor="group-name">{t('groups.name')}</Label>
              <Input
                id="group-name"
                autoFocus
                value={name}
                maxLength={80}
                onChange={(e) => setName(e.target.value)}
                onKeyDown={(e) => e.key === 'Enter' && void create()}
                placeholder={t('groups.namePlaceholder')}
                className="h-11 rounded-xl text-base"
              />
            </div>
            <div className="flex flex-col gap-2">
              <Label>{t('groups.currency')}</Label>
              <CurrencySelect value={currency} onChange={setCurrency} label={t('groups.currency')} />
            </div>
            <ErrorText>{error}</ErrorText>
            <div className="flex justify-end gap-2">
              <Button variant="ghost" className="rounded-xl" onClick={() => setView('list')}>
                {t('common.cancel')}
              </Button>
              <Button className="rounded-xl" disabled={busy || !name.trim()} onClick={() => void create()}>
                {busy ? t('groups.creating') : t('groups.create')}
              </Button>
            </div>
          </CardContent>
        </Card>
      </>
    )
  }

  return (
    <>
      <div className="flex items-center justify-between px-1">
        <h2 className="text-lg font-semibold">{t('groups.titleManage')}</h2>
        <Button size="sm" variant="outline" className="rounded-full" onClick={() => setView('create')}>
          <PlusIcon />
          {t('groups.newGroupShort')}
        </Button>
      </div>
      <ErrorText>{error}</ErrorText>
      <ul className="flex flex-col gap-2">
        {groups.map((g) => {
          const isActive = g.id === activeId
          const isRenaming = renaming?.id === g.id
          return (
            <li key={g.id} className={cn('flex flex-col gap-3 rounded-2xl border bg-card p-4', isActive && 'ring-2 ring-primary')}>
              {isRenaming ? (
                <div className="flex gap-2">
                  <Input
                    autoFocus
                    value={renaming.value}
                    maxLength={80}
                    onChange={(e) => setRenaming({ id: g.id, value: e.target.value })}
                    onKeyDown={(e) => {
                      if (e.key === 'Enter') void rename()
                      if (e.key === 'Escape') setRenaming(null)
                    }}
                    className="h-10 rounded-xl text-base"
                  />
                  <Button variant="ghost" size="icon-lg" className="rounded-xl" aria-label={t('common.cancel')} onClick={() => setRenaming(null)}>
                    <XIcon />
                  </Button>
                  <Button size="icon-lg" className="rounded-xl" aria-label={t('common.save')} disabled={busy} onClick={() => void rename()}>
                    <CheckIcon />
                  </Button>
                </div>
              ) : (
                <div className="flex items-center gap-2">
                  <span className="min-w-0 flex-1 truncate font-semibold">{g.name}</span>
                  <Badge variant="secondary">{g.currency}</Badge>
                  {isActive && <Badge>{t('groups.active')}</Badge>}
                  <Button
                    variant="ghost"
                    size="icon-sm"
                    className="rounded-full text-muted-foreground"
                    aria-label={t('common.rename')}
                    onClick={() => setRenaming({ id: g.id, value: g.name })}
                  >
                    <PencilIcon />
                  </Button>
                </div>
              )}
              <div className="flex gap-2">
                {!isActive && (
                  <Button
                    size="sm"
                    variant="secondary"
                    className="flex-1 rounded-lg"
                    onClick={() => {
                      useGroups.getState().setActive(g.id)
                      void useGroups.getState().loadMembers(g.id).catch(() => {})
                    }}
                  >
                    {t('groups.switch')}
                  </Button>
                )}
                <Button size="sm" variant="ghost" className="flex-1 rounded-lg text-destructive hover:text-destructive" onClick={() => setPendingLeave(g.id)}>
                  {t('groups.leaveGroup')}
                </Button>
              </div>
            </li>
          )
        })}
      </ul>
      <ConfirmDialog
        open={pendingLeave !== null}
        danger
        title={t('confirm.leaveTitle')}
        message={t('confirm.leaveMessage')}
        confirmLabel={t('confirm.leave')}
        loading={leaving}
        onCancel={() => setPendingLeave(null)}
        onConfirm={() => {
          if (pendingLeave === null) return
          setLeaving(true)
          useGroups
            .getState()
            .leave(pendingLeave)
            .then(() => setPendingLeave(null))
            .catch(() => {})
            .finally(() => setLeaving(false))
        }}
      />
    </>
  )
}

function Mcp() {
  const t = useT()
  const url = useAuth((s) => s.mcpUrl)
  const clients = useAuth((s) => s.mcpClients)
  const [copied, setCopied] = useState(false)
  const [confirmAll, setConfirmAll] = useState(false)
  const [removing, setRemoving] = useState(false)

  async function copy() {
    if (!url) return
    try {
      await navigator.clipboard.writeText(url)
      setCopied(true)
      setTimeout(() => setCopied(false), 1500)
    } catch {
      /* clipboard blocked */
    }
  }

  async function remove(id: number) {
    try {
      await useAuth.getState().revokeMcpClient(id)
      toast.success(t('settings.mcpClientRemoved'))
    } catch (e) {
      toast.error(errorMessage(e, t('settings.failedToSave')))
    }
  }

  return (
    <>
      <Section title={t('settings.mcpUrl')} description={t('settings.mcpNote')}>
        <code className="rounded-xl bg-muted p-3 font-mono text-xs break-all">{url ?? t('common.loading')}</code>
        <Button className="rounded-xl" disabled={!url} aria-label={t('settings.copyAria')} onClick={() => void copy()}>
          {copied ? <CheckIcon /> : <CopyIcon />}
          {copied ? t('settings.copied') : t('settings.copyUrl')}
        </Button>
      </Section>
      <Section title={t('settings.mcpClients')} description={t('settings.mcpClientsNote')}>
        {clients.length === 0 ? (
          <p className="text-sm text-muted-foreground">{t('settings.mcpNoClients')}</p>
        ) : (
          <ul className="flex flex-col divide-y divide-border/70">
            {clients.map((client) => (
              <li key={client.id} className="flex items-center gap-3 py-2.5">
                <div className="min-w-0 flex-1">
                  <p className="truncate text-sm font-medium">{client.name}</p>
                  <p className="text-xs text-muted-foreground">
                    {client.lastUsedAt
                      ? t('settings.mcpLastUsed', { when: relativeTime(Date.parse(client.lastUsedAt)) })
                      : t('settings.mcpNeverUsed')}
                  </p>
                </div>
                <DeleteButton onConfirm={() => void remove(client.id)} className="shrink-0" />
              </li>
            ))}
          </ul>
        )}
        {clients.length > 1 && (
          <Button variant="outline" className="rounded-xl" onClick={() => setConfirmAll(true)}>
            <LogOutIcon />
            {t('settings.mcpRemoveAll')}
          </Button>
        )}
      </Section>
      <ConfirmDialog
        open={confirmAll}
        danger
        title={t('confirm.mcpRemoveAllTitle')}
        message={t('confirm.mcpRemoveAllMessage')}
        confirmLabel={t('settings.mcpRemoveAll')}
        loading={removing}
        onCancel={() => setConfirmAll(false)}
        onConfirm={() => {
          setRemoving(true)
          useAuth
            .getState()
            .revokeAllMcpClients()
            .then(() => setConfirmAll(false))
            .catch((e) => toast.error(errorMessage(e, t('settings.failedToSave'))))
            .finally(() => setRemoving(false))
        }}
      />
    </>
  )
}

function Passkeys() {
  const t = useT()
  const [keys, setKeys] = useState<Passkey[] | null>(null)
  const [adding, setAdding] = useState(false)

  async function load() {
    const { data } = await api.get<{ data: Passkey[] }>('/me/passkeys')
    setKeys(data.data)
  }

  useEffect(() => {
    void load().catch(() => setKeys([]))
  }, [])

  async function add() {
    setAdding(true)
    try {
      await addPasskey()
      await load()
      toast.success(t('settings.passkeyAdded'))
    } catch (e: any) {
      // The user closed the browser's prompt: say nothing.
      if (e?.name !== 'NotAllowedError' && e?.name !== 'AbortError') {
        toast.error(errorMessage(e, t('settings.failedToSave')))
      }
    } finally {
      setAdding(false)
    }
  }

  async function remove(id: number) {
    try {
      await api.delete(`/me/passkeys/${id}`)
      setKeys((list) => list?.filter((k) => k.id !== id) ?? null)
      toast.success(t('settings.passkeyRemoved'))
    } catch (e) {
      toast.error(errorMessage(e, t('settings.failedToSave')))
    }
  }

  return (
    <Section title={t('settings.passkeys')} description={t('settings.passkeysNote')}>
      {keys === null ? (
        <p className="text-sm text-muted-foreground">{t('common.loading')}</p>
      ) : keys.length === 0 ? (
        <p className="text-sm text-muted-foreground">{t('settings.passkeysNone')}</p>
      ) : (
        <ul className="flex flex-col divide-y divide-border/70">
          {keys.map((key) => (
            <li key={key.id} className="flex items-center gap-3 py-2.5">
              <div className="min-w-0 flex-1">
                <p className="truncate text-sm font-medium">{key.name}</p>
                <p className="text-xs text-muted-foreground">
                  {key.lastUsedAt
                    ? t('settings.mcpLastUsed', { when: relativeTime(Date.parse(key.lastUsedAt)) })
                    : t('settings.mcpNeverUsed')}
                </p>
              </div>
              <DeleteButton onConfirm={() => void remove(key.id)} className="shrink-0" />
            </li>
          ))}
        </ul>
      )}
      {passkeySupported ? (
        <Button className="rounded-xl" disabled={adding} onClick={() => void add()}>
          <PlusIcon />
          {adding ? t('common.working') : t('settings.passkeyAdd')}
        </Button>
      ) : (
        <p className="text-sm text-muted-foreground">{t('settings.passkeysUnsupported')}</p>
      )}
    </Section>
  )
}

/* ---------- The settings list ---------- */

function Row({
  icon,
  tint,
  label,
  value,
  onClick,
  danger,
}: {
  icon: React.ReactNode
  tint: string
  label: string
  value?: string
  onClick(): void
  danger?: boolean
}) {
  return (
    <li className="border-b border-border/70 last:border-b-0">
      <button type="button" onClick={onClick} className="flex w-full items-center gap-3 px-3 py-2.5 text-left transition-colors active:bg-muted">
        <span className="flex size-8 shrink-0 items-center justify-center rounded-[10px] text-white [&_svg]:size-[18px]" style={{ background: tint }}>
          {icon}
        </span>
        <span className={cn('min-w-0 flex-1 truncate text-[15px] font-medium', danger && 'text-destructive')}>{label}</span>
        {value && <span className="max-w-[45%] truncate text-[15px] text-muted-foreground">{value}</span>}
        {!danger && <ChevronRightIcon className="size-4 shrink-0 text-muted-foreground/60" />}
      </button>
    </li>
  )
}

function RowGroup({ title, children }: { title?: string; children: React.ReactNode }) {
  return (
    <section className="flex flex-col gap-1.5">
      {title && <h2 className="px-3 text-sm font-medium text-muted-foreground">{title}</h2>}
      <ul className="overflow-hidden rounded-2xl bg-card ring-1 ring-border">{children}</ul>
    </section>
  )
}

function SettingsRoot() {
  const t = useT()
  const user = useAuth((s) => s.user)
  const active = useActiveGroup()
  const members = useGroups((s) => s.members)
  const budget = useExpenses((s) => s.summary?.monthlyBudgetCents ?? null)
  const accounts = useAccounts((s) => s.accounts)
  const defaultAccountId = useAccounts((s) => s.defaultAccountId)
  const theme = useTheme((s) => s.pref)
  const locale = useLocale((s) => s.locale)
  const go = useUi((s) => s.setSettingsTab)
  const setCategoriesOpen = useUi((s) => s.setCategoriesOpen)
  const [confirmLogout, setConfirmLogout] = useState(false)
  const [loggingOut, setLoggingOut] = useState(false)
  const currency = active?.currency ?? 'USD'
  const defaultWallet = accounts.find((a) => a.id === defaultAccountId)?.name ?? t('accounts.none')

  return (
    <>
      <div className="flex items-center gap-4 rounded-2xl bg-card p-4 ring-1 ring-border">
        <Avatar className="size-14">
          {user?.photoUrl && <AvatarImage src={user.photoUrl} alt="" referrerPolicy="no-referrer" />}
          <AvatarFallback className="text-lg">{(user?.displayName ?? user?.email ?? '?').slice(0, 1).toUpperCase()}</AvatarFallback>
        </Avatar>
        <div className="flex min-w-0 flex-col">
          <span className="truncate font-display text-xl font-semibold">{user?.displayName ?? user?.email ?? '—'}</span>
          {user?.displayName && <span className="truncate text-sm text-muted-foreground">{user.email}</span>}
        </div>
      </div>

      <RowGroup title={active?.name ?? t('groups.noGroup')}>
        <Row icon={<TargetIcon />} tint="#f29f05" label={t('settings.monthlyBudget')} value={budget ? formatMoneyFromCents(budget, currency) : t('budget.notSet')} onClick={() => go('budget')} />
        <Row icon={<ShapesIcon />} tint="#3a9d5d" label={t('settings.manageCategories')} onClick={() => setCategoriesOpen(true)} />
        <Row icon={<WalletIcon />} tint="#2f7ec4" label={t('accounts.defaultForExpenses')} value={defaultWallet} onClick={() => go('wallet')} />
        <Row icon={<CoinsIcon />} tint="#8a5cc2" label={t('settings.currency')} value={currency} onClick={() => go('currency')} />
        <Row icon={<UsersIcon />} tint="#d9566b" label={t('groups.members')} value={members.length ? String(members.length) : undefined} onClick={() => go('members')} />
        <Row icon={<PencilIcon />} tint="#7a6e62" label={t('settings.groupName')} value={active?.name} onClick={() => go('group')} />
      </RowGroup>

      <RowGroup>
        <Row icon={<LayersIcon />} tint="#c8442f" label={t('settings.allGroups')} onClick={() => go('groups')} />
      </RowGroup>

      <RowGroup title={t('settings.app')}>
        <Row icon={<SunMoonIcon />} tint="#4b5563" label={t('settings.appearance')} value={t(`settings.theme_${theme}`)} onClick={() => go('appearance')} />
        <Row icon={<LanguagesIcon />} tint="#0e8a8a" label={t('settings.language')} value={LOCALE_OPTIONS.find((o) => o.code === locale)?.label} onClick={() => go('language')} />
        <Row icon={<ArrowLeftRightIcon />} tint="#2f9e8f" label={t('rates.title')} onClick={() => go('rates')} />
        <Row icon={<SparklesIcon />} tint="#d97706" label={t('settings.mcp')} onClick={() => go('mcp')} />
        <Row icon={<KeyRoundIcon />} tint="#5b6ee1" label={t('settings.passkeys')} onClick={() => go('passkeys')} />
      </RowGroup>

      <RowGroup>
        <Row icon={<LogOutIcon />} tint="#c8442f" label={t('settings.signOut')} danger onClick={() => setConfirmLogout(true)} />
      </RowGroup>

      <ConfirmDialog
        open={confirmLogout}
        title={t('confirm.signOutTitle')}
        message={t('confirm.signOutMessage')}
        confirmLabel={t('settings.signOut')}
        loading={loggingOut}
        onCancel={() => setConfirmLogout(false)}
        onConfirm={() => {
          setLoggingOut(true)
          void useAuth
            .getState()
            .logout()
            .finally(() => setLoggingOut(false))
        }}
      />
    </>
  )
}

/** Page title in the header for each settings page. */
export const SETTINGS_TITLES: Record<Exclude<SettingsTab, 'root'>, string> = {
  budget: 'settings.monthlyBudget',
  wallet: 'accounts.defaultForExpenses',
  currency: 'settings.currency',
  members: 'groups.members',
  group: 'settings.groupName',
  groups: 'settings.allGroups',
  appearance: 'settings.appearance',
  language: 'settings.language',
  mcp: 'settings.mcp',
  passkeys: 'settings.passkeys',
  rates: 'rates.title',
}

function SettingsPage({ page }: { page: SettingsTab }) {
  if (page === 'budget') return <BudgetField />
  if (page === 'wallet') return <DefaultAccountField />
  if (page === 'currency') return <CurrencyField />
  if (page === 'members') return <Members />
  if (page === 'group') return <GroupNameField />
  if (page === 'groups') return <GroupsList />
  if (page === 'appearance') return <Appearance />
  if (page === 'language') return <Language />
  if (page === 'mcp') return <Mcp />
  if (page === 'passkeys') return <Passkeys />
  return <SettingsRoot />
}

export function SettingsScreen() {
  const page = useUi((s) => s.settingsTab)
  const activeId = useGroups((s) => s.activeId)
  const userId = useAuth((s) => s.user?.id)
  const reduced = useReducedMotion() ?? false

  // Load what the list and its pages show.
  useEffect(() => {
    if (!activeId) return
    const acc = useAccounts.getState()
    if (!acc.loaded) void acc.load().catch(() => {})
    void acc.loadDefaultAccount().catch(() => {})
    void useGroups.getState().loadMembers(activeId).catch(() => {})
  }, [activeId])

  useEffect(() => {
    if (page === 'mcp' && userId) void useAuth.getState().loadMcpUrl().catch(() => {})
  }, [page, userId])

  return (
    <AnimatePresence mode="popLayout" initial={false}>
      <motion.div
        key={page}
        className="h-full"
        // Pages push in from the right, like a native settings app.
        initial={reduced ? { opacity: 0 } : { opacity: 0, x: page === 'root' ? -24 : 24 }}
        animate={{ opacity: 1, x: 0 }}
        exit={reduced ? { opacity: 0 } : { opacity: 0, x: page === 'root' ? 24 : -24 }}
        transition={{ duration: 0.2, ease: [0.26, 0.08, 0.25, 1] }}
      >
        {page === 'rates' ? (
          // Rates brings its own Page (it swaps to a converter view inside).
          <RatesScreen />
        ) : (
          <Page onRefresh={page === 'groups' ? () => useGroups.getState().load() : undefined} className="gap-5">
            <SettingsPage page={page} />
          </Page>
        )}
      </motion.div>
    </AnimatePresence>
  )
}
