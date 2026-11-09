/** Stacked gold bars: the symbol for GLD (Thai baht-gold) where we can draw instead of print text. */
export function GoldBar({ className }: { className?: string }) {
  return (
    <svg viewBox="0 0 24 24" className={className} aria-hidden="true">
      <path d="M7.2 9.5h9.6l1.5 4.5H5.7z" fill="#E9B84C" />
      <path d="M2.6 15.5h8l1.3 4.5H1.2z" fill="#D9A32F" />
      <path d="M13.4 15.5h8l1.4 4.5H12.1z" fill="#D9A32F" />
    </svg>
  )
}
