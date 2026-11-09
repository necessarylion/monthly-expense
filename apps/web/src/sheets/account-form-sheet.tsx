import { Trash2Icon } from 'lucide-react'
import { useEffect, useState } from 'react'
import { Sheet } from '@/components/app/sheet'
import { Avatar, AvatarFallback } from '@/components/ui/avatar'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { SelectField } from '@/components/app/select-field'
import { Switch } from '@/components/ui/switch'
import { toast } from '@/components/ui/toast'
import { errorMessage } from '@/lib/errors'
import { CURRENCIES, currencySymbol } from '@/lib/format'
import { useT } from '@/lib/i18n'
import { COLOR_OPTIONS } from '@/lib/icons'
import type { Account, AccountMember } from '@/lib/types'
import { useAccounts } from '@/stores/accounts'
import { useAuth } from '@/stores/auth'
import { ColorPicker } from './categories-sheet'

export function CurrencySelect({
  value,
  onChange,
  label,
}: {
  value: string
  onChange(v: string): void
  label: string
}) {
  return (
    <SelectField
      size="lg"
      aria-label={label}
      className="w-full rounded-xl"
      value={value}
      onChange={onChange}
      options={CURRENCIES.map((c) => ({ value: c.code, label: `${c.code} · ${c.name} (${currencySymbol(c.code)})` }))}
    />
  )
}

