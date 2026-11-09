import { io, type Socket } from 'socket.io-client'
import { create } from 'zustand'
import { useAccounts } from '@/stores/accounts'
import { useExpenses } from '@/stores/expenses'
import { useGroups } from '@/stores/groups'
import { useShopping } from '@/stores/shopping'
import { getIdToken } from './firebase'

/**
 * Live updates. The API sends `changed` with `{topic, groupId?}` when data
 * changes (another member added an expense, rates moved), and we load that
 * data again. The names match `apps/api-dox/lib/constants/live.dart`.
 */
const EVENT = 'changed'

interface Change {
  topic: 'expenses' | 'shopping' | 'accounts' | 'group' | 'rates'
  groupId?: number
}

/** Waits before connecting again after the server refused us: 2s, 4s, ... 60s. */
const RETRY_MIN_MS = 2_000
const RETRY_MAX_MS = 60_000

/** Counts rate changes, so screens that fetch rates themselves fetch again. */
export const useLive = create<{ rates: number }>(() => ({ rates: 0 }))

let socket: Socket | null = null
let connectedOnce = false
let retryMs = RETRY_MIN_MS
let retryTimer: ReturnType<typeof setTimeout> | null = null

/** Connect once signed in. Safe to call again. */
export function startLive() {
  if (socket) return
  socket = io(apiOrigin(), { transports: ['websocket'], auth: sendToken })
  socket.on('connect', onConnect)
  socket.on('connect_error', onConnectError)
  socket.on(EVENT, onChanged)
}

/** Disconnect on sign-out. */
export function stopLive() {
  if (retryTimer) clearTimeout(retryTimer)
  retryTimer = null
  socket?.disconnect()
  socket = null
  connectedOnce = false
  retryMs = RETRY_MIN_MS
}

/** The API host: the page itself, or the host of `VITE_API_URL`. */
function apiOrigin(): string {
  const url: string = import.meta.env.VITE_API_URL || ''
  return url.startsWith('http') ? new URL(url).origin : window.location.origin
}

/** A fresh Firebase token on every (re)connect: the server checks it then. */
async function sendToken(done: (data: object) => void) {
  done({ token: (await getIdToken()) ?? '' })
}

/** Events sent while we were offline are lost, so a reconnect loads all. */
function onConnect() {
  retryMs = RETRY_MIN_MS
  if (connectedOnce) {
    // groups, categories and the month (expenses) of the active group
    reloadGroupSettings()
    reloadGroup('shopping')
    reloadAccounts()
    useLive.setState({ rates: useLive.getState().rates + 1 })
  }
  connectedOnce = true
}

/**
 * socket.io retries a lost connection by itself, but not one the server
 * refused (a token check that failed, or `Unavailable` while Firebase is
 * down). Without pull to refresh that would stop live updates until a page
 * reload, so try again with a growing wait. A fresh token goes with it.
 */
function onConnectError() {
  if (!socket || socket.active || retryTimer) return
  retryTimer = setTimeout(reconnect, retryMs)
  retryMs = Math.min(retryMs * 2, RETRY_MAX_MS)
}

function reconnect() {
  retryTimer = null
  socket?.connect()
}

function onChanged(change: Change) {
  if (change.topic === 'accounts') reloadAccounts()
  else if (change.topic === 'rates') useLive.setState({ rates: useLive.getState().rates + 1 })
  // A member change can add or remove a group from our list.
  else if (change.topic === 'group') reloadGroupSettings(change.groupId)
  else if (change.groupId === useGroups.getState().activeId) reloadGroup(change.topic)
}

/**
 * Categories, budget, split, trip dates or members changed. The group list
 * holds the settings; categories and the month (budget, and expenses that
 * lost their category) belong to the active group only.
 */
function reloadGroupSettings(groupId?: number) {
  void useGroups.getState().load()
  if (groupId !== undefined && groupId !== useGroups.getState().activeId) return
  const expenses = useExpenses.getState()
  void expenses.loadCategories().catch(ignore)
  void expenses.loadMonth()
}

function reloadGroup(topic: 'expenses' | 'shopping') {
  if (topic === 'expenses') {
    void useExpenses.getState().loadMonth()
    return
  }
  const shopping = useShopping.getState()
  if (shopping.loaded) void shopping.load().catch(ignore)
}

/** Only what is on screen: the list, and the open wallet's entries. */
function reloadAccounts() {
  const accounts = useAccounts.getState()
  if (!accounts.loaded) return
  void accounts.load().catch(ignore)
  if (accounts.openId !== null) void accounts.loadEntries().catch(ignore)
}

function ignore() {}
