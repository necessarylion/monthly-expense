import { CalendarDaysIcon } from 'lucide-react'
import { Dialog } from 'radix-ui'
import { useState } from 'react'
import { Calendar } from '@/components/ui/calendar'
import { todayIso } from '@/lib/format'
import { useLocale, useT } from '@/lib/i18n'
import { cn } from '@/lib/utils'

function toIso(d: Date): string {
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
}

function fromIso(iso: string): Date {
  const [y, m, d] = iso.split('-').map(Number)
  return new Date(y, m - 1, d)
}

function yesterdayIso(): string {
  const d = new Date()
  d.setDate(d.getDate() - 1)
  return toIso(d)
}

const SEGMENT =
  'flex h-9 flex-1 items-center justify-center gap-1.5 rounded-full px-3 text-sm font-medium transition-colors'

/** Today | Yesterday | a calendar for any other past day. Future days are blocked. */
export function DatePicker({ value, onChange }: { value: string; onChange(v: string): void }) {
  const t = useT()
  const locale = useLocale((s) => s.locale)
  const [open, setOpen] = useState(false)
  const today = todayIso()
  const yesterday = yesterdayIso()
  const other = value !== today && value !== yesterday
  const otherLabel = other
    ? new Intl.DateTimeFormat(locale, { day: 'numeric', month: 'short' }).format(fromIso(value))
    : null

  function segment(active: boolean) {
    return cn(SEGMENT, active ? 'bg-background text-foreground shadow-sm' : 'text-muted-foreground')
  }

  return (
    <div role="group" aria-label={t('expenseModal.date')} className="flex gap-1 rounded-full bg-muted p-1" data-vaul-no-drag="">
      <button type="button" className={segment(value === today)} onClick={() => onChange(today)}>
        {t('expenseModal.today')}
      </button>
      <button type="button" className={segment(value === yesterday)} onClick={() => onChange(yesterday)}>
        {t('expenseModal.yesterday')}
      </button>
      <button type="button" className={segment(other)} aria-label={t('expenseModal.pickDate')} onClick={() => setOpen(true)}>
        <CalendarDaysIcon className="size-4" />
        {otherLabel}
      </button>
      {/* A centered modal: a popover under the segment overflowed the sheet on phones. */}
      <Dialog.Root open={open} onOpenChange={setOpen}>
        <Dialog.Portal>
          <Dialog.Overlay className="fixed inset-0 z-[60] bg-black/50 backdrop-blur-[2px] data-open:animate-in data-open:fade-in-0 data-closed:animate-out data-closed:fade-out-0" />
          <Dialog.Content
            aria-describedby={undefined}
            className="fixed top-1/2 left-1/2 z-[60] -translate-x-1/2 -translate-y-1/2 rounded-3xl border bg-popover p-3 text-popover-foreground shadow-2xl outline-none duration-150 data-open:animate-in data-open:fade-in-0 data-open:zoom-in-95 data-closed:animate-out data-closed:fade-out-0 data-closed:zoom-out-95"
          >
            <Dialog.Title className="sr-only">{t('expenseModal.pickDate')}</Dialog.Title>
            <Calendar
              mode="single"
              className="bg-transparent [--cell-size:--spacing(10)]"
              selected={fromIso(value)}
              defaultMonth={fromIso(value)}
              disabled={{ after: new Date() }}
              onSelect={(d) => {
                if (!d) return
                onChange(toIso(d))
                setOpen(false)
              }}
            />
          </Dialog.Content>
        </Dialog.Portal>
      </Dialog.Root>
    </div>
  )
}
