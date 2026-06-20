import '../types/index.dart';
import 'navigation.dart';
import 'roles.dart';

const roleDescriptions = {
  UserRoles.superAdmin:
      'Oversees the entire platform — manages users, system settings, campaign categories, and generates system-wide reports.',
  UserRoles.marketingManager:
      'Plans and executes campaigns — creates plans, sets budgets, assigns tasks, approves content, and monitors performance.',
  UserRoles.contentCreator:
      'Produces campaign assets — creates content, uploads media, designs materials, schedules posts, and submits for approval.',
  UserRoles.marketingAnalyst:
      'Measures what works — tracks metrics, analyzes performance, monitors engagement, calculates ROI, and exports reports.',
};

class StepItem {
  final int step;
  final String title;
  final String description;
  const StepItem({required this.step, required this.title, required this.description});
}

const getStartedSteps = [
  StepItem(step: 1, title: 'Create Your Account', description: 'Register with your email and choose one of four specialized roles. Each role unlocks a tailored dashboard.'),
  StepItem(step: 2, title: 'Access Your Dashboard', description: 'Sign in to land on your role-specific dashboard with stats, quick actions, and a responsive sidebar for navigation.'),
  StepItem(step: 3, title: 'Collaborate on Campaigns', description: 'Managers plan campaigns, creators build content, analysts track results — all connected through shared campaign data.'),
  StepItem(step: 4, title: 'Track & Improve', description: 'Monitor budgets, approvals, and performance metrics in real time. Export reports and refine strategies.'),
];

class LifecycleStage {
  final String phase;
  final String role;
  final String title;
  final String description;
  const LifecycleStage({required this.phase, required this.role, required this.title, required this.description});
}

const campaignLifecycle = [
  LifecycleStage(phase: 'Setup', role: UserRoles.superAdmin, title: 'System Configuration', description: 'Admin creates users, defines campaign categories, and configures global settings.'),
  LifecycleStage(phase: 'Plan', role: UserRoles.marketingManager, title: 'Campaign Planning', description: 'Manager creates campaigns, sets budgets, assigns tasks, and approves marketing strategies.'),
  LifecycleStage(phase: 'Create', role: UserRoles.contentCreator, title: 'Content Production', description: 'Creator builds content, uploads media, designs materials, and submits work for approval.'),
  LifecycleStage(phase: 'Analyze', role: UserRoles.marketingAnalyst, title: 'Performance Tracking', description: 'Analyst monitors metrics, measures ROI, generates reports, and exports data for stakeholders.'),
];

class PlatformFeature {
  final String title;
  final String description;
  final String icon;
  const PlatformFeature({required this.title, required this.description, required this.icon});
}

const platformFeatures = [
  PlatformFeature(title: 'Role-Based Access', description: "Four dedicated dashboards with permissions tailored to each team member's responsibilities.", icon: 'shield'),
  PlatformFeature(title: 'End-to-End Campaigns', description: 'From planning and budgeting through content creation to analytics — one connected workflow.', icon: 'flow'),
  PlatformFeature(title: 'Live Data Persistence', description: 'All campaigns, content, tasks, settings, and metrics are stored in Prisma Postgres and sync across web and mobile.', icon: 'database'),
  PlatformFeature(title: 'Responsive Everywhere', description: 'Hamburger sidebar navigation and mobile-optimized layouts work seamlessly on any device.', icon: 'responsive'),
];

List<String> getRoleFeatures(String role, [int limit = 4]) =>
    getNavForRole(role).take(limit).map((item) => item.label).toList();
