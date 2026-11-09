import { CheckIcon } from 'lucide-react'
import type { ReactNode } from 'react'
import { Sheet } from '@/components/app/sheet'
import { cn } from '@/lib/utils'

export interface ChoiceItem {
  value: string
  label: ReactNode
  /** Small text on the right (e.g. a currency code). */
  hint?: ReactNode
  icon?: ReactNode
  destructive?: boolean
  /** Draw a line above this item, to start a new section. */
  divider?: boolean
}

export interface ChoiceSheetProps {
  open: boolean
  onClose(): void
  title: ReactNode
  items: ChoiceItem[]
  /** The chosen item gets a check mark. Leave out for action menus. */
  value?: string
  onSelect(value: string): void
}

/**
 * A list of big tap targets in a bottom sheet. Used for pickers and action
 * menus instead of small dropdowns, which are hard to hit on a phone.
 */
export function ChoiceSheet({ open, onClose, title, items, value, onSelect }: ChoiceSheetProps) {
  function choose(next: string) {
    onClose()
    onSelect(next)
  }

  return (
    <Sheet open={open} onClose={onClose} title={title} docked centerOnDesktop>
      <ul className="-mx-2 flex flex-col">
        {items.map((item) => {
          const selected = value !== undefined && item.value === value
          return (
            <li key={item.value} className={cn(item.divider && 'mt-1 border-t pt-1')}>
              <button
                type="button"
                aria-current={selected || undefined}
                onClick={() => choose(item.value)}
                className={cn(
                  'flex min-h-12 w-full items-center gap-3 rounded-xl px-3 text-left text-[15px] transition-colors active:bg-muted hover:bg-muted/60 [&_svg]:size-5 [&_svg]:shrink-0',
                  item.destructive && 'text-destructive',
                  selected && 'font-semibold'
                )}
              >
                {item.icon && <span className={cn('flex', !item.destructive && 'text-muted-foreground')}>{item.icon}</span>}
                <span className="min-w-0 flex-1 truncate">{item.label}</span>
                {item.hint && <span className="text-sm text-muted-foreground">{item.hint}</span>}
                {value !== undefined && <CheckIcon className={cn('text-primary', !selected && 'invisible')} />}
              </button>
            </li>
          )
        })}
      </ul>
    </Sheet>
  )
}
