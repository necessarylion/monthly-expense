import type { LucideIcon } from 'lucide-react'
import {
  Utensils,
  Car,
  Home,
  ShoppingBag,
  HeartPulse,
  Film,
  Receipt,
  Wallet,
  Coffee,
  Gift,
  Plane,
  Book,
  Dumbbell,
  Fuel,
  Shirt,
  Zap,
  Tag,
} from 'lucide-react'

/** Map the `icon_key` column on a category to a Lucide icon component. */
const ICONS: Record<string, LucideIcon> = {
  utensils: Utensils,
  car: Car,
  home: Home,
  'shopping-bag': ShoppingBag,
  'heart-pulse': HeartPulse,
  film: Film,
  receipt: Receipt,
  wallet: Wallet,
  coffee: Coffee,
  gift: Gift,
  plane: Plane,
  book: Book,
  dumbbell: Dumbbell,
  fuel: Fuel,
  shirt: Shirt,
  zap: Zap,
  tag: Tag,
}

export function iconFor(key: string): LucideIcon {
  return ICONS[key] ?? Tag
}

export const ICON_OPTIONS = [
  'utensils',
  'car',
  'home',
  'shopping-bag',
  'heart-pulse',
  'film',
  'receipt',
  'wallet',
  'coffee',
  'gift',
  'plane',
  'book',
  'dumbbell',
  'fuel',
  'shirt',
  'zap',
] as const

export const COLOR_OPTIONS = [
  '#f97316', // orange
  '#3b82f6', // blue
  '#10b981', // emerald
  '#ec4899', // pink
  '#ef4444', // red
  '#a855f7', // purple
  '#eab308', // yellow
  '#6b7280', // gray
  '#14b8a6', // teal
  '#06b6d4', // cyan
  '#6366f1', // indigo
  '#84cc16', // lime
  '#f43f5e', // rose
  '#f59e0b', // amber
  '#92400e', // brown
  '#64748b', // slate
] as const
