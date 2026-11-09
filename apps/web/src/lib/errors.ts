/** The message to show for a failed request: server message, then the error's own, then a fallback. */
export function errorMessage(e: unknown, fallback: string): string {
  const err = e as { response?: { data?: { message?: string } }; message?: string } | null
  return err?.response?.data?.message ?? err?.message ?? fallback
}

/** HTTP status of a failed API call, if there is one. */
export function errorStatus(e: unknown): number | undefined {
  return (e as { response?: { status?: number } } | null)?.response?.status
}
