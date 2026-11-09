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
