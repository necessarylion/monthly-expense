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
  topic: 'expenses' | 'shopping' | 'accounts' | 'rates'
  groupId?: number
}

/** Counts rate changes, so screens that fetch rates themselves fetch again. */
export const useLive = create<{ rates: number }>(() => ({ rates: 0 }))

let socket: Socket | null = null
let connectedOnce = false

/** Connect once signed in. Safe to call again. */
export function startLive() {
  if (socket) return
  socket = io(apiOrigin(), { transports: ['websocket'], auth: sendToken })
  socket.on('connect', onConnect)
  socket.on(EVENT, onChanged)
}

/** Disconnect on sign-out. */
export function stopLive() {
  socket?.disconnect()
  socket = null
  connectedOnce = false
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
  if (connectedOnce) {
    reloadGroup('expenses')
    reloadGroup('shopping')
    reloadAccounts()
    useLive.setState({ rates: useLive.getState().rates + 1 })
  }
  connectedOnce = true
}

function onChanged(change: Change) {
  if (change.topic === 'accounts') reloadAccounts()
  else if (change.topic === 'rates') useLive.setState({ rates: useLive.getState().rates + 1 })
  else if (change.groupId === useGroups.getState().activeId) reloadGroup(change.topic)
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
