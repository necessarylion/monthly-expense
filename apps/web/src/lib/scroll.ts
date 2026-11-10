/**
 * Center the pressed chip inside its own scrolling row.
 * Not `scrollIntoView`: that also scrolls every parent, so a drawer that is
 * still sliding in from off-screen shifts its whole content sideways.
 */
export function centerPressedChip(row: HTMLElement | null) {
  const chip = row?.querySelector<HTMLElement>('[aria-pressed="true"]')
  if (!row || !chip) return
  const rowBox = row.getBoundingClientRect()
  const chipBox = chip.getBoundingClientRect()
  row.scrollLeft += chipBox.left - rowBox.left - (rowBox.width - chipBox.width) / 2
}

/**
 * Focus a text field without iOS Safari panning the page to it. Safari pans
 * only down to reach a field; for a moment the field sits far above the top,
 * so there is nothing to pan to, and the screen stays still.
 */
export function focusWithoutPan(field: HTMLElement) {
  const { transform, opacity } = field.style
  field.style.transform = 'translateY(-200vh)'
  field.style.opacity = '0'
  field.focus({ preventScroll: true })
  requestAnimationFrame(() => {
    field.style.transform = transform
    field.style.opacity = opacity
  })
}
