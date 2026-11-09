import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'

/** A titled card on a Me page. */
export function Section({ title, description, children }: { title: string; description?: string; children: React.ReactNode }) {
  return (
    <Card>
      <CardHeader>
        <CardTitle>{title}</CardTitle>
        {description && <CardDescription>{description}</CardDescription>}
      </CardHeader>
      <CardContent className="flex flex-col gap-3">{children}</CardContent>
    </Card>
  )
}

export function ErrorText({ children }: { children: string | null }) {
  if (!children) return null
  return (
    <p role="alert" className="text-sm text-destructive">
      {children}
    </p>
  )
}
