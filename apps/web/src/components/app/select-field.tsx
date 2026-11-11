import { ChevronDownIcon } from 'lucide-react'
import { type ReactNode, useState } from 'react'
import { ChoiceSheet } from '@/components/app/choice-sheet'
import { cn } from '@/lib/utils'

export interface SelectFieldOption {
  value: string
  label: string
  /** Extra text in the sheet only (e.g. the currency name next to its code). */
  hint?: string
  /** Shown before the label in the sheet only (e.g. a wallet color dot). */
  icon?: ReactNode
}

export interface SelectFieldProps {
  value: string
  onChange(value: string): void
  options: SelectFieldOption[]
  size?: 'sm' | 'default' | 'lg'
  /** Shown before the label (e.g. a wallet icon). */
  icon?: ReactNode
  className?: string
  /** Also the title of the picker sheet. */
  'aria-label': string
}

/** A box that shows the chosen label. A tap opens the options in a bottom sheet. */
export function SelectField({ value, onChange, options, size = 'default', icon, className, ...rest }: SelectFieldProps) {
  const [open, setOpen] = useState(false)
  const current = options.find((o) => o.value === value)
  const items = options.map((o) => ({ value: o.value, label: o.label, hint: o.hint, icon: o.icon }))
  return (
    <>
      <button
        type="button"
        data-size={size}
        aria-label={rest['aria-label']}
        aria-haspopup="dialog"
        onClick={() => setOpen(true)}
        className={cn(
          'relative flex h-8 w-fit min-w-0 cursor-pointer items-center gap-1.5 rounded-lg border border-input bg-transparent pr-2 pl-2.5 text-left text-sm whitespace-nowrap transition-colors outline-none focus-visible:border-ring focus-visible:ring-3 focus-visible:ring-ring/50 data-[size=lg]:h-11 data-[size=sm]:h-7 dark:bg-input/30 [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*=size-])]:size-4',
          className
        )}
      >
        {icon}
        <span className="min-w-0 flex-1 truncate">{current?.label ?? ''}</span>
        <ChevronDownIcon className="size-4 opacity-60" />
      </button>
      <ChoiceSheet open={open} onClose={() => setOpen(false)} title={rest['aria-label']} items={items} value={value} onSelect={onChange} />
    </>
  )
}
