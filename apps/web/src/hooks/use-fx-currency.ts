import { create } from 'zustand'

const KEY = 'monthlyExpense.fxCurrency'

function read(): string {
  try {
    return localStorage.getItem(KEY) || 'THB'
  } catch {
    return 'THB'
  }
}

/** The currency for the accounts total and the rates base. Shared by both screens. */
export const useFxCurrency = create<{ code: string; set(code: string): void }>((set) => ({
  code: read(),
  set(code) {
    try {
      localStorage.setItem(KEY, code)
    } catch {
      /* storage blocked */
    }
    set({ code })
  },
}))
