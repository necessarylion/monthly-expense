import { ChevronLeftIcon } from 'lucide-react'
import { Dialog } from 'radix-ui'
import type { ReactNode } from 'react'
import { useKeyboardInset } from '@/hooks/use-keyboard-inset'
import { t } from '@/lib/i18n'

export interface FullScreenProps {
  open: boolean
  onClose(): void
  /** For screen readers only: the page has no header. */
  title: string
  /** Next to the back button, in the top row. */
  top?: ReactNode
  /** The form fields. This part scrolls when the screen is short. */
  fields: ReactNode
  /** Under the fields, down to the footer (the amount and the number pad). */
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
  // Typing a note: Safari pans the page up to show the field. Move the screen down by as
  // much, so it stays put and the keyboard covers the bottom (the number pad) instead.
  const { offsetTop } = useKeyboardInset()
  return (
    <Dialog.Root open={open} onOpenChange={(next) => !next && onClose()}>
      <Dialog.Portal>
        <Dialog.Overlay className="fixed inset-0 z-50 bg-black/40 backdrop-blur-[2px] data-open:animate-in data-open:fade-in-0 data-closed:animate-out data-closed:fade-out-0" />
        <Dialog.Content
          aria-describedby={undefined}
          style={offsetTop ? { top: offsetTop, bottom: -offsetTop } : undefined}
          className="fixed inset-0 z-50 mx-auto flex max-w-md flex-col overflow-hidden bg-popover pt-safe text-popover-foreground outline-none duration-200 data-open:animate-in data-open:slide-in-from-bottom data-closed:animate-out data-closed:slide-out-to-bottom sm:inset-y-4 sm:rounded-[28px] sm:border sm:shadow-2xl"
        >
          <Dialog.Title className="sr-only">{title}</Dialog.Title>
          <div className="flex shrink-0 items-center gap-2 px-5 pt-3 pb-1">
            <Dialog.Close
              aria-label={t('common.back')}
              className="flex size-9 shrink-0 items-center justify-center rounded-full bg-muted text-muted-foreground transition-transform active:scale-90"
            >
              <ChevronLeftIcon className="size-5" />
            </Dialog.Close>
            <div className="min-w-0 flex-1">{top}</div>
          </div>
          <div className="no-scrollbar flex min-h-0 shrink flex-col gap-3 overflow-y-auto overscroll-contain px-5 pt-2 pb-1 *:shrink-0">
            {fields}
          </div>
          <div className="flex min-h-0 flex-1 flex-col">{children}</div>
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
  leading,
}: {
  label: string
  disabled: boolean
  onClick(): void
  /** Left of the bar (the delete button when editing). */
  leading?: ReactNode
}) {
  return (
    <div className="flex items-stretch border-t">
      {leading && <div className="flex items-center px-3">{leading}</div>}
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
