import { useEffect, useRef } from 'react'

/**
 * Calls `loadMore` while the returned sentinel element is on screen. After each
 * page it looks again, so a tall screen keeps filling until the sentinel is gone.
 */
export function useLoadMore(hasMore: boolean, loadMore: () => Promise<void>) {
  const ref = useRef<HTMLDivElement>(null)
  const latest = useRef(loadMore)
  latest.current = loadMore

  useEffect(() => {
    const el = ref.current
    if (!hasMore || !el) return
    let busy = false
    const observer = new IntersectionObserver(async (entries) => {
      if (busy || !entries.some((e) => e.isIntersecting)) return
      busy = true
      try {
        await latest.current()
      } finally {
        busy = false
        // Re-observing fires the callback again if the sentinel is still visible.
        observer.unobserve(el)
        observer.observe(el)
      }
    })
    observer.observe(el)
    return () => observer.disconnect()
  }, [hasMore])

  return ref
}
