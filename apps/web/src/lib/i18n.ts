import { create } from 'zustand'
import en from '@/locales/en'
import my from '@/locales/my'

export type Locale = 'en' | 'my'

export const LOCALE_OPTIONS: { code: Locale; label: string }[] = [
  { code: 'en', label: 'English' },
  { code: 'my', label: 'မြန်မာ' },
]

const STORAGE_KEY = 'app:locale'
const MESSAGES: Record<Locale, unknown> = { en, my }

function detectInitialLocale(): Locale {
  try {
    const saved = localStorage.getItem(STORAGE_KEY)
    if (saved === 'en' || saved === 'my') return saved
  } catch {
    /* localStorage might be unavailable */
  }
  return (navigator.language || '').toLowerCase().startsWith('my') ? 'my' : 'en'
}

export const useLocale = create<{ locale: Locale }>(() => ({ locale: detectInitialLocale() }))

function lookup(locale: Locale, key: string): unknown {
  let node: unknown = MESSAGES[locale]
  for (const part of key.split('.')) {
    if (node === null || typeof node !== 'object') return undefined
    node = (node as Record<string, unknown>)[part]
  }
  return node
}

export type Params = Record<string, string | number>

/** vue-i18n style: `{name}` placeholders, English fallback, the key itself when missing. */
export function t(key: string, params?: Params): string {
  const { locale } = useLocale.getState()
  const raw = lookup(locale, key) ?? lookup('en', key)
  if (typeof raw !== 'string') return key
  // `{'@'}` is vue-i18n's escape for a literal character; `{name}` is a placeholder.
  return raw.replace(/\{'([^']*)'\}|\{(\w+)\}/g, (whole, literal: string | undefined, name: string | undefined) => {
    if (literal !== undefined) return literal
    return params && name !== undefined && name in params ? String(params[name]) : whole
  })
}

/** Array/object messages, e.g. `tm('months.short')`. */
export function tm<T>(key: string): T {
  const { locale } = useLocale.getState()
  return (lookup(locale, key) ?? lookup('en', key)) as T
}

/** Components call this so they re-render when the language changes. */
export function useT(): typeof t {
  useLocale((s) => s.locale)
  return t
}

export function setLocale(locale: Locale) {
  useLocale.setState({ locale })
  try {
    localStorage.setItem(STORAGE_KEY, locale)
  } catch {
    /* ignore */
  }
  document.documentElement.setAttribute('lang', locale)
}

document.documentElement.setAttribute('lang', useLocale.getState().locale)
