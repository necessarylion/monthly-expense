import { useEffect, useMemo, useState } from 'react'
import { api } from '@/lib/api'
import { currentMonthKey, shiftMonth } from '@/lib/format'
import { monthTodayIndex, NO_CATEGORY_ID } from '@/lib/overview'
import type { Expense } from '@/lib/types'
import { useCategoryById, useExpenses } from '@/stores/expenses'
import { useGroups } from '@/stores/groups'

export interface MonthCompare {
  /** The month we compare with, `YYYY-MM`. */
  previous: string
  /** Compared up to this day of the month; null = the whole month. */
  upToDay: number | null
  /** This month minus last month, in cents. Negative = spent less. */
  diffCents: number
  /** Percent change per category bucket, or 'new' when last month had none. */
  byCategory: Map<number, number | 'new'>
}

function dayOf(e: Expense): number {
  return Number(e.occurredOn.slice(8, 10))
}

/**
 * This month against last month. For the current month both are cut at
 * today's day number ("by day 8"), so a half-done month is compared fairly.
 */
export function useMonthCompare(): MonthCompare | null {
  const groupId = useGroups((s) => s.activeId)
  const month = useExpenses((s) => s.month)
  const expenses = useExpenses((s) => s.expenses)
  const categoryById = useCategoryById()
  const previous = shiftMonth(month, -1)
  const [prev, setPrev] = useState<{ key: string; list: Expense[] } | null>(null)

  useEffect(() => {
    if (!groupId) return
    let live = true
    api
      .get<{ data: Expense[] }>('/expenses', { params: { month: previous } })
      .then(({ data }) => live && setPrev({ key: `${groupId}:${previous}`, list: data.data }))
      .catch(() => {})
    return () => {
      live = false
    }
  }, [groupId, previous])

  return useMemo(() => {
    // Wait for the right month's data, and skip months that haven't started.
    if (!prev || prev.key !== `${groupId}:${previous}` || month > currentMonthKey()) return null
    const upToDay = monthTodayIndex(month)
    const cut = upToDay ?? 31
    const bucket = (e: Expense) => (e.categoryId !== null && categoryById.has(e.categoryId) ? e.categoryId : NO_CATEGORY_ID)

    const now = new Map<number, number>()
    const before = new Map<number, number>()
    let nowTotal = 0
    let beforeTotal = 0
    for (const e of expenses) {
      if (dayOf(e) > cut) continue
      nowTotal += e.amountCents
      now.set(bucket(e), (now.get(bucket(e)) ?? 0) + e.amountCents)
    }
    for (const e of prev.list) {
      if (dayOf(e) > cut) continue
      beforeTotal += e.amountCents
      before.set(bucket(e), (before.get(bucket(e)) ?? 0) + e.amountCents)
    }
    // Nothing last month: there is nothing to compare with.
    if (beforeTotal === 0) return null

    const byCategory = new Map<number, number | 'new'>()
    for (const [id, cents] of now) {
      const last = before.get(id) ?? 0
      byCategory.set(id, last === 0 ? 'new' : Math.round(((cents - last) / last) * 100))
    }
    return { previous, upToDay, diffCents: nowTotal - beforeTotal, byCategory }
  }, [prev, groupId, previous, month, expenses, categoryById])
}
