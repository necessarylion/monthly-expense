import { CheckIcon, ListChecksIcon, PlusIcon, XIcon } from 'lucide-react'
import { type FormEvent, useEffect, useRef, useState } from 'react'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { toast } from '@/components/ui/toast'
import { errorMessage } from '@/lib/errors'
import { useT } from '@/lib/i18n'
import type { ShoppingItem } from '@/lib/types'
import { cn } from '@/lib/utils'
import { useExpenses } from '@/stores/expenses'
import { useShopping } from '@/stores/shopping'
import { useUi } from '@/stores/ui'
import { Page, SectionTitle } from './page'

function ItemRow({ item, onToggle, onRemove }: { item: ShoppingItem; onToggle(): void; onRemove(): void }) {
  const t = useT()
  return (
    <li className="flex items-center gap-1 border-b border-border/70 pr-1 last:border-b-0">
      <button
        type="button"
        role="checkbox"
        aria-checked={item.done}
        aria-label={t(item.done ? 'shopping.untick' : 'shopping.tick', { name: item.name })}
        onClick={onToggle}
        className="flex min-w-0 flex-1 items-center gap-3 px-3 py-3 text-left transition-colors active:bg-muted"
      >
        <span
          className={cn(
            'flex size-6 shrink-0 items-center justify-center rounded-full border-2 transition-colors',
            item.done ? 'border-success bg-success text-white' : 'border-muted-foreground/40'
          )}
        >
          {item.done && <CheckIcon className="size-3.5" strokeWidth={3.5} />}
        </span>
        <span className={cn('min-w-0 flex-1 truncate text-[15px]', item.done && 'text-muted-foreground line-through')}>{item.name}</span>
      </button>
      <Button
        variant="ghost"
        size="icon"
        className="shrink-0 rounded-full text-muted-foreground"
        aria-label={t('shopping.remove', { name: item.name })}
        onClick={onRemove}
      >
        <XIcon />
      </Button>
    </li>
  )
}

/** The group's shared shopping list. Ticking an item offers to log it as an expense. */
export function ShoppingScreen() {
  const t = useT()
  const items = useShopping((s) => s.items)
  const loaded = useShopping((s) => s.loaded)
  const openExpense = useUi((s) => s.openExpense)
  const [name, setName] = useState('')
  const [adding, setAdding] = useState(false)
  const input = useRef<HTMLInputElement>(null)

  useEffect(() => {
    void useShopping.getState().load().catch(() => {})
  }, [])

  const todo = items.filter((i) => !i.done)
  const bought = items.filter((i) => i.done)

  async function add(e: FormEvent) {
    e.preventDefault()
    const value = name.trim()
    if (!value || adding) return
    setAdding(true)
    try {
      await useShopping.getState().add(value)
      setName('')
      input.current?.focus() // keep the keyboard up for the next item
    } catch (err) {
      toast.error(errorMessage(err, t('shopping.failed')))
    } finally {
      setAdding(false)
    }
  }

  async function toggle(item: ShoppingItem) {
    try {
      await useShopping.getState().setDone(item.id, !item.done)
    } catch (err) {
      toast.error(errorMessage(err, t('shopping.failed')))
      return
    }
    // Just bought: open the expense sheet with the item as the note. Closing it skips.
    if (!item.done) {
      const categoryId = useExpenses.getState().categories[0]?.id ?? null
      openExpense(null, { categoryId, amount: null, note: item.name })
    }
  }

  async function run(action: () => Promise<void>) {
    try {
      await action()
    } catch (err) {
      toast.error(errorMessage(err, t('shopping.failed')))
    }
  }

  return (
    <Page onRefresh={() => useShopping.getState().load()} className="gap-5">
      <form onSubmit={(e) => void add(e)} className="flex gap-2">
        <Input
          ref={input}
          value={name}
          maxLength={200}
          onChange={(e) => setName(e.target.value)}
          placeholder={t('shopping.addPlaceholder')}
          aria-label={t('shopping.addPlaceholder')}
          enterKeyHint="done"
          className="h-12 flex-1 rounded-2xl px-4 text-base"
        />
        <Button type="submit" size="icon-lg" className="size-12 rounded-2xl" aria-label={t('shopping.add')} disabled={!name.trim() || adding}>
          <PlusIcon className="size-5" />
        </Button>
      </form>

      {loaded && items.length === 0 && (
        <div className="flex flex-col items-center gap-3 rounded-2xl border border-dashed p-8 text-center">
          <span className="flex size-14 items-center justify-center rounded-full bg-primary/20">
            <ListChecksIcon className="size-7" />
          </span>
          <p className="font-semibold">{t('shopping.empty')}</p>
          <p className="text-sm text-muted-foreground">{t('shopping.emptyHint')}</p>
        </div>
      )}

      {todo.length > 0 && (
        <section className="flex flex-col gap-2">
          <SectionTitle>
            {t('shopping.toBuy')} · {todo.length}
          </SectionTitle>
          <ul className="overflow-hidden rounded-2xl bg-card ring-1 ring-border">
            {todo.map((item) => (
              <ItemRow key={item.id} item={item} onToggle={() => void toggle(item)} onRemove={() => void run(() => useShopping.getState().remove(item.id))} />
            ))}
          </ul>
        </section>
      )}

      {bought.length > 0 && (
        <section className="flex flex-col gap-2">
          <SectionTitle
            action={
              <Button variant="ghost" size="sm" className="h-7 rounded-full text-muted-foreground" onClick={() => void run(() => useShopping.getState().clearBought())}>
                {t('shopping.clearBought')}
              </Button>
            }
          >
            {t('shopping.bought')} · {bought.length}
          </SectionTitle>
          <ul className="overflow-hidden rounded-2xl bg-card ring-1 ring-border">
            {bought.map((item) => (
              <ItemRow key={item.id} item={item} onToggle={() => void toggle(item)} onRemove={() => void run(() => useShopping.getState().remove(item.id))} />
            ))}
          </ul>
        </section>
      )}
    </Page>
  )
}
