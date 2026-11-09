// The floating, height-morphing drawer is adapted from Rare UI's family-drawer
// (https://rareui.com), MIT + Commons Clause + Attribution. Copyright (c) 2026 Swami Malode.
import { AnimatePresence, motion } from 'motion/react'
import type { ReactNode } from 'react'
import useMeasure from 'react-use-measure'
import { Drawer } from 'vaul'
import { XIcon } from 'lucide-react'
import { t } from '@/lib/i18n'
import { useIsDesktop } from '@/hooks/use-is-desktop'
import { useKeyboardInset } from '@/hooks/use-keyboard-inset'
import { cn } from '@/lib/utils'

export interface SheetProps {
  open: boolean
  onClose(): void
  title: ReactNode
  /** Change this to cross-fade to another view; the height animates to fit. */
  view?: string
  /** Stays pinned under the scrolling body (e.g. the save button). */
  footer?: ReactNode
  /** Left of the close button (e.g. a back button for a sub view). */
  leading?: ReactNode
  /** Hide the title row to save space; the title stays for screen readers. */
  hideTitle?: boolean
  /** Sit flush on the bottom edge (no gap, square bottom corners) instead of floating. */
  docked?: boolean
  /** On desktop, a centered modal instead of the right side panel. */
  centerOnDesktop?: boolean
  className?: string
  children: ReactNode
}

const EASE = [0.26, 0.08, 0.25, 1] as const

/**
 * A bottom sheet that floats above the page and morphs its height between views.
 * On desktop it is a full-height panel that slides in from the right, or a
 * centered modal with `centerOnDesktop`.
 */
export function Sheet({ open, onClose, title, view = 'main', footer, leading, hideTitle, docked, centerOnDesktop, className, children }: SheetProps) {
  const [ref, bounds] = useMeasure()
  const desktop = useIsDesktop()
  const centered = desktop && centerOnDesktop
  // The right side panel. A centered modal uses the phone layout instead.
  const panel = desktop && !centered
  // Hidden titles save room on a phone; the desktop panel has room and no drag handle.
  const titleHidden = hideTitle && !desktop
  // Phone keyboard: sit right on top of it and fit in what is left of the screen.
  const keyboard = useKeyboardInset()
  const lifted = !desktop && keyboard.open
  const gap = docked ? 0 : 8

  return (
    <Drawer.Root direction={panel ? 'right' : 'bottom'} open={open} onOpenChange={(next) => !next && onClose()} repositionInputs={false}>
      <Drawer.Portal>
        <Drawer.Overlay className="fixed inset-0 z-50 bg-black/40 backdrop-blur-[2px]" />
        <Drawer.Content
          aria-describedby={undefined}
          className={cn(
            'fixed z-50 overflow-hidden border bg-popover text-popover-foreground shadow-2xl outline-none',
            panel
              ? 'inset-y-0 right-0 w-[440px] max-w-full border-y-0 border-r-0 pt-4'
              : centered
                ? // m-auto + h-fit centers it without a transform (vaul animates the transform).
                  'inset-0 m-auto h-fit w-full max-w-md rounded-[28px] pt-2'
                : docked
                ? 'inset-x-0 bottom-0 mx-auto max-w-md rounded-t-[28px] border-b-0 pb-safe'
                : 'inset-x-2 bottom-2 mx-auto max-w-md rounded-[28px] sm:bottom-6',
            className
          )}
          style={
            lifted
              ? { bottom: keyboard.inset + gap, marginBottom: 0, paddingBottom: 0 }
              : docked || desktop
                ? undefined
                : { marginBottom: 'env(safe-area-inset-bottom)' }
          }
        >
          <motion.div
            className={cn(panel && 'h-full')}
            animate={panel ? undefined : { height: bounds.height || 'auto' }}
            transition={{ duration: 0.25, ease: EASE }}
          >
            <div
              ref={ref}
              style={lifted ? { maxHeight: keyboard.height - gap * 2 } : undefined}
              className={cn('flex flex-col', panel ? 'h-full' : centered ? 'max-h-[80dvh]' : 'max-h-[calc(100dvh-2rem-env(safe-area-inset-top))]')}>
              {!desktop && <div className="mx-auto mt-2 h-1 w-10 shrink-0 rounded-full bg-muted-foreground/25" />}
              {titleHidden ? (
                // No visible header: close by pulling down, tapping outside, or Escape.
                <Drawer.Title className="sr-only">{title}</Drawer.Title>
              ) : (
                <header className="flex shrink-0 items-center gap-2 px-5 pt-3 pb-2">
                  {leading}
                  <Drawer.Title className="min-w-0 flex-1 truncate text-lg font-semibold tracking-tight">
                    {title}
                  </Drawer.Title>
                  <Drawer.Close
                    data-vaul-no-drag=""
                    aria-label={t('common.close')}
                    className="flex size-8 shrink-0 items-center justify-center rounded-full bg-muted text-muted-foreground transition-transform active:scale-90"
                  >
                    <XIcon className="size-4" />
                  </Drawer.Close>
                </header>
              )}
              <AnimatePresence mode="popLayout" initial={false}>
                <motion.div
                  key={view}
                  initial={{ opacity: 0, scale: 0.97 }}
                  animate={{ opacity: 1, scale: 1 }}
                  exit={{ opacity: 0, scale: 0.97 }}
                  transition={{ duration: 0.2, ease: EASE }}
                  className="no-scrollbar min-h-0 flex-1 overflow-y-auto overscroll-contain px-5 pb-4"
                >
                  {children}
                </motion.div>
              </AnimatePresence>
              {footer && <div className="shrink-0 px-5 pb-5">{footer}</div>}
            </div>
          </motion.div>
        </Drawer.Content>
      </Drawer.Portal>
    </Drawer.Root>
  )
}
