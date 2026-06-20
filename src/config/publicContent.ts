import type { UserRole } from '../types';
import { ROLE_NAV } from './navigation';

export const ROLE_DESCRIPTIONS: Record<UserRole, string> = {
  'super-admin':
    'Oversees the entire platform — manages users, system settings, campaign categories, and generates system-wide reports.',
  'marketing-manager':
    'Plans and executes campaigns — creates plans, sets budgets, assigns tasks, approves content, and monitors performance.',
  'content-creator':
    'Produces campaign assets — creates content, uploads media, designs materials, schedules posts, and submits for approval.',
  'marketing-analyst':
    'Measures what works — tracks metrics, analyzes performance, monitors engagement, calculates ROI, and exports reports.',
};

export const GET_STARTED_STEPS = [
  {
    step: 1,
    title: 'Create Your Account',
    description: 'Register with your email and choose one of four specialized roles. Each role unlocks a tailored dashboard.',
  },
  {
    step: 2,
    title: 'Access Your Dashboard',
    description: 'Sign in to land on your role-specific dashboard with stats, quick actions, and a responsive sidebar for navigation.',
  },
  {
    step: 3,
    title: 'Collaborate on Campaigns',
    description: 'Managers plan campaigns, creators build content, analysts track results — all connected through shared campaign data.',
  },
  {
    step: 4,
    title: 'Track & Improve',
    description: 'Monitor budgets, approvals, and performance metrics in real time. Export reports and refine strategies.',
  },
];

export const CAMPAIGN_LIFECYCLE = [
  {
    phase: 'Setup',
    role: 'super-admin' as UserRole,
    title: 'System Configuration',
    description: 'Admin creates users, defines campaign categories, and configures global settings.',
  },
  {
    phase: 'Plan',
    role: 'marketing-manager' as UserRole,
    title: 'Campaign Planning',
    description: 'Manager creates campaigns, sets budgets, assigns tasks, and approves marketing strategies.',
  },
  {
    phase: 'Create',
    role: 'content-creator' as UserRole,
    title: 'Content Production',
    description: 'Creator builds content, uploads media, designs materials, and submits work for approval.',
  },
  {
    phase: 'Analyze',
    role: 'marketing-analyst' as UserRole,
    title: 'Performance Tracking',
    description: 'Analyst monitors metrics, measures ROI, generates reports, and exports data for stakeholders.',
  },
];

export const PLATFORM_FEATURES = [
  {
    title: 'Role-Based Access',
    description: 'Four dedicated dashboards with permissions tailored to each team member\'s responsibilities.',
    icon: 'shield',
  },
  {
    title: 'End-to-End Campaigns',
    description: 'From planning and budgeting through content creation to analytics — one connected workflow.',
    icon: 'flow',
  },
  {
    title: 'Live Data Persistence',
    description: 'All campaigns, content, tasks, settings, and metrics are stored in Prisma Postgres and sync across web and mobile.',
    icon: 'database',
  },
  {
    title: 'Responsive Everywhere',
    description: 'Hamburger sidebar navigation and mobile-optimized layouts work seamlessly on any device.',
    icon: 'responsive',
  },
];

export function getRoleFeatures(role: UserRole, limit = 4): string[] {
  return ROLE_NAV[role].slice(0, limit).map((item) => item.label);
}
