import { renderMarkdown } from '@a2ui/markdown-it'
import { A2uiSurface, MarkdownContext } from '@a2ui/react/v0_9'
import { MessageProcessor } from '@a2ui/web_core/v0_9'
import { basicCatalog } from '@a2ui/web_core/v0_9/basic_catalog'
import { useEffect, useMemo, useRef } from 'react'

type Surface = Parameters<typeof A2uiSurface>[0]['surface']
type Messages = Parameters<MessageProcessor['processMessages']>[0]
type ActionListener = NonNullable<ConstructorParameters<typeof MessageProcessor>[1]>
export type A2uiAction = Parameters<ActionListener>[0]

interface A2uiViewProps {
  /** A2UI v0.9 messages from the API. A new array draws a new screen. */
  messages: unknown[]
  /** A tapped button. Return the API's reply messages to apply them. */
  onAction?(action: A2uiAction): Promise<unknown[] | undefined>
}

/**
 * Draws A2UI v0.9 messages with `@a2ui/react`, in our theme (`.a2ui-host` in
 * `index.css`). A button tap goes to `onAction`; its reply updates the screen.
 */
export function A2uiView({ messages, onAction }: A2uiViewProps) {
  const handler = useRef(onAction)
  useEffect(() => {
    handler.current = onAction
  })

  const view = useMemo(() => {
    // A button waits for its reply; a second tap meanwhile is dropped.
    const busy = new Set<string>()
    // The ref is read on a tap, not while drawing; a new onAction must not redraw the screen.
    // oxlint-disable-next-line react/refs
    const processor = new MessageProcessor([basicCatalog], async (action) => {
      if (busy.has(action.sourceComponentId)) return
      busy.add(action.sourceComponentId)
      try {
        const reply = await handler.current?.(action)
        if (reply) processor.processMessages(reply as Messages)
      } finally {
        busy.delete(action.sourceComponentId)
      }
    })
    try {
      processor.processMessages(messages as Messages)
      // ponytail: A2uiSurface turns the basic catalog into React parts at run time; only the types differ.
      return { surfaces: Array.from(processor.model.surfacesMap.values()) as unknown as Surface[], error: null }
    } catch (e) {
      return { surfaces: [], error: e instanceof Error ? e.message : String(e) }
    }
  }, [messages])

  if (view.error) return <p className="text-sm text-destructive">{view.error}</p>
  return (
    <MarkdownContext.Provider value={renderMarkdown}>
      <div className="a2ui-host flex flex-col gap-3">
        {view.surfaces.map((surface) => (
          <A2uiSurface key={surface.id} surface={surface} />
        ))}
      </div>
    </MarkdownContext.Provider>
  )
}
