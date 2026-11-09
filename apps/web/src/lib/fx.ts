import { api } from './api'

/**
 * Server-computed converted total of the include-in-total accounts
 * (`GET /accounts/total`) — the backend owns the FX math so every client
 * shows the same number. Approximate by design.
 */
export interface AccountsTotal {
  currency: string
  totalCents: number
  approx: boolean
  /** 1 unit of X ≈ rates[X] units of `currency`, for account currencies ≠ `currency`. */
  rates?: Record<string, number>
  /** Ornament quote per baht-gold in `gold.currency`; present when a GLD account exists. */
  gold?: { buyOrnament: number; sellOrnament: number; currency: string } | null
}

export async function getAccountsTotal(currency: string): Promise<AccountsTotal> {
  const { data } = await api.get<{ data: AccountsTotal }>('/accounts/total', {
    params: { currency },
  })
  return data.data
}

/** Full rates table for the rates page: 1 unit of `base` = rates[X] units of X. */
export interface FxTable {
  base: string
  at: number
  rates: Record<string, number>
  /** THB ornament quote per baht-gold. */
  gold: { buyOrnament: number; sellOrnament: number } | null
}

export async function getFxTable(base: string): Promise<FxTable> {
  const { data } = await api.get<{ data: FxTable }>('/fx', { params: { base } })
  return data.data
}
