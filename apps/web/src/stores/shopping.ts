import { create } from 'zustand'
import { api } from '@/lib/api'
import type { ShoppingItem } from '@/lib/types'
import { useGroups } from './groups'

interface ShoppingState {
  items: ShoppingItem[]
  loaded: boolean
  load(): Promise<void>
  add(name: string): Promise<void>
  setDone(id: number, done: boolean): Promise<void>
  remove(id: number): Promise<void>
  clearBought(): Promise<void>
}

/** Still to buy (oldest first), then bought (latest first), as the API sorts it. */
function sorted(items: ShoppingItem[]): ShoppingItem[] {
  const todo = items.filter((i) => !i.done)
  const done = items.filter((i) => i.done).sort((a, b) => (b.doneAt ?? '').localeCompare(a.doneAt ?? '') || b.id - a.id)
  return [...todo, ...done]
}

/** The active group's shared shopping list. Changes show at once and roll back on failure. */
export const useShopping = create<ShoppingState>((set, get) => ({
  items: [],
  loaded: false,

  async load() {
    if (!useGroups.getState().activeId) {
      set({ items: [], loaded: true })
      return
    }
    const { data } = await api.get<{ data: ShoppingItem[] }>('/shopping-items')
    set({ items: data.data, loaded: true })
  },

  async add(name) {
    const { data } = await api.post<{ data: ShoppingItem }>('/shopping-items', { name })
    set({ items: sorted([...get().items, data.data]) })
  },

  async setDone(id, done) {
    const before = get().items
    const doneAt = done ? new Date().toISOString() : null
    set({ items: sorted(before.map((i) => (i.id === id ? { ...i, done, doneAt } : i))) })
    try {
      const { data } = await api.patch<{ data: ShoppingItem }>(`/shopping-items/${id}`, { done })
      set({ items: sorted(get().items.map((i) => (i.id === id ? data.data : i))) })
    } catch (e) {
      set({ items: before })
      throw e
    }
  },

  async remove(id) {
    const before = get().items
    set({ items: before.filter((i) => i.id !== id) })
    try {
      await api.delete(`/shopping-items/${id}`)
    } catch (e) {
      set({ items: before })
      throw e
    }
  },

  async clearBought() {
    const before = get().items
    set({ items: before.filter((i) => !i.done) })
    try {
      await api.delete('/shopping-items/done')
    } catch (e) {
      set({ items: before })
      throw e
    }
  },
}))

// Another group, another list.
useGroups.subscribe((state, prev) => {
  if (state.activeId === prev.activeId) return
  useShopping.setState({ items: [], loaded: false })
  if (state.activeId) void useShopping.getState().load().catch(() => {})
})
