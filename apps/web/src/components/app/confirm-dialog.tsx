import { TriangleAlertIcon } from 'lucide-react'
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogMedia,
  AlertDialogTitle,
} from '@/components/ui/alert-dialog'
import { useT } from '@/lib/i18n'

export interface ConfirmDialogProps {
  open: boolean
  title?: string
  message?: string
  confirmLabel?: string
  danger?: boolean
  loading?: boolean
  onConfirm(): void
  onCancel(): void
}

/** The parent owns `open`; this never closes itself (so it can show a loading state). */
export function ConfirmDialog(props: ConfirmDialogProps) {
  const t = useT()
  return (
    <AlertDialog open={props.open} onOpenChange={(open) => !open && !props.loading && props.onCancel()}>
      <AlertDialogContent size="sm">
        <AlertDialogHeader>
          {props.danger && (
            <AlertDialogMedia className="bg-destructive/10 text-destructive">
              <TriangleAlertIcon />
            </AlertDialogMedia>
          )}
          <AlertDialogTitle>{props.title ?? t('common.confirm')}</AlertDialogTitle>
          <AlertDialogDescription>{props.message ?? t('confirm.cannotBeUndone')}</AlertDialogDescription>
        </AlertDialogHeader>
        <AlertDialogFooter>
          <AlertDialogCancel disabled={props.loading}>{t('common.cancel')}</AlertDialogCancel>
          <AlertDialogAction
            variant={props.danger ? 'destructive' : 'default'}
            disabled={props.loading}
            onClick={(e) => {
              e.preventDefault()
              props.onConfirm()
            }}
          >
            {props.loading ? t('common.working') : (props.confirmLabel ?? t('common.confirm'))}
          </AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  )
}
