import type { ReactNode } from 'react'
import { PullToRefresh } from '@/components/app/pull-to-refresh'
import { cn } from '@/lib/utils'

/**
 * One tab's scroll area. On phones it runs under the floating tab bar, so the
 * bottom padding clears it. Wide screens (Home, Wallet) pass `lg:max-w-6xl`.
 */
export function Page({
  onRefresh,
  className,
  children,
}: {
  onRefresh?: () => Promise<unknown>
  className?: string
  children: ReactNode
}) {
  const body = (
    <div className={cn('mx-auto flex max-w-2xl flex-col gap-4 px-4 pt-4 lg:px-8 pb-[calc(6rem+env(safe-area-inset-bottom))] lg:pt-4 lg:pb-12', className)}>
      {children}
    </div>
  )
  if (!onRefresh) return <div className="no-scrollbar h-full overflow-y-auto overscroll-y-contain">{body}</div>
  return (
    <PullToRefresh onRefresh={onRefresh} className="h-full">
      {body}
    </PullToRefresh>
  )
}

export function SectionTitle({ children, action }: { children: ReactNode; action?: ReactNode }) {
  return (
    <div className="flex items-center justify-between gap-2 px-1 pt-2">
      <h2 className="text-sm font-medium text-muted-foreground">{children}</h2>
      {action}
    </div>
  )
}
