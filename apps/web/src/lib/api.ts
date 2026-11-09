import { getIdToken } from './firebase'

const ACTIVE_GROUP_KEY = 'monthlyExpense.activeGroupId'

export function getActiveGroupId(): number | null {
  const raw = typeof localStorage !== 'undefined' ? localStorage.getItem(ACTIVE_GROUP_KEY) : null
  if (!raw) return null
  const n = Number(raw)
  return Number.isFinite(n) && n > 0 ? n : null
}

export function setActiveGroupId(id: number | null) {
  if (typeof localStorage === 'undefined') return
  if (id === null) localStorage.removeItem(ACTIVE_GROUP_KEY)
  else localStorage.setItem(ACTIVE_GROUP_KEY, String(id))
}

const BASE_URL: string = import.meta.env.VITE_API_URL || '/api/v1'

export interface RequestConfig {
  params?: Record<string, unknown>
}

/** Same shape callers used to read off an axios error: `e.response.status`, `e.response.data.message`. */
export class ApiError extends Error {
  response: { status: number; data: any }
  constructor(status: number, data: any) {
    super(data?.message ?? `Request failed with status code ${status}`)
    this.name = 'ApiError'
    this.response = { status, data }
  }
}

function buildUrl(path: string, params?: Record<string, unknown>): string {
  let url = BASE_URL + path
  if (!params) return url
  const qs = new URLSearchParams()
  for (const [k, v] of Object.entries(params)) {
    if (v !== undefined && v !== null) qs.append(k, String(v))
  }
  const s = qs.toString()
  return s ? `${url}${url.includes('?') ? '&' : '?'}${s}` : url
}

async function request<T>(
  method: string,
  path: string,
  body?: unknown,
  config?: RequestConfig
): Promise<{ data: T }> {
  const headers: Record<string, string> = {}

  const token = await getIdToken()
  if (token) headers.Authorization = `Bearer ${token}`

  const groupId = getActiveGroupId()
  if (groupId !== null) headers['X-Group-Id'] = String(groupId)

  if (body !== undefined) headers['Content-Type'] = 'application/json'

  const res = await fetch(buildUrl(path, config?.params), {
    method,
    headers,
    body: body === undefined ? undefined : JSON.stringify(body),
  })

  // 204 / empty bodies are common on DELETE.
  const text = await res.text()
  let data: any = null
  if (text) {
    try {
      data = JSON.parse(text)
    } catch {
      data = text
    }
  }

  if (!res.ok) {
    if (res.status === 401) window.dispatchEvent(new Event('auth:unauthorized'))
    throw new ApiError(res.status, data)
  }

  return { data: data as T }
}

export const api = {
  get: <T>(path: string, config?: RequestConfig) => request<T>('GET', path, undefined, config),
  post: <T>(path: string, body?: unknown, config?: RequestConfig) =>
    request<T>('POST', path, body ?? {}, config),
  put: <T>(path: string, body?: unknown, config?: RequestConfig) =>
    request<T>('PUT', path, body ?? {}, config),
  patch: <T>(path: string, body?: unknown, config?: RequestConfig) =>
    request<T>('PATCH', path, body ?? {}, config),
  delete: <T>(path: string, config?: RequestConfig) =>
    request<T>('DELETE', path, undefined, config),
}
