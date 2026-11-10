import { create } from 'zustand'
import type { Expense } from '@/lib/types'

export type Tab = 'home' | 'accounts' | 'list' | 'settings'
export type SettingsTab =
  | 'root'
  | 'budget'
  | 'wallet'
  | 'group'
  | 'groups'
  | 'appearance'
  | 'language'
  | 'mcp'
  | 'passkeys'
  | 'rates'
  | 'recurring'
  | 'search'
  | 'twoFactor'
  | 'year'

export const TABS: Tab[] = ['home', 'accounts', 'list', 'settings']

/** Starting values for a new expense (a long-pressed quick-add chip, a bought shopping item). */
export interface ExpenseDraft {
  categoryId: number | null
  /** Null leaves the amount empty for the user to type. */
  amount: number | null
  note: string | null
}

/** Screen navigation and which sheets are open. Nothing here is persisted. */
interface UiState {
  tab: Tab
  settingsTab: SettingsTab
  groupsView: 'list' | 'create'
  /** `undefined` = closed, `null` = new expense, else the expense being edited. */
  expenseSheet: Expense | null | undefined
  expenseDraft: ExpenseDraft | null
  /** The expense shown read-only (tap in a list); null = closed. */
  expenseDetail: Expense | null
  categoriesOpen: boolean
  setTab(tab: Tab): void
  setSettingsTab(tab: SettingsTab): void
  setGroupsView(view: 'list' | 'create'): void
  goToBudget(): void
  openGroups(mode: 'create' | 'manage'): void
  openExpense(expense: Expense | null, draft?: ExpenseDraft): void
  closeExpense(): void
  openExpenseDetail(expense: Expense): void
  closeExpenseDetail(): void
  setCategoriesOpen(open: boolean): void
}

export const useUi = create<UiState>((set) => ({
  tab: 'home',
  settingsTab: 'root',
  groupsView: 'list',
  expenseSheet: undefined,
  expenseDraft: null,
  expenseDetail: null,
  categoriesOpen: false,
  setTab: (tab) => set({ tab }),
  setSettingsTab: (settingsTab) => set({ settingsTab }),
  setGroupsView: (groupsView) => set({ groupsView }),
  goToBudget: () => set({ tab: 'settings', settingsTab: 'budget' }),
  openGroups: (mode) =>
    set({
      tab: 'settings',
      settingsTab: mode === 'create' ? 'groups' : 'group',
      groupsView: mode === 'create' ? 'create' : 'list',
    }),
  openExpense: (expense, draft) => set({ expenseSheet: expense, expenseDraft: draft ?? null }),
  closeExpense: () => set({ expenseSheet: undefined, expenseDraft: null }),
  openExpenseDetail: (expenseDetail) => set({ expenseDetail }),
  closeExpenseDetail: () => set({ expenseDetail: null }),
  setCategoriesOpen: (categoriesOpen) => set({ categoriesOpen }),
}))
