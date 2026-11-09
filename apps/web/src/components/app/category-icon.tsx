import { CircleHelpIcon } from 'lucide-react'
import { iconFor } from '@/lib/icons'
import { tintBg } from '@/lib/overview'
import { cn } from '@/lib/utils'

/** A tinted rounded tile with the category glyph. `color === null` is "no category". */
export function CategoryIcon({
  iconKey,
  color,
  size = 36,
  className,
}: {
  iconKey: string | null
  color: string | null
  size?: number
  className?: string
}) {
  const Icon = color === null ? CircleHelpIcon : iconFor(iconKey ?? '')
  return (
    <span
      aria-hidden="true"
      className={cn('inline-flex shrink-0 items-center justify-center rounded-[30%]', className)}
      style={{
        width: size,
        height: size,
        background: tintBg(color, 18),
        color: color ?? 'var(--muted-foreground)',
      }}
    >
      <Icon style={{ width: Math.round(size * 0.48), height: Math.round(size * 0.48) }} strokeWidth={2.2} />
    </span>
  )
}
