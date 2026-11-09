import { create } from 'zustand'

/** `pink` is a light theme with its own palette (`.pink` in index.css). */
export type ThemePref = 'light' | 'dark' | 'system' | 'pink'

const KEY = 'app:theme'
const media = window.matchMedia('(prefers-color-scheme: dark)')

function readPref(): ThemePref {
  try {
    const v = localStorage.getItem(KEY)
    if (v === 'light' || v === 'dark' || v === 'system' || v === 'pink') return v
  } catch {
    /* storage blocked */
  }
  return 'system'
}

function apply(pref: ThemePref) {
  const dark = pref === 'dark' || (pref === 'system' && media.matches)
  document.documentElement.classList.toggle('dark', dark)
  document.documentElement.classList.toggle('pink', pref === 'pink')
}

export const useTheme = create<{ pref: ThemePref }>(() => ({ pref: readPref() }))

export function setTheme(pref: ThemePref) {
  useTheme.setState({ pref })
  try {
    localStorage.setItem(KEY, pref)
  } catch {
    /* storage blocked */
  }
  apply(pref)
}

// Follow the phone setting live while on "system".
media.addEventListener('change', () => apply(useTheme.getState().pref))
apply(useTheme.getState().pref)
