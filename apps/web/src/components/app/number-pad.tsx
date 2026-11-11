import { DeleteIcon } from 'lucide-react'
import { useEffect, useRef } from 'react'
import { useKeyboardInset } from '@/hooks/use-keyboard-inset'
import { useT } from '@/lib/i18n'
import { cn } from '@/lib/utils'

const KEYS = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', 'back']

export interface NumberPadProps {
  onKey(key: string): void
  onEnter?(): void
  onEscape?(): void
  /** A flat grid with thin lines and a fixed height (the full screen forms). */
  flat?: boolean
  className?: string
}

function isTextField(el: EventTarget | null): boolean {
  return el instanceof HTMLElement && ['INPUT', 'SELECT', 'TEXTAREA'].includes(el.tagName)
}

/**
 * On-screen keys, plus the hardware keyboard while no text field has focus.
 * The small pad hides while the phone keyboard is up (typing a note), so the sheet
 * fits above it. The flat pad stays: the keyboard just covers it.
 */
export function NumberPad({ onKey, onEnter, onEscape, flat, className }: NumberPadProps) {
  const t = useT()
  // Latest handlers without re-binding the window listener on every render.
  const handlers = useRef({ onKey, onEnter, onEscape })
  handlers.current = { onKey, onEnter, onEscape }

  useEffect(() => {
    function onKeyDown(e: KeyboardEvent) {
      if (isTextField(e.target) || e.metaKey || e.ctrlKey || e.altKey) return
      const h = handlers.current
      let handled = true
      if (/^[0-9]$/.test(e.key)) h.onKey(e.key)
      else if (e.key === '.' || e.key === ',') h.onKey('.')
      else if (e.key === 'Backspace') h.onKey('back')
      else if (e.key === 'Enter' && h.onEnter) h.onEnter()
      else if (e.key === 'Escape' && h.onEscape) h.onEscape()
      else handled = false
      if (handled) e.preventDefault()
    }
    window.addEventListener('keydown', onKeyDown)
    return () => window.removeEventListener('keydown', onKeyDown)
  }, [])

  const keyboard = useKeyboardInset()
  if (keyboard.open && !flat) return null

  return (
    <div
      className={cn(
        'grid grid-cols-3',
        // The 1px gaps show the border color behind the keys: those are the lines.
        // A fixed height (svh does not change when the browser bar or the keyboard moves),
        // so the pad never grows, shrinks or moves when the fields above it change.
        flat ? 'h-[clamp(15rem,40svh,23rem)] shrink-0 grid-rows-4 gap-px border-t bg-border' : 'gap-2',
        className
      )}
      data-vaul-no-drag=""
    >
      {KEYS.map((key) => {
        const digit = key !== '.' && key !== 'back'
        return (
          <button
            key={key}
            type="button"
            aria-label={key === 'back' ? t('expenseModal.backspace') : key}
            onClick={() => onKey(key)}
            className={cn(
              'flex items-center justify-center text-2xl font-medium tabular-nums select-none',
              flat
                ? 'bg-background transition-colors duration-75 active:bg-muted'
                : [
                    // A solid key (no shadow) that darkens and shrinks a little when pressed.
                    'h-[clamp(2.5rem,6.2dvh,3.25rem)] rounded-lg',
                    'bg-secondary transition-[transform,background-color] duration-75',
                    'hover:bg-[color-mix(in_oklch,var(--secondary),var(--foreground)_6%)]',
                    'active:scale-95 active:bg-[color-mix(in_oklch,var(--secondary),var(--foreground)_12%)]',
                  ],
              !digit && 'text-muted-foreground'
            )}
          >
            {key === 'back' ? <DeleteIcon className="size-6" /> : key}
          </button>
        )
      })}
    </div>
  )
}
