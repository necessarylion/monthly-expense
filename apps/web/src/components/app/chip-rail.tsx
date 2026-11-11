import type { ComponentProps } from 'react'
import { cn } from '@/lib/utils'

/**
 * Fades the chips out over the sheet's side padding. A mask, not an overlay,
 * so it matches any background (sheet, full screen, every theme).
 */
const FADE = '[mask-image:linear-gradient(to_right,transparent,#000_1.25rem,#000_calc(100%-1.25rem),transparent)]'

/**
 * A row of chips that scrolls sideways edge to edge in a sheet (it bleeds into
 * the sheet's `px-5`). Chips fade out at both edges.
 */
export function ChipRail({ className, children, ...props }: ComponentProps<'div'>) {
  return (
    <div className="-mx-5">
      <div {...props} data-vaul-no-drag="" className={cn('no-scrollbar overflow-x-auto px-5', FADE, className)}>
        {children}
      </div>
    </div>
  )
}
