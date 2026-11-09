import { CheckIcon, ChevronLeftIcon, ChevronRightIcon, PlusIcon } from 'lucide-react'
import { useEffect, useState } from 'react'
import { CategoryIcon } from '@/components/app/category-icon'
import { Sheet } from '@/components/app/sheet'
import { Button } from '@/components/ui/button'
import { DeleteButton } from '@/components/ui/delete-button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { toast } from '@/components/ui/toast'
import { errorMessage, errorStatus } from '@/lib/errors'
import { useT } from '@/lib/i18n'
import { COLOR_OPTIONS, ICON_OPTIONS, iconFor } from '@/lib/icons'
import type { Category } from '@/lib/types'
import { cn } from '@/lib/utils'
import { useExpenses } from '@/stores/expenses'
import { useUi } from '@/stores/ui'

interface Draft {
  name: string
  iconKey: string
  color: string
}

export function IconPicker({ value, color, onChange }: { value: string; color: string; onChange(v: string): void }) {
  return (
    <div className="grid grid-cols-8 gap-1.5">
      {ICON_OPTIONS.map((key) => {
        const Icon = iconFor(key)
        const active = value === key
        return (
          <button
            key={key}
            type="button"
            aria-label={key}
            aria-pressed={active}
            onClick={() => onChange(key)}
            className={cn(
              'flex aspect-square items-center justify-center rounded-xl border transition-colors',
              active ? 'border-transparent text-white' : 'bg-background text-muted-foreground hover:bg-muted'
            )}
            style={active ? { background: color } : undefined}
          >
            <Icon className="size-[18px]" />
          </button>
        )
      })}
    </div>
  )
}

export function ColorPicker({ value, onChange }: { value: string; onChange(v: string): void }) {
  return (
    <div className="grid grid-cols-8 gap-1.5">
      {COLOR_OPTIONS.map((c) => (
        <button
          key={c}
          type="button"
          aria-label={c}
          aria-pressed={value === c}
          onClick={() => onChange(c)}
          className="flex aspect-square items-center justify-center rounded-full transition-transform active:scale-90"
          style={{ background: c }}
        >
          {value === c && <CheckIcon className="size-4 text-white" strokeWidth={3} />}
        </button>
      ))}
    </div>
  )
}

function CategoryForm({ draft, onChange, onSubmit }: { draft: Draft; onChange(d: Draft): void; onSubmit(): void }) {
  const t = useT()
  return (
    <div className="flex flex-col gap-5">
      <div className="flex items-center gap-3 rounded-2xl bg-muted/60 p-3">
        <CategoryIcon iconKey={draft.iconKey} color={draft.color} size={44} />
        <Input
          autoFocus
          value={draft.name}
          maxLength={50}
          onChange={(e) => onChange({ ...draft, name: e.target.value })}
          onKeyDown={(e) => e.key === 'Enter' && onSubmit()}
          placeholder={t('categories.namePlaceholder')}
          className="h-11 flex-1 rounded-xl bg-background text-base"
        />
      </div>
      <div className="flex flex-col gap-2">
        <Label>{t('categories.icon')}</Label>
        <IconPicker value={draft.iconKey} color={draft.color} onChange={(iconKey) => onChange({ ...draft, iconKey })} />
      </div>
      <div className="flex flex-col gap-2">
        <Label>{t('categories.color')}</Label>
        <ColorPicker value={draft.color} onChange={(color) => onChange({ ...draft, color })} />
      </div>
    </div>
  )
}

const EMPTY: Draft = { name: '', iconKey: ICON_OPTIONS[0], color: COLOR_OPTIONS[0] }

export function CategoriesSheet() {
  const t = useT()
  const open = useUi((s) => s.categoriesOpen)
  const setOpen = useUi((s) => s.setCategoriesOpen)
  const categories = useExpenses((s) => s.categories)
  /** `list`, `add`, or the id of the category being edited. */
  const [view, setView] = useState<'list' | 'add' | number>('list')
  const [draft, setDraft] = useState<Draft>(EMPTY)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (open) {
      setView('list')
      setError(null)
    }
  }, [open])

  const editing = typeof view === 'number' ? (categories.find((c) => c.id === view) ?? null) : null
  const sorted = [...categories].sort((a, b) => a.name.localeCompare(b.name))

  function startAdd() {
    setDraft(EMPTY)
    setError(null)
    setView('add')
  }

  function startEdit(c: Category) {
    setDraft({ name: c.name, iconKey: c.iconKey, color: c.color })
    setError(null)
    setView(c.id)
  }

  async function save() {
    const name = draft.name.trim()
    if (!name || saving) return
    setSaving(true)
    setError(null)
    try {
      const store = useExpenses.getState()
      if (editing) {
        await store.updateCategory(editing.id, { ...draft, name })
        toast.success(t('toast.categorySaved'))
      } else {
        await store.addCategory({ ...draft, name })
        toast.success(t('toast.categoryAdded'))
      }
      setView('list')
    } catch (e) {
      setError(errorMessage(e, editing ? t('categories.failedToSave') : t('categories.failedToAdd')))
    } finally {
      setSaving(false)
    }
  }

  async function remove() {
    if (!editing) return
    try {
      await useExpenses.getState().deleteCategory(editing.id)
      toast.success(t('toast.categoryDeleted'))
      setView('list')
    } catch (e) {
      const status = errorStatus(e)
      setError(status === 409 || status === 400 ? t('categories.deleteHasExpenses') : errorMessage(e, t('common.delete')))
    }
  }

  const inForm = view !== 'list'
  return (
    <Sheet
      open={open}
      onClose={() => setOpen(false)}
      view={String(view)}
      title={view === 'list' ? t('categories.title') : view === 'add' ? t('categories.addCategory') : t('categories.editTitle')}
      leading={
        inForm && (
          <Button variant="ghost" size="icon" className="-ml-2 rounded-full" aria-label={t('common.back')} onClick={() => setView('list')}>
            <ChevronLeftIcon />
          </Button>
        )
      }
      footer={
        inForm ? (
          <div className="flex flex-col gap-2">
            {error && (
              <p role="alert" className="text-sm text-destructive">
                {error}
              </p>
            )}
            <div className="flex items-center gap-2">
              {editing && <DeleteButton onConfirm={() => void remove()} className="shrink-0" />}
              <Button size="lg" className="h-12 flex-1 rounded-2xl text-base" disabled={!draft.name.trim() || saving} onClick={() => void save()}>
                {saving ? t('common.saving') : editing ? t('categories.saveChanges') : t('categories.add')}
              </Button>
            </div>
          </div>
        ) : (
          <Button size="lg" variant="secondary" className="h-12 w-full rounded-2xl text-base" onClick={startAdd}>
            <PlusIcon />
            {t('categories.addCategory')}
          </Button>
        )
      }
    >
      {inForm ? (
        <CategoryForm draft={draft} onChange={setDraft} onSubmit={() => void save()} />
      ) : (
        <ul className="flex flex-col">
          {sorted.map((c) => (
            <li key={c.id}>
              <button
                type="button"
                onClick={() => startEdit(c)}
                aria-label={t('categories.editAria', { name: c.name })}
                className="flex w-full items-center gap-3 rounded-xl px-2 py-2.5 text-left transition-colors hover:bg-muted"
              >
                <CategoryIcon iconKey={c.iconKey} color={c.color} size={36} />
                <span className="flex-1 truncate text-[15px] font-medium">{c.name}</span>
                <ChevronRightIcon className="size-4 text-muted-foreground" />
              </button>
            </li>
          ))}
        </ul>
      )}
    </Sheet>
  )
}
