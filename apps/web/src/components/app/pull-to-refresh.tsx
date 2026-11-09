import { RefreshCwIcon } from 'lucide-react'
import { type ReactNode, useRef, useState } from 'react'
import { cn } from '@/lib/utils'

const THRESHOLD = 64
const MAX_PULL = 96

/**
 * Touch-only pull-to-refresh. It is the scroll container itself; a pull only
 * starts when the list is already at the top.
 */
export function PullToRefresh({
  onRefresh,
  className,
  children,
}: {
  onRefresh(): Promise<unknown>
  className?: string
  children: ReactNode
}) {
  const scroller = useRef<HTMLDivElement>(null)
  const start = useRef<number | null>(null)
  const [distance, setDistance] = useState(0)
  const [refreshing, setRefreshing] = useState(false)

  function onTouchStart(e: React.TouchEvent) {
    if (refreshing || (scroller.current?.scrollTop ?? 0) > 0) return
    start.current = e.touches[0].clientY
  }

  function onTouchMove(e: React.TouchEvent) {
    if (start.current === null) return
    if ((scroller.current?.scrollTop ?? 0) > 0) {
      start.current = null
      setDistance(0)
      return
    }
    const delta = e.touches[0].clientY - start.current
    // Damped: it gets harder to pull the further you go.
    setDistance(delta <= 0 ? 0 : MAX_PULL * (1 - Math.exp(-delta / MAX_PULL)))
  }

  async function onTouchEnd() {
    if (start.current === null) return
    start.current = null
    if (distance < THRESHOLD) {
      setDistance(0)
      return
    }
    setRefreshing(true)
    setDistance(THRESHOLD)
    try {
      await onRefresh()
    } catch {
      /* the screen shows its own error state */
    } finally {
      setRefreshing(false)
      setDistance(0)
    }
  }

  const pulling = start.current !== null
  return (
    <div
      ref={scroller}
      className={cn('no-scrollbar relative overflow-y-auto overscroll-y-contain', className)}
      onTouchStart={onTouchStart}
      onTouchMove={onTouchMove}
      onTouchEnd={() => void onTouchEnd()}
    >
      <div
        aria-hidden="true"
        className="pointer-events-none absolute inset-x-0 top-0 flex justify-center"
        style={{ height: distance, opacity: Math.min(1, distance / THRESHOLD) }}
      >
        <span className="mt-auto mb-3 flex size-8 items-center justify-center rounded-full border bg-background shadow-sm">
          <RefreshCwIcon
            className={cn('size-4 text-muted-foreground', refreshing && 'animate-spin')}
            style={refreshing ? undefined : { transform: `rotate(${Math.min(360, distance * 4)}deg)` }}
          />
        </span>
      </div>
      <div
        className={cn(!pulling && 'transition-transform duration-200')}
        style={{ transform: `translateY(${distance}px)` }}
      >
        {children}
      </div>
    </div>
  )
}
