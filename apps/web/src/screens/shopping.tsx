import { ListChecksIcon, PlusIcon, XIcon } from 'lucide-react'
import { type FormEvent, useEffect, useRef, useState } from 'react'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { TaskItem } from '@/components/ui/task-list'
import { toast } from '@/components/ui/toast'
import { errorMessage } from '@/lib/errors'
import { useT } from '@/lib/i18n'
import type { ShoppingItem } from '@/lib/types'
import { useExpenses } from '@/stores/expenses'
import { useShopping } from '@/stores/shopping'
import { useUi } from '@/stores/ui'
import { Page, SectionTitle } from './page'

function ItemRow({
  item,
  onToggle,
  onRemove,
  onSettled,
}: {
  item: ShoppingItem
  onToggle(): void
  onRemove(): void
  onSettled?(): void
}) {
  const t = useT()
  return (
    <li className="flex items-center gap-1 border-b border-border/70 pr-1 last:border-b-0">
      <TaskItem
        label={item.name}
        checked={item.done}
        accent="var(--success)"
        aria-label={t(item.done ? 'shopping.untick' : 'shopping.tick', { name: item.name })}
        onCheckedChange={onToggle}
        onSettled={onSettled}
        className="w-full min-w-0 flex-1 items-center rounded-none bg-transparent px-3 py-3 focus-visible:ring-inset focus-visible:ring-offset-0"
      />
      <Button
        variant="ghost"
        size="icon"
        className="shrink-0 rounded-lg text-muted-foreground"
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

  // Just-ticked items stay under "To buy" until their tick animation ends.
  const [settling, setSettling] = useState<number[]>([])
  // ponytail: id order matches the API's created_at order, so the row keeps its place while it animates.
  const todo = items.filter((i) => !i.done || settling.includes(i.id)).sort((a, b) => a.id - b.id)
  const bought = items.filter((i) => i.done && !settling.includes(i.id))

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
    if (!item.done) setSettling((ids) => [...ids, item.id])
    try {
      await useShopping.getState().setDone(item.id, !item.done)
    } catch (err) {
      setSettling((ids) => ids.filter((id) => id !== item.id))
      toast.error(errorMessage(err, t('shopping.failed')))
    }
  }

  // The tick animation ended: move the item to "Bought" and offer to log it. Closing the sheet skips.
  function settled(item: ShoppingItem) {
    if (!settling.includes(item.id)) return
    setSettling((ids) => ids.filter((id) => id !== item.id))
    const categoryId = useExpenses.getState().categories[0]?.id ?? null
    openExpense(null, { categoryId, amount: null, note: item.name })
  }

  async function run(action: () => Promise<void>) {
    try {
      await action()
    } catch (err) {
      toast.error(errorMessage(err, t('shopping.failed')))
    }
  }

  return (
    <Page className="gap-5">
      <form onSubmit={(e) => void add(e)} className="flex gap-2">
        <Input
          ref={input}
          value={name}
          maxLength={200}
          onChange={(e) => setName(e.target.value)}
          placeholder={t('shopping.addPlaceholder')}
          aria-label={t('shopping.addPlaceholder')}
          enterKeyHint="done"
          className="h-12 flex-1 rounded-lg px-4 text-base"
        />
        <Button type="submit" size="icon-lg" className="size-12 rounded-lg" aria-label={t('shopping.add')} disabled={!name.trim() || adding}>
          <PlusIcon className="size-5" />
        </Button>
      </form>

      {loaded && items.length === 0 && (
        <div className="flex flex-col items-center gap-3 rounded-lg border border-dashed p-8 text-center">
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
          <ul className="overflow-hidden rounded-lg bg-card ring-1 ring-border">
            {todo.map((item) => (
              <ItemRow
                key={item.id}
                item={item}
                onToggle={() => void toggle(item)}
                onSettled={() => settled(item)}
                onRemove={() => void run(() => useShopping.getState().remove(item.id))}
              />
            ))}
          </ul>
        </section>
      )}

      {bought.length > 0 && (
        <section className="flex flex-col gap-2">
          <SectionTitle
            action={
              <Button variant="ghost" size="sm" className="h-7 rounded-lg text-muted-foreground" onClick={() => void run(() => useShopping.getState().clearBought())}>
                {t('shopping.clearBought')}
              </Button>
            }
          >
            {t('shopping.bought')} · {bought.length}
          </SectionTitle>
          <ul className="overflow-hidden rounded-lg bg-card ring-1 ring-border">
            {bought.map((item) => (
              <ItemRow key={item.id} item={item} onToggle={() => void toggle(item)} onRemove={() => void run(() => useShopping.getState().remove(item.id))} />
            ))}
          </ul>
        </section>
      )}
    </Page>
  )
}