export function AccountFormSheet({ open, account, onClose }: { open: boolean; account: Account | null; onClose(): void }) {
  const t = useT()
  const [name, setName] = useState('')
  const [currency, setCurrency] = useState('USD')
  const [color, setColor] = useState<string>(COLOR_OPTIONS[0])
  const [includeInTotal, setIncludeInTotal] = useState(true)
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (!open) return
    setError(null)
    if (account) {
      setName(account.name)
      setCurrency(account.currency)
      setColor(account.color)
      setIncludeInTotal(account.includeInTotal)
    } else {
      const list = useAccounts.getState().accounts
      setName('')
      // New accounts start with the last one's currency and the next color.
      setCurrency(list.at(-1)?.currency ?? 'USD')
      setColor(COLOR_OPTIONS[list.length % COLOR_OPTIONS.length])
      setIncludeInTotal(true)
    }
  }, [open, account])

  const valid = name.trim().length > 0 && !submitting

  async function submit() {
    if (!valid) return
    setSubmitting(true)
    setError(null)
    const payload = { name: name.trim(), currency, color, includeInTotal }
    try {
      const store = useAccounts.getState()
      if (account) await store.updateAccount(account.id, payload)
      else await store.addAccount(payload)
      toast.success(t(account ? 'toast.accountSaved' : 'toast.accountAdded'))
      onClose()
    } catch (e) {
      setError(errorMessage(e, account ? t('accounts.failedToSave') : t('accounts.failedToAdd')))
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <Sheet
      open={open}
      onClose={onClose}
      title={account ? t('accounts.editTitle') : t('accounts.addAccount')}
      footer={
        <Button size="lg" className="h-12 w-full rounded-2xl text-base" disabled={!valid} onClick={() => void submit()}>
          {submitting ? t('common.saving') : account ? t('common.save') : t('accounts.add')}
        </Button>
      }
    >
      <div className="flex flex-col gap-5">
        <div className="flex items-center gap-3 rounded-2xl bg-muted/60 p-3">
          <span
            className="flex size-11 shrink-0 items-center justify-center rounded-[30%] text-base font-semibold text-white"
            style={{ background: color }}
          >
            {(name.trim() || '?').slice(0, 1).toUpperCase()}
          </span>
          <Input
            autoFocus
            value={name}
            maxLength={50}
            onChange={(e) => setName(e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && void submit()}
            placeholder={t('accounts.namePlaceholder')}
            className="h-11 flex-1 rounded-xl bg-background text-base"
          />
        </div>
        <div className="flex flex-col gap-2">
          <Label>{t('settings.currency')}</Label>
          <CurrencySelect value={currency} onChange={setCurrency} label={t('settings.currency')} />
        </div>
        <div className="flex flex-col gap-2">
          <Label>{t('categories.color')}</Label>
          <ColorPicker value={color} onChange={setColor} />
        </div>
        <Label className="flex items-center justify-between gap-3 rounded-xl border p-3">
          <span>{t('accounts.includeInTotal')}</span>
          <Switch checked={includeInTotal} onCheckedChange={setIncludeInTotal} />
        </Label>
        {error && (
          <p role="alert" className="text-sm text-destructive">
            {error}
          </p>
        )}
        {account && <AccountSharing account={account} onLeft={onClose} />}
      </div>
    </Sheet>
  )
}

/** Share a wallet by Gmail, like group members. Every member can do everything. */
function AccountSharing({ account, onLeft }: { account: Account; onLeft(): void }) {
  const t = useT()
  const me = useAuth((s) => s.user?.id)
  const [members, setMembers] = useState<AccountMember[]>([])
  const [email, setEmail] = useState('')
  const [inviting, setInviting] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    let alive = true
    setMembers([])
    setError(null)
    useAccounts
      .getState()
      .loadMembers(account.id)
      .then((list) => alive && setMembers(list))
      .catch(() => {})
    return () => {
      alive = false
    }
  }, [account.id])

  async function invite() {
    const value = email.trim().toLowerCase()
    if (!value) return
    if (!value.endsWith('@gmail.com')) {
      setError(t('groups.onlyGmail'))
      return
    }
    setInviting(true)
    setError(null)
    try {
      const member = await useAccounts.getState().share(account.id, value)
      if (!members.some((m) => m.id === member.id)) setMembers([...members, member])
      void useAccounts.getState().load()
      setEmail('')
      toast.success(t('toast.invited'))
    } catch (e) {
      setError(errorMessage(e, t('groups.failedToInvite')))
    } finally {
      setInviting(false)
    }
  }

  async function remove(member: AccountMember) {
    if (member.id === null) return
    const store = useAccounts.getState()
    try {
      await store.removeMember(account.id, member.id)
      if (member.userId === me) {
        // I left: the wallet is gone from my list.
        if (store.openId === account.id) store.closeAccount()
        await store.load()
        toast.success(t('accounts.left'))
        onLeft()
        return
      }
      setMembers(members.filter((m) => m.id !== member.id))
      void store.load()
    } catch (e) {
      setError(errorMessage(e, t('accounts.failedToSave')))
    }
  }

  return (
    <div className="flex flex-col gap-2">
      <Label>{t('accounts.sharedWith')}</Label>
      <ul className="flex flex-col">
        {members.map((m) => {
          const label = m.userId === me && !m.owner ? t('accounts.leave') : m.pending ? t('groups.cancelInvite') : t('groups.remove')
          return (
            <li key={m.id ?? 'owner'} className="flex items-center gap-3 py-2">
              <Avatar className="size-8">
                <AvatarFallback className="text-xs">{m.email.slice(0, 1).toUpperCase()}</AvatarFallback>
              </Avatar>
              <span className="flex min-w-0 flex-1 flex-col">
                <span className="truncate text-sm font-medium">
                  {m.email} {m.userId === me && <span className="text-muted-foreground">{t('common.you')}</span>}
                </span>
                {m.owner && <span className="text-xs text-muted-foreground">{t('accounts.owner')}</span>}
                {m.pending && <span className="text-xs text-muted-foreground">{t('groups.pending')}</span>}
              </span>
              {!m.owner && (
                <Button
                  variant="ghost"
                  size="icon-sm"
                  className="rounded-full text-muted-foreground"
                  aria-label={label}
                  title={label}
                  onClick={() => void remove(m)}
                >
                  <Trash2Icon />
                </Button>
              )}
            </li>
          )
        })}
      </ul>
      <div className="flex gap-2">
        <Input
          type="email"
          aria-label={t('groups.inviteByGmail')}
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
      {error && (
        <p role="alert" className="text-sm text-destructive">
          {error}
        </p>
      )}
    </div>
  )
}
