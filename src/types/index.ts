export type UserRole =
  | 'super-admin'
  | 'marketing-manager'
  | 'content-creator'
  | 'marketing-analyst';

export interface User {
  id: string;
  name: string;
  email: string;
  role: UserRole;
  avatar?: string;
  status: 'active' | 'inactive';
  createdAt: string;
}

export interface Campaign {
  id: string;
  name: string;
  category: string;
  status: 'draft' | 'pending' | 'approved' | 'active' | 'completed' | 'rejected';
  budget: number;
  spent: number;
  startDate: string;
  endDate: string;
  channels: string[];
  managerId: string;
  description: string;
}

export interface Content {
  id: string;
  title: string;
  type: 'image' | 'video' | 'text' | 'design';
  campaignId: string;
  status: 'draft' | 'pending' | 'approved' | 'rejected';
  createdBy: string;
  scheduledDate?: string;
  fileUrl?: string;
}

export interface CampaignCategory {
  id: string;
  name: string;
  description: string;
  campaignCount: number;
}

export interface Notification {
  id: string;
  title: string;
  message: string;
  type: 'info' | 'success' | 'warning' | 'error';
  read: boolean;
  createdAt: string;
}

export interface AnalyticsMetric {
  label: string;
  value: string | number;
  change?: number;
  trend?: 'up' | 'down' | 'neutral';
}

export interface RoleNavItem {
  id: string;
  label: string;
  path: string;
  icon: string;
}

export interface AuditLog {
  id: string;
  user: string;
  action: string;
  resource: string;
  timestamp: string;
}

export interface SystemSettings {
  companyName: string;
  timezone: string;
  currency: string;
  emailNotifications: boolean;
  smsNotifications: boolean;
  autoBackup: boolean;
  backupFrequency: string;
  sessionTimeout: string;
  maxUploadSize: string;
}

export interface CampaignMetric {
  campaignId: string;
  reach: number;
  impressions: number;
  clicks: number;
  conversions: number;
  ctr: number;
  conversionRate: number;
  cpc: number;
  cpm: number;
  revenue: number;
  roi: number;
  performanceScore: number;
  updatedAt: string;
}

export interface Task {
  id: string;
  title: string;
  campaignId: string;
  assigneeId: string;
  dueDate: string;
  status: 'todo' | 'in-progress' | 'done';
}

export interface Strategy {
  id: string;
  name: string;
  description: string;
  channels: string[];
  status: 'active' | 'draft';
}

export interface MediaFile {
  id: string;
  name: string;
  type: string;
  size: string;
  uploadedAt: string;
  uploadedBy: string;
  fileData?: string;
}

export interface Design {
  id: string;
  name: string;
  template: string;
  fileName?: string;
  fileType?: string;
  savedAt: string;
  createdBy: string;
  status: 'draft' | 'saved';
}

export interface DesignTemplate {
  id: string;
  name: string;
  size: string;
  category: string;
}

export interface UserPreference {
  userId: string;
  data: DashboardPreferences;
  updatedAt: string;
}

export interface DashboardPreferences {
  dashboardWidgets: Record<string, boolean>;
}

export interface ExportRecord {
  id: string;
  kind: string;
  dataset: string;
  format: string;
  dateRange: string;
  summary: string;
  recordCount: number;
  createdBy: string;
  createdAt: string;
}
