import { ChevronLeftIcon } from 'lucide-react'
import { Dialog } from 'radix-ui'
import { type ReactNode, type TouchEvent, useRef } from 'react'
import { t } from '@/lib/i18n'
import { focusWithoutPan } from '@/lib/scroll'

export interface FullScreenProps {
  open: boolean
  onClose(): void
  /** For screen readers only: the page has no header. */
  title: string
  /** Next to the back button, in the top row. */
  top?: ReactNode
  /** The form fields. This part scrolls when the screen is short. */
  fields: ReactNode
  /** Under the fields, down to the footer: the amount (in the middle of the free height) and the number pad. */
  children: ReactNode
  /** Flush on the bottom edge (the save bar). */
  footer: ReactNode
}

/**
 * A form that covers the whole screen, tab bar included: a back button, the
 * fields, then the amount and the number pad down to the bottom edge. On
 * desktop it is a phone-wide column in the middle.
 */
export function FullScreen({ open, onClose, title, top, fields, children, footer }: FullScreenProps) {
  // A tap on a text field (the note): focus it ourselves, so Safari does not pan
  // the page up. The screen stays put and the keyboard covers the number pad.
  const touch = useRef<{ x: number; y: number } | null>(null)
  function onTouchStart(e: TouchEvent) {
    const p = e.touches[0]
    touch.current = e.touches.length === 1 ? { x: p.clientX, y: p.clientY } : null
  }
  function onTouchEnd(e: TouchEvent) {
    const field = e.target
    const start = touch.current
    const p = e.changedTouches[0]
    if (!start || !(field instanceof HTMLInputElement || field instanceof HTMLTextAreaElement)) return
    if (field === document.activeElement || field.disabled || field.readOnly) return
    if (Math.abs(p.clientX - start.x) > 10 || Math.abs(p.clientY - start.y) > 10) return // a scroll
    e.preventDefault()
    focusWithoutPan(field)
  }
  return (
    <Dialog.Root open={open} onOpenChange={(next) => !next && onClose()}>
      <Dialog.Portal>
        <Dialog.Overlay className="fixed inset-0 z-50 bg-black/40 backdrop-blur-[2px] data-open:animate-in data-open:fade-in-0 data-closed:animate-out data-closed:fade-out-0" />
        <Dialog.Content
          aria-describedby={undefined}
          onTouchStart={onTouchStart}
          onTouchEnd={onTouchEnd}
          className="fixed inset-0 z-50 mx-auto flex max-w-md flex-col overflow-hidden bg-chrome pt-safe text-foreground outline-none duration-200 data-open:animate-in data-open:slide-in-from-bottom data-closed:animate-out data-closed:slide-out-to-bottom sm:inset-y-4 sm:rounded-lg sm:border sm:shadow-2xl"
        >
          <Dialog.Title className="sr-only">{title}</Dialog.Title>
          <div className="flex shrink-0 items-center gap-2 px-5 pt-3">
            <Dialog.Close
              aria-label={t('common.back')}
              className="flex size-11 shrink-0 items-center justify-center rounded-lg bg-muted text-muted-foreground transition-transform active:scale-90"
            >
              <ChevronLeftIcon className="size-5" />
            </Dialog.Close>
            <div className="min-w-0 flex-1">{top}</div>
          </div>
          {/* The gaps grow with the screen height: about 11px on a small phone, up to 24px on a tall one. */}
          <div className="no-scrollbar flex min-h-0 shrink flex-col gap-[clamp(0.5rem,calc(4svh-1rem),1.5rem)] overflow-y-auto overscroll-contain px-5 pt-[clamp(0.5rem,calc(4svh-1rem),1.5rem)] pb-1 *:shrink-0">
            {fields}
          </div>
          <div className="flex flex-1 flex-col">{children}</div>
          <div className="shrink-0">{footer}</div>
        </Dialog.Content>
      </Dialog.Portal>
    </Dialog.Root>
  )
}

/**
 * The save bar of a `FullScreen`: flat, edge to edge, down into the phone's
 * bottom safe area. The label is centered over the whole bar, safe area included.
 */
export function FullScreenSave({
  label,
  disabled,
  onClick,
}: {
  label: string
  disabled: boolean
  onClick(): void
}) {
  return (
    <div className="flex items-stretch border-t">
      <button
        type="button"
        disabled={disabled}
        onClick={onClick}
        className="flex h-[calc(3.5rem+env(safe-area-inset-bottom))] flex-1 items-center justify-center bg-primary text-base font-semibold tracking-wide text-primary-foreground uppercase transition-opacity active:opacity-80 disabled:opacity-40"
      >
        {label}
      </button>
    </div>
  )
}
