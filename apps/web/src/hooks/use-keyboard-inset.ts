import { useEffect, useState } from 'react'

export interface KeyboardInset {
  open: boolean
  /** Pixels of the layout viewport hidden under the on-screen keyboard; 0 when it is closed. */
  inset: number
  /** Height of the part of the screen still visible above the keyboard. */
  height: number
  /** How far Safari panned the page up to show the focused field; 0 when it is closed. */
  offsetTop: number
}

/** Smaller changes are browser toolbars sliding in and out, not a keyboard. */
const MIN_KEYBOARD = 120

/**
 * Tracks the on-screen keyboard through `visualViewport`. iOS Safari keeps
 * fixed elements on the layout viewport, so a bottom sheet ends up under the
 * keyboard; the inset says how far to lift it.
 */
export function useKeyboardInset(): KeyboardInset {
  const [state, setState] = useState<KeyboardInset>({ open: false, inset: 0, height: 0, offsetTop: 0 })

  useEffect(() => {
    const vv = window.visualViewport
    if (!vv) return
    function update() {
      if (!vv) return
      const layout = document.documentElement.clientHeight
      // Safari may also pan the page up (offsetTop), so the gap below the visible part is smaller.
      // Pinch-zoom also shrinks the visual viewport; that is not a keyboard.
      const open = vv.scale < 1.05 && layout - vv.height > MIN_KEYBOARD
      const inset = open ? Math.max(0, Math.round(layout - vv.height - vv.offsetTop)) : 0
      const height = Math.round(vv.height)
      const offsetTop = open ? Math.max(0, Math.round(vv.offsetTop)) : 0
      setState((s) =>
        s.open === open && s.inset === inset && s.height === height && s.offsetTop === offsetTop
          ? s
          : { open, inset, height, offsetTop }
      )
    }
    update()
    vv.addEventListener('resize', update)
    vv.addEventListener('scroll', update)
    return () => {
      vv.removeEventListener('resize', update)
      vv.removeEventListener('scroll', update)
    }
  }, [])

  return state
}
