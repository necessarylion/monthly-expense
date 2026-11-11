import { PencilIcon } from 'lucide-react'
import { useState, type ReactNode } from 'react'
import { CategoryIcon } from '@/components/app/category-icon'
import { Sheet } from '@/components/app/sheet'
import { Button } from '@/components/ui/button'
import { DeleteButton } from '@/components/ui/delete-button'
import { toast } from '@/components/ui/toast'
import { errorMessage } from '@/lib/errors'
import { formatMoneyFromCents, formatShortDate } from '@/lib/format'
import { useT } from '@/lib/i18n'
import { useAuth } from '@/stores/auth'
import { useCategoryById, useExpenses } from '@/stores/expenses'
import { useActiveGroup, useGroups } from '@/stores/groups'
import { useUi } from '@/stores/ui'

/** Read-only view of one expense, with Edit (opens the expense sheet) and Delete. */
export function ExpenseDetailSheet() {
  const t = useT()
  const expense = useUi((s) => s.expenseDetail)
  const close = useUi((s) => s.closeExpenseDetail)
  const categoryById = useCategoryById()
  const group = useActiveGroup()
  const members = useGroups((s) => s.members)
  const me = useAuth((s) => s.user?.id)
  // Keep the last expense while the sheet animates closed.
  const [shown, setShown] = useState(expense)
  if (expense && expense !== shown) setShown(expense)

  const currency = group?.currency ?? 'USD'
  const category = shown?.categoryId == null ? undefined : categoryById.get(shown.categoryId)
  const categoryName = category?.name ?? t('overview.noCategory')

  let payer: string | null = null
  if (group?.splitEnabled && shown?.paidByUserId != null) {
    payer =
      shown.paidByUserId === me
        ? t('common.you').replace(/[()]/g, '')
        : (members.find((m) => m.userId === shown.paidByUserId)?.email ?? '').split('@')[0] || null
  }

  function edit() {
    if (!shown) return
    close()
    useUi.getState().openExpense(shown)
  }

  function remove() {
    if (!shown) return
    // Close first; the list reloads behind the sheet.
    close()
    useExpenses
      .getState()
      .deleteExpense(shown.id)
      .then(() => toast.success(t('toast.expenseDeleted')))
      .catch((e) => toast.error(errorMessage(e, t('common.delete'))))
  }

  return (
    <Sheet
      docked
      open={!!expense}
      onClose={close}
      title={t('expenseModal.titleDetail')}
      footer={
        <div className="flex items-center gap-2">
          <DeleteButton onConfirm={remove} className="shrink-0" />
          <Button size="lg" className="h-12 flex-1 rounded-lg text-base" onClick={edit}>
            <PencilIcon />
            {t('expenseModal.edit')}
          </Button>
        </div>
      }
    >
      {shown && (
        <div className="flex flex-col gap-5">
          <div className="flex flex-col items-center gap-2 pt-2">
            <CategoryIcon iconKey={category?.iconKey ?? null} color={category?.color ?? null} size={48} />
            <p className="num text-4xl font-semibold tracking-tight">{formatMoneyFromCents(shown.amountCents, currency, true)}</p>
            {shown.note && <p className="max-w-full text-center text-base break-words text-muted-foreground">{shown.note}</p>}
          </div>

          <dl className="overflow-hidden rounded-lg bg-muted/60 text-sm">
            <Row label={t('expenseModal.category')}>
              <span className="flex min-w-0 items-center gap-2">
                {category && <span className="size-2.5 shrink-0 rounded-full" style={{ background: category.color }} />}
                <span className="truncate">{categoryName}</span>
              </span>
            </Row>
            <Row label={t('expenseModal.date')}>
              {formatShortDate(shown.occurredOn)} {shown.occurredOn.slice(0, 4)}
            </Row>
            {payer && <Row label={t('expenseModal.paidBy')}>{payer}</Row>}
          </dl>
        </div>
      )}
    </Sheet>
  )
}

function Row({ label, children }: { label: string; children: ReactNode }) {
  return (
    <div className="flex items-center justify-between gap-4 border-b border-border/60 px-4 py-3 last:border-b-0">
      <dt className="text-muted-foreground">{label}</dt>
      <dd className="flex min-w-0 justify-end font-medium">{children}</dd>
    </div>
  )
}
