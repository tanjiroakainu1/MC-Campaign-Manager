import type { UserRole } from '../types';

export const ROLE_LABELS: Record<UserRole, string> = {
  'super-admin': 'Super Admin',
  'marketing-manager': 'Marketing Manager',
  'content-creator': 'Content Creator',
  'marketing-analyst': 'Marketing Analyst',
};

/** Roles users may self-select at registration — Super Admin is admin-assigned only. */
export const REGISTRATION_ROLES: UserRole[] = [
  'marketing-manager',
  'content-creator',
  'marketing-analyst',
];

export function getRegistrationRoleLabels(): Record<UserRole, string> {
  return Object.fromEntries(REGISTRATION_ROLES.map((role) => [role, ROLE_LABELS[role]])) as Record<UserRole, string>;
}

export function isRegistrationRole(role: string): role is UserRole {
  return REGISTRATION_ROLES.includes(role as UserRole);
}

export const ROLE_DASHBOARD_PATHS: Record<UserRole, string> = {
  'super-admin': '/super-admin',
  'marketing-manager': '/marketing-manager',
  'content-creator': '/content-creator',
  'marketing-analyst': '/marketing-analyst',
};

/* Blue Diamond — each role gets a shade within the sapphire crystal palette */
export const ROLE_COLORS: Record<UserRole, string> = {
  'super-admin': 'bg-brand-900/10 text-brand-900 border border-brand-200',
  'marketing-manager': 'bg-brand-100 text-brand-800',
  'content-creator': 'bg-diamond-100 text-diamond-800',
  'marketing-analyst': 'bg-brand-50 text-brand-700 border border-brand-200',
};

export const ROLE_QUICK_ACCESS: Record<UserRole, { button: string; icon: string; card: string; ring: string }> = {
  'super-admin': {
    button: 'btn-role btn-role-deep',
    icon: 'bg-gradient-to-br from-brand-800 to-brand-950 text-white shadow-crystal',
    card: 'border-brand-300/80 hover:border-brand-400 bg-brand-50/70',
    ring: 'ring-brand-700',
  },
  'marketing-manager': {
    button: 'btn-role btn-role-primary',
    icon: 'bg-gradient-to-br from-brand-500 to-brand-700 text-white shadow-crystal',
    card: 'border-brand-200/80 hover:border-brand-400 bg-brand-50/60',
    ring: 'ring-brand-500',
  },
  'content-creator': {
    button: 'btn-role btn-role-crystal',
    icon: 'bg-gradient-to-br from-diamond-400 to-brand-500 text-white shadow-crystal',
    card: 'border-diamond-200/80 hover:border-diamond-400 bg-diamond-50/60',
    ring: 'ring-diamond-500',
  },
  'marketing-analyst': {
    button: 'btn-role btn-role-ice',
    icon: 'bg-gradient-to-br from-diamond-300 to-diamond-500 text-brand-900 shadow-crystal',
    card: 'border-diamond-200/80 hover:border-brand-300 bg-diamond-50/50',
    ring: 'ring-diamond-400',
  },
};

export const ROLE_SIDEBAR_ACCENT: Record<UserRole, { active: string; icon: string; border: string }> = {
  'super-admin': {
    active: 'bg-gradient-to-r from-brand-800 to-brand-950 text-white shadow-md shadow-brand-900/30',
    icon: 'text-brand-800',
    border: 'border-brand-300',
  },
  'marketing-manager': {
    active: 'bg-gradient-to-r from-brand-600 to-brand-800 text-white shadow-md shadow-brand-600/25',
    icon: 'text-brand-600',
    border: 'border-brand-200',
  },
  'content-creator': {
    active: 'bg-gradient-to-r from-diamond-500 to-brand-600 text-white shadow-md shadow-diamond-500/25',
    icon: 'text-diamond-600',
    border: 'border-diamond-200',
  },
  'marketing-analyst': {
    active: 'bg-gradient-to-r from-diamond-400 to-brand-500 text-brand-950 shadow-md shadow-diamond-400/25',
    icon: 'text-diamond-600',
    border: 'border-diamond-200',
  },
};

export const ROLE_ACTION_ACCENT: Record<UserRole, string> = {
  'super-admin': 'bg-gradient-to-br from-brand-100 to-brand-200 text-brand-700',
  'marketing-manager': 'bg-gradient-to-br from-brand-100 to-brand-300 text-brand-700',
  'content-creator': 'bg-gradient-to-br from-diamond-100 to-diamond-200 text-diamond-700',
  'marketing-analyst': 'bg-gradient-to-br from-diamond-100 to-brand-200 text-brand-700',
};
