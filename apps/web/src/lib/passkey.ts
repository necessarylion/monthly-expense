import { api } from './api'

/** True when this browser can use passkeys. */
export const passkeySupported = typeof window !== 'undefined' && 'PublicKeyCredential' in window

function toB64(buf: ArrayBuffer): string {
  let s = ''
  for (const b of new Uint8Array(buf)) s += String.fromCharCode(b)
  return btoa(s).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '')
}

function fromB64(s: string): ArrayBuffer {
  const bin = atob(s.replace(/-/g, '+').replace(/_/g, '/'))
  const out = new Uint8Array(bin.length)
  for (let i = 0; i < bin.length; i++) out[i] = bin.charCodeAt(i)
  return out.buffer
}

/** A short name for this device, so the user can tell passkeys apart. */
function deviceName(): string {
  const ua = navigator.userAgent
  if (/iPhone/.test(ua)) return 'iPhone'
  if (/iPad/.test(ua)) return 'iPad'
  if (/Android/.test(ua)) return 'Android'
  if (/Mac/.test(ua)) return 'Mac'
  if (/Windows/.test(ua)) return 'Windows'
  if (/Linux/.test(ua)) return 'Linux'
  return 'Passkey'
}

/** Makes a passkey on this device and saves it for the signed-in user. */
export async function addPasskey(): Promise<void> {
  const { data } = await api.post<{ data: any }>('/me/passkeys/options')
  const o = data.data
  const cred = (await navigator.credentials.create({
    publicKey: {
      ...o,
      challenge: fromB64(o.challenge),
      user: { ...o.user, id: fromB64(o.user.id) },
      excludeCredentials: o.excludeCredentials.map((c: { type: 'public-key'; id: string }) => ({
        ...c,
        id: fromB64(c.id),
      })),
    },
  })) as PublicKeyCredential | null
  if (!cred) throw new Error('Cancelled')
  const res = cred.response as AuthenticatorAttestationResponse
  const publicKey = res.getPublicKey()
  if (!publicKey) throw new Error('This passkey type is not supported')
  await api.post('/me/passkeys', {
    credentialId: cred.id,
    clientDataJson: toB64(res.clientDataJSON),
    authenticatorData: toB64(res.getAuthenticatorData()),
    publicKey: toB64(publicKey),
    publicKeyAlgorithm: res.getPublicKeyAlgorithm(),
    name: deviceName(),
  })
}

/** Asks the browser for a passkey of this site. Gives an API token. */
export async function signInWithPasskeyToken(): Promise<string> {
  const { data } = await api.post<{ data: any }>('/passkeys/login/options')
  const o = data.data
  const cred = (await navigator.credentials.get({
    publicKey: { ...o, challenge: fromB64(o.challenge) },
  })) as PublicKeyCredential | null
  if (!cred) throw new Error('Cancelled')
  const res = cred.response as AuthenticatorAssertionResponse
  const { data: out } = await api.post<{ data: { token: string } }>('/passkeys/login', {
    credentialId: cred.id,
    clientDataJson: toB64(res.clientDataJSON),
    authenticatorData: toB64(res.authenticatorData),
    signature: toB64(res.signature),
  })
  return out.data.token
}
