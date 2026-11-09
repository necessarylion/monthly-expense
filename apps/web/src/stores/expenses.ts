import { useMemo } from 'react'
import { create } from 'zustand'
import { api } from '@/lib/api'
import { currentMonthKey } from '@/lib/format'
import type { Category, Expense, MonthlySummary } from '@/lib/types'
import { useAccounts } from './accounts'
import { useGroups } from './groups'

interface ExpensesState {
  month: string
  categories: Category[]
  expenses: Expense[]
  summary: MonthlySummary | null
  loading: boolean
  lastError: string | null
  syncedAt: number | null
  clear(): void
  loadCategories(): Promise<void>
  loadMonth(key?: string): Promise<void>
  addExpense(payload: {
    categoryId: number
    amount: number
    occurredOn: string
    note?: string
    accountId?: number | null
  }): Promise<Expense>
  updateExpense(
    id: number,
    payload: { categoryId?: number; amount?: number; occurredOn?: string; note?: string | null }
  ): Promise<void>
  deleteExpense(id: number): Promise<void>
  addCategory(payload: { name: string; iconKey: string; color: string }): Promise<void>
  updateCategory(id: number, payload: { name?: string; iconKey?: string; color?: string }): Promise<void>
  deleteCategory(id: number): Promise<void>
}

/** Expense changes can book or adjust an entry in the default account. */
function refreshAccounts() {
  const accounts = useAccounts.getState()
  if (accounts.loaded) accounts.load().catch(() => {})
}

export const useExpenses = create<ExpensesState>((set, get) => ({
  month: currentMonthKey(),
  categories: [],
  expenses: [],
  summary: null,
  loading: false,
  lastError: null,
  syncedAt: null,

  clear() {
    set({ categories: [], expenses: [], summary: null, syncedAt: null, lastError: null })
  },

  async loadCategories() {
    if (!useGroups.getState().activeId) {
      set({ categories: [] })
      return
    }
    const { data } = await api.get<{ data: Category[] }>('/categories')
    set({ categories: data.data })
  },

  async loadMonth(key = get().month) {
    set({ month: key })
    if (!useGroups.getState().activeId) {
      get().clear()
      return
    }
    set({ loading: true, lastError: null })
    try {
      const [expRes, sumRes] = await Promise.all([
        api.get<{ data: Expense[] }>('/expenses', { params: { month: key } }),
        api.get<{ data: MonthlySummary }>('/summary', { params: { month: key } }),
      ])
      // A newer month switch may have landed meanwhile.
      if (get().month !== key) return
      set({ expenses: expRes.data.data, summary: sumRes.data.data, syncedAt: Date.now() })
    } catch (e: any) {
      set({ lastError: e?.message ?? 'Failed to load expenses' })
    } finally {
      set({ loading: false })
    }
  },

  async addExpense(payload) {
    const { data } = await api.post<{ data: Expense }>('/expenses', payload)
    await get().loadMonth()
    refreshAccounts()
    return data.data
  },

  async updateExpense(id, payload) {
    await api.patch(`/expenses/${id}`, payload)
    await get().loadMonth()
    refreshAccounts()
  },

  async deleteExpense(id) {
    await api.delete(`/expenses/${id}`)
    await get().loadMonth()
    refreshAccounts()
  },

  async addCategory(payload) {
    await api.post('/categories', payload)
    await get().loadCategories()
  },

  async updateCategory(id, payload) {
    await api.patch(`/categories/${id}`, payload)
    await get().loadCategories()
  },

  async deleteCategory(id) {
    await api.delete(`/categories/${id}`)
    await get().loadCategories()
    await get().loadMonth()
  },
}))

// Reload everything when the active group changes.
useGroups.subscribe((state, prev) => {
  if (state.activeId === prev.activeId) return
  const expenses = useExpenses.getState()
  expenses.clear()
  if (state.activeId) {
    void expenses.loadCategories().then(() => expenses.loadMonth())
  }
})

export function useCategoryById(): Map<number, Category> {
  const categories = useExpenses((s) => s.categories)
  return useMemo(() => new Map(categories.map((c) => [c.id, c])), [categories])
}
