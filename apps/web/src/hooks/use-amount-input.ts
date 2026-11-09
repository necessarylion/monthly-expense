import { useState } from 'react'

const MAX_INT_DIGITS = 9

export interface AmountInput {
  /** What the user typed, e.g. "1250.5". Empty = nothing typed yet. */
  amount: string
  /** When true, the next digit replaces the amount instead of adding to it. */
  replaceOnType: boolean
  /** Start from a value. `replace` = the first key press overwrites it. */
  set(value: string, replace?: boolean): void
  /** One pad key: a digit, '.', or 'back'. */
  press(key: string): void
  /** "1250.5" shows as "1,250.5"; empty shows "0". */
  display: string
  /** A smaller size for long numbers, so they still fit on one line. */
  sizeClass: string
}

function nextValue(current: string, replace: boolean, key: string): string | null {
  const value = replace && key !== 'back' ? '' : current
  if (key === 'back') return value.slice(0, -1)
  if (key === '.') return value.includes('.') ? null : `${value || '0'}.`
  const [int = '', dec] = value.split('.')
  if (dec !== undefined && dec.length >= 2) return null
  if (dec === undefined && int.length >= MAX_INT_DIGITS) return null
  return value === '0' ? key : value + key
}

/** The amount typed on the in-sheet number pad. At most 2 decimals. */
export function useAmountInput(): AmountInput {
  const [state, setState] = useState({ amount: '', replaceOnType: false })

  const [int = '', dec] = state.amount.split('.')
  const grouped = Number(int || '0').toLocaleString('en-US')
  const display = !state.amount ? '0' : dec === undefined ? grouped : `${grouped}.${dec}`
  const sizeClass = display.length > 11 ? 'text-4xl' : display.length > 8 ? 'text-5xl' : 'text-6xl'

  return {
    ...state,
    display,
    sizeClass,
    set(value, replace = false) {
      setState({ amount: value, replaceOnType: replace })
    },
    press(key) {
      setState((s) => {
        const amount = nextValue(s.amount, s.replaceOnType, key)
        // A rejected key still ends replace mode, same as the Vue version.
        return amount === null ? { ...s, replaceOnType: false } : { amount, replaceOnType: false }
      })
    },
  }
}
