import type { ComponentProps } from 'react'
import { cn } from '@/lib/utils'

/** Frosted glass over the sheet's side padding, so chips blur as they scroll under it. */
const GLASS = 'pointer-events-none absolute inset-y-0 z-10 w-5 bg-popover/40 backdrop-blur-[6px]'

/**
 * A row of chips that scrolls sideways edge to edge in a sheet (it bleeds into
 * the sheet's `px-5`). The two gutters get a glass overlay.
 */
export function ChipRail({ className, children, ...props }: ComponentProps<'div'>) {
  return (
    <div className="relative -mx-5">
      <div {...props} data-vaul-no-drag="" className={cn('no-scrollbar overflow-x-auto px-5', className)}>
        {children}
      </div>
      <span aria-hidden="true" className={cn(GLASS, 'left-0')} />
      <span aria-hidden="true" className={cn(GLASS, 'right-0')} />
    </div>
  )
}
