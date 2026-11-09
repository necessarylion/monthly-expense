export interface User {
  id: number
  firebaseUid: string
  email: string
  displayName: string | null
  photoUrl: string | null
}

export interface Group {
  id: number
  name: string
  currency: string
  createdByUserId: number | null
}

export interface GroupMember {
  id: number
  groupId: number
  userId: number | null
  email: string
  invitedByUserId: number | null
  joinedAt: string | null
  pending: boolean
}

export interface Category {
  id: number
  groupId: number
  name: string
  slug: string
  iconKey: string
  color: string
}

export interface Expense {
  id: number
  groupId: number
  createdByUserId: number | null
  categoryId: number | null
  amountCents: number
  occurredOn: string
  note: string | null
  category?: Category | null
}

export interface MonthlySummary {
  month: string
  totalCents: number
  count: number
  monthlyBudgetCents: number | null
  byCategory: { categoryId: number | null; totalCents: number; count: number }[]
}

/**
 * Accounts are a standalone balance ledger owned by the user (and shared with
 * anyone they invite) — no group, no categories, no month. Unrelated to the monthly expense tracking above.
 */
export interface Account {
  id: number
  userId: number
  name: string
  /** ISO 4217 code, display only — balances are never converted. */
  currency: string
  /** `#rrggbb`, same convention as categories. */
  color: string
  /** Off for accounts the user only tracks — excluded from the total balance. */
  includeInTotal: boolean
  balanceCents: number
  /** True when someone else can also use this wallet. */
  shared?: boolean
}

/** Someone a wallet is shared with. The owner row has `id: null` and cannot be removed. */
export interface AccountMember {
  id: number | null
  accountId: number
  userId: number | null
  email: string
  owner: boolean
  pending: boolean
}

export interface AccountEntry {
  id: number
  accountId: number
  /** Signed: positive is money in, negative is money out. */
  amountCents: number
  occurredOn: string
  note: string | null
}

export interface ShoppingItem {
  id: number
  groupId: number
  name: string
  done: boolean
  doneAt: string | null
  createdByUserId: number | null
  createdAt: string
}

/** An MCP client (like Claude) that signed in with OAuth. */
/** A passkey on the Me page. */
export interface Passkey {
  id: number
  /** Device name the app guessed when it was added, like `iPhone`. */
  name: string
  lastUsedAt: string | null
  createdAt: string
}

export interface McpClient {
  id: number
  /** `<client name> (<host>)`, like `Claude (claude.ai)`. */
  name: string
  lastUsedAt: string | null
  createdAt: string
}
