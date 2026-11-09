import { useSyncExternalStore } from 'react'

/** Same width as Tailwind's `lg:`. Below it the app is the mobile design. */
const query = window.matchMedia('(min-width: 1024px)')

function subscribe(onChange: () => void) {
  query.addEventListener('change', onChange)
  return () => query.removeEventListener('change', onChange)
}

function snapshot() {
  return query.matches
}

/** For the few places CSS breakpoints can't reach (e.g. which side a drawer opens from). */
export function useIsDesktop(): boolean {
  return useSyncExternalStore(subscribe, snapshot)
}
