import { useEffect, useState } from 'react'
import { api } from '@/lib/api'
import { useExpenses } from '@/stores/expenses'
import { useGroups } from '@/stores/groups'

/** An expense this group logs again and again (from `GET /expenses/frequent`). */
export interface QuickAdd {
  categoryId: number | null
  amountCents: number
  note: string | null
  uses: number
  lastOn: string
}

/** Refetched when the group changes or the month reloads (after any add, edit or delete). */
export function useQuickAdds(): QuickAdd[] {
  const groupId = useGroups((s) => s.activeId)
  const syncedAt = useExpenses((s) => s.syncedAt)
  const [list, setList] = useState<QuickAdd[]>([])

  useEffect(() => {
    if (!groupId) return
    let live = true
    api
      .get<{ data: QuickAdd[] }>('/expenses/frequent')
      .then(({ data }) => live && setList(data.data))
      .catch(() => {})
    return () => {
      live = false
    }
  }, [groupId, syncedAt])

  return list
}
