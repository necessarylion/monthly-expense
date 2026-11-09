import { create } from 'zustand'

/**
 * Each palette theme is a CSS class with its own colors in index.css.
 * Dark palettes also get the `dark` class, so `dark:` styles still apply.
 * Keep this in sync with the early script in index.html.
 */
const PALETTES = ['pink', 'mint', 'ocean', 'lavender', 'midnight', 'forest'] as const
const DARK_PALETTES: readonly string[] = ['midnight', 'forest']

type Palette = (typeof PALETTES)[number]
export type ThemePref = 'light' | 'dark' | 'system' | Palette

const PREFS: readonly string[] = ['light', 'dark', 'system', ...PALETTES]
const KEY = 'app:theme'
const media = window.matchMedia('(prefers-color-scheme: dark)')

function readPref(): ThemePref {
  try {
    const v = localStorage.getItem(KEY)
    if (v && PREFS.includes(v)) return v as ThemePref
  } catch {
    /* storage blocked */
  }
  return 'system'
}

function apply(pref: ThemePref) {
  const root = document.documentElement.classList
  const dark = pref === 'dark' || DARK_PALETTES.includes(pref) || (pref === 'system' && media.matches)
  root.toggle('dark', dark)
  for (const p of PALETTES) root.toggle(p, pref === p)
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
