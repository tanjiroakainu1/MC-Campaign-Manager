/** Blue Diamond Theme — centralized tokens */

export const THEME_NAME = 'Blue Diamond';

export const STAT_GRADIENTS = {
  a: 'bg-gradient-to-br from-brand-100 to-brand-200 text-brand-700',
  b: 'bg-gradient-to-br from-brand-200 to-brand-300 text-brand-800',
  c: 'bg-gradient-to-br from-diamond-100 to-diamond-200 text-diamond-700',
  d: 'bg-gradient-to-br from-brand-50 to-diamond-100 text-brand-600',
} as const;

export const STATUS_BADGES = {
  active: 'bg-brand-100 text-brand-800',
  inactive: 'bg-slate-100 text-slate-600',
  pending: 'bg-diamond-100 text-diamond-800',
  approved: 'bg-brand-200 text-brand-900',
  draft: 'bg-slate-100 text-slate-600',
  completed: 'bg-brand-100 text-brand-800',
  rejected: 'bg-red-100 text-red-800',
  success: 'bg-brand-100 text-brand-800',
  warning: 'bg-diamond-100 text-diamond-800',
  excellent: 'bg-brand-200 text-brand-900',
  good: 'bg-brand-100 text-brand-700',
  poor: 'bg-red-100 text-red-800',
} as const;

export const PROGRESS_COLORS = {
  high: 'bg-gradient-to-r from-brand-500 to-diamond-400',
  medium: 'bg-gradient-to-r from-brand-400 to-brand-500',
  low: 'bg-gradient-to-r from-diamond-400 to-brand-400',
  danger: 'bg-gradient-to-r from-red-500 to-red-600',
} as const;

export const TEXT_POSITIVE = 'text-brand-600';
export const TEXT_NEGATIVE = 'text-red-600';
