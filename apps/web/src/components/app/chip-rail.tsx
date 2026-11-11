import type { ComponentProps } from 'react'
import { cn } from '@/lib/utils'

/**
 * A row of chips that scrolls sideways. It stays inside the sheet's `px-5`,
 * so its edges line up with the inputs above and below it.
 */
export function ChipRail({ className, children, ...props }: ComponentProps<'div'>) {
  return (
    <div {...props} data-vaul-no-drag="" className={cn('no-scrollbar overflow-x-auto', className)}>
      {children}
    </div>
  )
}
