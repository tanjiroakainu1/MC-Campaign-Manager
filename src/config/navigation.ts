import type { UserRole } from '../types';

export const superAdminNav: { id: string; label: string; path: string }[] = [
  { id: 'users', label: 'Manage Users', path: '/super-admin/users' },
  { id: 'settings', label: 'System Settings', path: '/super-admin/settings' },
  { id: 'categories', label: 'Campaign Categories', path: '/super-admin/categories' },
  { id: 'campaigns', label: 'All Campaigns', path: '/super-admin/campaigns' },
  { id: 'reports', label: 'System Reports', path: '/super-admin/reports' },
];

export const marketingManagerNav = [
  { id: 'create', label: 'Create Campaign', path: '/marketing-manager/create' },
  { id: 'approve', label: 'Approve Plans', path: '/marketing-manager/approve' },
  { id: 'budget', label: 'Set Budgets', path: '/marketing-manager/budget' },
  { id: 'tasks', label: 'Assign Tasks', path: '/marketing-manager/tasks' },
  { id: 'monitor', label: 'Monitor Performance', path: '/marketing-manager/monitor' },
  { id: 'strategies', label: 'Strategies', path: '/marketing-manager/strategies' },
  { id: 'reports', label: 'Campaign Reports', path: '/marketing-manager/reports' },
];

export const contentCreatorNav = [
  { id: 'create', label: 'Create Content', path: '/content-creator/create' },
  { id: 'upload', label: 'Upload Media', path: '/content-creator/upload' },
  { id: 'design', label: 'Design Materials', path: '/content-creator/design' },
  { id: 'schedule', label: 'Content Schedule', path: '/content-creator/schedule' },
  { id: 'update', label: 'Update Content', path: '/content-creator/update' },
  { id: 'submit', label: 'Submit Approval', path: '/content-creator/submit' },
  { id: 'assigned', label: 'Assigned Campaigns', path: '/content-creator/assigned' },
];

export const marketingAnalystNav = [
  { id: 'metrics', label: 'Campaign Metrics', path: '/marketing-analyst/metrics' },
  { id: 'analysis', label: 'Performance Analysis', path: '/marketing-analyst/analysis' },
  { id: 'engagement', label: 'Audience Engagement', path: '/marketing-analyst/engagement' },
  { id: 'roi', label: 'ROI Tracking', path: '/marketing-analyst/roi' },
  { id: 'reports', label: 'Analytics Reports', path: '/marketing-analyst/reports' },
  { id: 'export', label: 'Export Data', path: '/marketing-analyst/export' },
  { id: 'dashboard', label: 'Performance Dashboard', path: '/marketing-analyst/dashboard' },
];

export const ROLE_NAV: Record<UserRole, { id: string; label: string; path: string }[]> = {
  'super-admin': superAdminNav,
  'marketing-manager': marketingManagerNav,
  'content-creator': contentCreatorNav,
  'marketing-analyst': marketingAnalystNav,
};
