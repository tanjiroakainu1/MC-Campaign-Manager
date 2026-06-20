import type {
  Campaign,
  Content,
  CampaignCategory,
  Notification,
  AuditLog,
  UserRole,
  Task,
  Strategy,
  MediaFile,
  Design,
  DesignTemplate,
} from '../types';

export const SEED_PASSWORDS: Record<string, string> = {
  'alex@company.com': 'admin123',
  'sarah@company.com': 'manager123',
  'mike@company.com': 'creator123',
  'emma@company.com': 'analyst123',
};

export const SEED_CAMPAIGNS: Campaign[] = [
  {
    id: 'c1',
    name: 'Summer Sale 2025',
    category: 'Seasonal',
    status: 'active',
    budget: 50000,
    spent: 32500,
    startDate: '2025-06-01',
    endDate: '2025-08-31',
    channels: ['social', 'email', 'ads'],
    managerId: '2',
    description: 'Annual summer promotional campaign across all channels.',
  },
  {
    id: 'c2',
    name: 'Product Launch - Pro X',
    category: 'Product Launch',
    status: 'pending',
    budget: 75000,
    spent: 0,
    startDate: '2025-07-01',
    endDate: '2025-09-30',
    channels: ['social', 'email', 'sms', 'ads'],
    managerId: '2',
    description: 'Launch campaign for the new Pro X product line.',
  },
  {
    id: 'c3',
    name: 'Brand Awareness Q2',
    category: 'Brand',
    status: 'approved',
    budget: 30000,
    spent: 12000,
    startDate: '2025-04-01',
    endDate: '2025-06-30',
    channels: ['social', 'ads'],
    managerId: '2',
    description: 'Increase brand visibility in target markets.',
  },
  {
    id: 'c4',
    name: 'Holiday Special',
    category: 'Seasonal',
    status: 'draft',
    budget: 40000,
    spent: 0,
    startDate: '2025-11-01',
    endDate: '2025-12-31',
    channels: ['email', 'sms'],
    managerId: '2',
    description: 'End-of-year holiday promotional campaign.',
  },
];

export const SEED_CONTENT: Content[] = [
  { id: 'ct1', title: 'Summer Banner Ad', type: 'image', campaignId: 'c1', status: 'approved', createdBy: '3', scheduledDate: '2025-06-05', fileUrl: '/media/summer-banner.jpg' },
  { id: 'ct2', title: 'Product Launch Video', type: 'video', campaignId: 'c2', status: 'pending', createdBy: '3', scheduledDate: '2025-07-01' },
  { id: 'ct3', title: 'Email Newsletter Template', type: 'design', campaignId: 'c1', status: 'approved', createdBy: '3', scheduledDate: '2025-06-10' },
  { id: 'ct4', title: 'Social Media Copy Set', type: 'text', campaignId: 'c3', status: 'draft', createdBy: '3' },
  { id: 'ct5', title: 'Holiday Promo Graphics', type: 'image', campaignId: 'c4', status: 'draft', createdBy: '5' },
];

export const SEED_CATEGORIES: CampaignCategory[] = [
  { id: 'cat1', name: 'Seasonal', description: 'Holiday and seasonal promotions', campaignCount: 2 },
  { id: 'cat2', name: 'Product Launch', description: 'New product introduction campaigns', campaignCount: 1 },
  { id: 'cat3', name: 'Brand', description: 'Brand awareness and positioning', campaignCount: 1 },
  { id: 'cat4', name: 'Retention', description: 'Customer retention and loyalty', campaignCount: 0 },
  { id: 'cat5', name: 'Acquisition', description: 'New customer acquisition', campaignCount: 0 },
];

export const SEED_NOTIFICATIONS: Notification[] = [
  { id: 'n1', title: 'Campaign Approved', message: 'Brand Awareness Q2 has been approved.', type: 'success', read: false, createdAt: '2025-06-18T10:00:00' },
  { id: 'n2', title: 'Content Review', message: 'Product Launch Video needs your review.', type: 'warning', read: false, createdAt: '2025-06-19T14:30:00' },
  { id: 'n3', title: 'Budget Alert', message: 'Summer Sale campaign is at 65% budget utilization.', type: 'info', read: true, createdAt: '2025-06-17T09:00:00' },
  { id: 'n4', title: 'Performance Update', message: 'Q2 metrics report is ready for review.', type: 'info', read: false, createdAt: '2025-06-19T16:00:00' },
];

export const SEED_AUDIT_LOGS: AuditLog[] = [
  { id: 'a1', user: 'Alex Rivera', action: 'Updated system settings', resource: 'Settings', timestamp: '2025-06-19T08:00:00' },
  { id: 'a2', user: 'Sarah Chen', action: 'Created campaign', resource: 'Holiday Special', timestamp: '2025-06-18T15:30:00' },
  { id: 'a3', user: 'Mike Johnson', action: 'Uploaded content', resource: 'Product Launch Video', timestamp: '2025-06-19T11:00:00' },
  { id: 'a4', user: 'Emma Wilson', action: 'Exported report', resource: 'Q2 Analytics', timestamp: '2025-06-19T16:30:00' },
];

export const SEED_TASKS: Task[] = [
  { id: 't1', title: 'Create social media graphics', campaignId: 'c1', assigneeId: '3', dueDate: '2025-06-25', status: 'in-progress' },
  { id: 't2', title: 'Write email copy', campaignId: 'c2', assigneeId: '3', dueDate: '2025-07-05', status: 'todo' },
  { id: 't3', title: 'Design banner ads', campaignId: 'c1', assigneeId: '5', dueDate: '2025-06-28', status: 'todo' },
];

export const SEED_STRATEGIES: Strategy[] = [
  { id: 's1', name: 'Omnichannel Launch', description: 'Coordinated launch across social, email, and paid ads', channels: ['social', 'email', 'ads'], status: 'active' },
  { id: 's2', name: 'Content-First Growth', description: 'Focus on organic content before paid amplification', channels: ['social'], status: 'active' },
  { id: 's3', name: 'Retention Email Series', description: 'Automated email sequences for customer retention', channels: ['email', 'sms'], status: 'draft' },
];

export const SEED_MEDIA: MediaFile[] = [
  { id: 'm1', name: 'summer-banner.jpg', type: 'image/jpeg', size: '2.4 MB', uploadedAt: '2025-06-15', uploadedBy: '3' },
  { id: 'm2', name: 'product-launch.mp4', type: 'video/mp4', size: '45.2 MB', uploadedAt: '2025-06-18', uploadedBy: '3' },
  { id: 'm3', name: 'newsletter-template.png', type: 'image/png', size: '1.8 MB', uploadedAt: '2025-06-10', uploadedBy: '3' },
];

export const SEED_DESIGNS: Design[] = [];

export const SEED_DESIGN_TEMPLATES: DesignTemplate[] = [
  { id: 'dt1', name: 'Social Media Post', size: '1080x1080', category: 'Social' },
  { id: 'dt2', name: 'Email Banner', size: '600x200', category: 'Email' },
  { id: 'dt3', name: 'Story Template', size: '1080x1920', category: 'Social' },
  { id: 'dt4', name: 'Flyer A4', size: '2480x3508', category: 'Print' },
  { id: 'dt5', name: 'Ad Banner', size: '728x90', category: 'Ads' },
  { id: 'dt6', name: 'Product Card', size: '400x500', category: 'E-commerce' },
];

export const ROLE_ORDER: UserRole[] = [
  'super-admin',
  'marketing-manager',
  'content-creator',
  'marketing-analyst',
];
