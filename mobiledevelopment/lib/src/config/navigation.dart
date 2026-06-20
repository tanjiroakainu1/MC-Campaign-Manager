import '../types/index.dart';

const superAdminNav = [
  NavItem(id: 'users', label: 'Manage Users', path: '/super-admin/users'),
  NavItem(id: 'settings', label: 'System Settings', path: '/super-admin/settings'),
  NavItem(id: 'categories', label: 'Campaign Categories', path: '/super-admin/categories'),
  NavItem(id: 'campaigns', label: 'All Campaigns', path: '/super-admin/campaigns'),
  NavItem(id: 'reports', label: 'System Reports', path: '/super-admin/reports'),
];

const marketingManagerNav = [
  NavItem(id: 'create', label: 'Create Campaign', path: '/marketing-manager/create'),
  NavItem(id: 'approve', label: 'Approve Plans', path: '/marketing-manager/approve'),
  NavItem(id: 'budget', label: 'Set Budgets', path: '/marketing-manager/budget'),
  NavItem(id: 'tasks', label: 'Assign Tasks', path: '/marketing-manager/tasks'),
  NavItem(id: 'monitor', label: 'Monitor Performance', path: '/marketing-manager/monitor'),
  NavItem(id: 'strategies', label: 'Strategies', path: '/marketing-manager/strategies'),
  NavItem(id: 'reports', label: 'Campaign Reports', path: '/marketing-manager/reports'),
];

const contentCreatorNav = [
  NavItem(id: 'create', label: 'Create Content', path: '/content-creator/create'),
  NavItem(id: 'upload', label: 'Upload Media', path: '/content-creator/upload'),
  NavItem(id: 'design', label: 'Design Materials', path: '/content-creator/design'),
  NavItem(id: 'schedule', label: 'Content Schedule', path: '/content-creator/schedule'),
  NavItem(id: 'update', label: 'Update Content', path: '/content-creator/update'),
  NavItem(id: 'submit', label: 'Submit Approval', path: '/content-creator/submit'),
  NavItem(id: 'assigned', label: 'Assigned Campaigns', path: '/content-creator/assigned'),
];

const marketingAnalystNav = [
  NavItem(id: 'metrics', label: 'Campaign Metrics', path: '/marketing-analyst/metrics'),
  NavItem(id: 'analysis', label: 'Performance Analysis', path: '/marketing-analyst/analysis'),
  NavItem(id: 'engagement', label: 'Audience Engagement', path: '/marketing-analyst/engagement'),
  NavItem(id: 'roi', label: 'ROI Tracking', path: '/marketing-analyst/roi'),
  NavItem(id: 'reports', label: 'Analytics Reports', path: '/marketing-analyst/reports'),
  NavItem(id: 'export', label: 'Export Data', path: '/marketing-analyst/export'),
  NavItem(id: 'dashboard', label: 'Performance Dashboard', path: '/marketing-analyst/dashboard'),
];

const roleNav = {
  UserRoles.superAdmin: superAdminNav,
  UserRoles.marketingManager: marketingManagerNav,
  UserRoles.contentCreator: contentCreatorNav,
  UserRoles.marketingAnalyst: marketingAnalystNav,
};

List<NavItem> getNavForRole(String role) => roleNav[role] ?? [];
