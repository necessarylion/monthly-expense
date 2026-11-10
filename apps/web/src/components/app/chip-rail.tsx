import type { ComponentProps } from 'react'
import { cn } from '@/lib/utils'

/** Light glass over the sheet's side padding: chips blur a little as they scroll under it, but stay readable. */
const GLASS = 'pointer-events-none absolute inset-y-0 z-10 w-5 bg-popover/10 backdrop-blur-[1px]'

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
