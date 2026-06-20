import type {
  Campaign, Content, CampaignCategory, Notification, AuditLog, User,
  SystemSettings, CampaignMetric, Task, Strategy, MediaFile, Design,
  DesignTemplate, UserPreference, ExportRecord, DashboardPreferences,
} from '../types';
import { apiFetch } from '../lib/api';

export interface AppData {
  users: User[];
  campaigns: Campaign[];
  content: Content[];
  categories: CampaignCategory[];
  notifications: Notification[];
  auditLogs: AuditLog[];
  tasks: Task[];
  strategies: Strategy[];
  media: MediaFile[];
  designs: Design[];
  settings: SystemSettings;
  metrics: CampaignMetric[];
  templates: DesignTemplate[];
  preferences: UserPreference[];
  exportRecords: ExportRecord[];
}

let cache: AppData | null = null;
const listeners = new Set<() => void>();

function notifyListeners(): void {
  listeners.forEach((fn) => fn());
}

/** Subscribe to Prisma sync updates (web + mobile stay aligned) */
export function subscribeDataStore(listener: () => void): () => void {
  listeners.add(listener);
  return () => listeners.delete(listener);
}

export function getCachedUsers(): User[] {
  return cache?.users ?? [];
}

export function setCacheUsers(users: User[]): void {
  if (cache) {
    cache.users = users;
    notifyListeners();
  }
}

export async function hydrateDataStore(): Promise<void> {
  cache = await apiFetch<AppData>('/sync');
  notifyListeners();
}

export async function reloadCache(): Promise<void> {
  cache = await apiFetch<AppData>('/sync');
  notifyListeners();
}

export function isDataReady(): boolean {
  return cache !== null;
}

function syncCategoryCounts(): void {
  if (!cache) return;
  cache.categories = cache.categories.map((cat) => ({
    ...cat,
    campaignCount: cache!.campaigns.filter((c) => c.category === cat.name).length,
  }));
}

// Campaigns
export function getCampaigns(): Campaign[] {
  return cache?.campaigns ?? [];
}

export function getCampaignById(id: string): Campaign | undefined {
  return getCampaigns().find((c) => c.id === id);
}

export async function addCampaign(campaign: Omit<Campaign, 'id'>, actor = 'System'): Promise<Campaign> {
  const created = await apiFetch<Campaign>('/campaigns', {
    method: 'POST',
    body: JSON.stringify({ campaign, actor }),
  });
  await reloadCache();
  return created;
}

export async function updateCampaign(id: string, updates: Partial<Campaign>, actor = 'System'): Promise<Campaign | null> {
  try {
    const updated = await apiFetch<Campaign>(`/campaigns/${id}`, {
      method: 'PATCH',
      body: JSON.stringify({ updates, actor }),
    });
    await reloadCache();
    return updated;
  } catch {
    return null;
  }
}

export async function deleteCampaign(id: string, actor = 'System'): Promise<boolean> {
  try {
    await apiFetch(`/campaigns/${id}`, {
      method: 'DELETE',
      body: JSON.stringify({ actor }),
    });
    await reloadCache();
    return true;
  } catch {
    return false;
  }
}

// Content
export function getContent(): Content[] {
  return cache?.content ?? [];
}

export function getContentByUser(userId: string): Content[] {
  return getContent().filter((c) => c.createdBy === userId);
}

export async function addContent(item: Omit<Content, 'id'>, actor = 'System'): Promise<Content> {
  const created = await apiFetch<Content>('/content', {
    method: 'POST',
    body: JSON.stringify({ item, actor }),
  });
  await reloadCache();
  return created;
}

export async function updateContent(id: string, updates: Partial<Content>, actor = 'System'): Promise<Content | null> {
  try {
    const updated = await apiFetch<Content>(`/content/${id}`, {
      method: 'PATCH',
      body: JSON.stringify({ updates, actor }),
    });
    await reloadCache();
    return updated;
  } catch {
    return null;
  }
}

export async function deleteContent(id: string, actor = 'System'): Promise<boolean> {
  try {
    await apiFetch(`/content/${id}`, {
      method: 'DELETE',
      body: JSON.stringify({ actor }),
    });
    await reloadCache();
    return true;
  } catch {
    return false;
  }
}

// Categories
export function getCategories(): CampaignCategory[] {
  syncCategoryCounts();
  return cache?.categories ?? [];
}

export async function addCategory(cat: Omit<CampaignCategory, 'id' | 'campaignCount'>, actor = 'System'): Promise<CampaignCategory> {
  const created = await apiFetch<CampaignCategory>('/categories', {
    method: 'POST',
    body: JSON.stringify({ category: cat, actor }),
  });
  await reloadCache();
  return created;
}

export async function updateCategory(id: string, updates: Partial<CampaignCategory>, actor = 'System'): Promise<CampaignCategory | null> {
  try {
    await apiFetch(`/categories/${id}`, {
      method: 'PATCH',
      body: JSON.stringify({ updates, actor }),
    });
    await reloadCache();
    return getCategories().find((c) => c.id === id) ?? null;
  } catch {
    return null;
  }
}

export async function deleteCategory(id: string, actor = 'System'): Promise<boolean> {
  try {
    await apiFetch(`/categories/${id}`, {
      method: 'DELETE',
      body: JSON.stringify({ actor }),
    });
    await reloadCache();
    return true;
  } catch {
    return false;
  }
}

// Tasks
export function getTasks(): Task[] {
  return cache?.tasks ?? [];
}

export async function addTask(task: Omit<Task, 'id'>, actor = 'System'): Promise<Task> {
  const created = await apiFetch<Task>('/tasks', {
    method: 'POST',
    body: JSON.stringify({ task, actor }),
  });
  await reloadCache();
  return created;
}

export async function updateTask(id: string, updates: Partial<Task>): Promise<Task | null> {
  try {
    const updated = await apiFetch<Task>(`/tasks/${id}`, {
      method: 'PATCH',
      body: JSON.stringify({ updates }),
    });
    await reloadCache();
    return updated;
  } catch {
    return null;
  }
}

export async function deleteTask(id: string, actor = 'System'): Promise<boolean> {
  try {
    await apiFetch(`/tasks/${id}`, {
      method: 'DELETE',
      body: JSON.stringify({ actor }),
    });
    await reloadCache();
    return true;
  } catch {
    return false;
  }
}

// Strategies
export function getStrategies(): Strategy[] {
  return cache?.strategies ?? [];
}

export async function addStrategy(strategy: Omit<Strategy, 'id'>, actor = 'System'): Promise<Strategy> {
  const created = await apiFetch<Strategy>('/strategies', {
    method: 'POST',
    body: JSON.stringify({ strategy, actor }),
  });
  await reloadCache();
  return created;
}

export async function updateStrategy(id: string, updates: Partial<Strategy>): Promise<Strategy | null> {
  try {
    const updated = await apiFetch<Strategy>(`/strategies/${id}`, {
      method: 'PATCH',
      body: JSON.stringify({ updates }),
    });
    await reloadCache();
    return updated;
  } catch {
    return null;
  }
}

export async function deleteStrategy(id: string, actor = 'System'): Promise<boolean> {
  try {
    await apiFetch(`/strategies/${id}`, {
      method: 'DELETE',
      body: JSON.stringify({ actor }),
    });
    await reloadCache();
    return true;
  } catch {
    return false;
  }
}

// Media
export function getMedia(): MediaFile[] {
  return cache?.media ?? [];
}

export async function addMedia(file: Omit<MediaFile, 'id'>, actor = 'System'): Promise<MediaFile> {
  const created = await apiFetch<MediaFile>('/media', {
    method: 'POST',
    body: JSON.stringify({ file, actor }),
  });
  await reloadCache();
  return created;
}

export async function deleteMedia(id: string): Promise<boolean> {
  try {
    await apiFetch(`/media/${id}`, { method: 'DELETE' });
    await reloadCache();
    return true;
  } catch {
    return false;
  }
}

// Designs
export function getDesigns(): Design[] {
  return cache?.designs ?? [];
}

export function getDesignsByUser(userId: string): Design[] {
  return getDesigns().filter((d) => d.createdBy === userId);
}

export async function addDesign(design: Omit<Design, 'id'>, actor = 'System'): Promise<Design> {
  const created = await apiFetch<Design>('/designs', {
    method: 'POST',
    body: JSON.stringify({ design, actor }),
  });
  await reloadCache();
  return created;
}

export async function updateDesign(id: string, updates: Partial<Design>, actor = 'System'): Promise<Design | null> {
  try {
    const updated = await apiFetch<Design>(`/designs/${id}`, {
      method: 'PATCH',
      body: JSON.stringify({ updates, actor }),
    });
    await reloadCache();
    return updated;
  } catch {
    return null;
  }
}

export async function deleteDesign(id: string, actor = 'System'): Promise<boolean> {
  try {
    await apiFetch(`/designs/${id}`, {
      method: 'DELETE',
      body: JSON.stringify({ actor }),
    });
    await reloadCache();
    return true;
  } catch {
    return false;
  }
}

// Notifications & Audit
export function getNotifications(): Notification[] {
  return cache?.notifications ?? [];
}

export function getAuditLogs(): AuditLog[] {
  return cache?.auditLogs ?? [];
}

export async function markNotificationRead(id: string): Promise<boolean> {
  try {
    await apiFetch(`/notifications/${id}`, {
      method: 'PATCH',
      body: JSON.stringify({ read: true }),
    });
    await reloadCache();
    return true;
  } catch {
    return false;
  }
}

export async function markAllNotificationsRead(): Promise<boolean> {
  try {
    await apiFetch('/notifications/mark-all-read', { method: 'PATCH' });
    await reloadCache();
    return true;
  } catch {
    return false;
  }
}

// System settings
export function getSettings(): SystemSettings {
  return cache?.settings ?? {
    companyName: 'Acme Marketing Corp',
    timezone: 'America/New_York',
    currency: 'PHP',
    emailNotifications: true,
    smsNotifications: false,
    autoBackup: true,
    backupFrequency: 'daily',
    sessionTimeout: '30',
    maxUploadSize: '50',
  };
}

export async function updateSettings(updates: Partial<SystemSettings>, actor = 'System'): Promise<SystemSettings> {
  const updated = await apiFetch<SystemSettings>('/settings', {
    method: 'PATCH',
    body: JSON.stringify({ settings: updates, actor }),
  });
  await reloadCache();
  return updated;
}

// Analytics — read from Prisma-backed metrics table
function getMetricByCampaignId(campaignId: string): CampaignMetric | undefined {
  return cache?.metrics.find((m) => m.campaignId === campaignId);
}

export function computeCampaignROI(campaign: Campaign): { revenue: number; roi: number } {
  const m = getMetricByCampaignId(campaign.id);
  if (m) return { revenue: m.revenue, roi: m.roi };
  return { revenue: 0, roi: 0 };
}

export function computePerformanceScore(campaignId: string): number {
  return getMetricByCampaignId(campaignId)?.performanceScore ?? 0;
}

export function getCampaignMetrics(campaignId: string) {
  const m = getMetricByCampaignId(campaignId);
  if (!m) return null;
  return {
    reach: m.reach,
    impressions: m.impressions,
    clicks: m.clicks,
    conversions: m.conversions,
    ctr: m.ctr,
    conversionRate: m.conversionRate,
    cpc: m.cpc,
    cpm: m.cpm,
  };
}

export function getAllMetrics(): CampaignMetric[] {
  return cache?.metrics ?? [];
}

// Design templates
export function getDesignTemplates(): DesignTemplate[] {
  return cache?.templates ?? [];
}

// User preferences
const DEFAULT_PREFS: DashboardPreferences = {
  dashboardWidgets: { w1: true, w2: true, w3: true, w4: true, charts: true, spend: true, content: true, pending: true },
};

export function getUserPreferences(userId: string): DashboardPreferences {
  const pref = cache?.preferences.find((p) => p.userId === userId);
  return (pref?.data as DashboardPreferences) ?? DEFAULT_PREFS;
}

export async function updateUserPreferences(userId: string, data: Partial<DashboardPreferences>): Promise<DashboardPreferences> {
  const current = getUserPreferences(userId);
  const merged = { ...current, ...data, dashboardWidgets: { ...current.dashboardWidgets, ...data.dashboardWidgets } };
  const updated = await apiFetch<UserPreference>(`/preferences/${userId}`, {
    method: 'PATCH',
    body: JSON.stringify({ data: merged }),
  });
  await reloadCache();
  return updated.data as DashboardPreferences;
}

// Export records
export function getExportRecords(): ExportRecord[] {
  return cache?.exportRecords ?? [];
}

export async function createExportRecord(
  record: Omit<ExportRecord, 'id' | 'createdAt' | 'createdBy'>,
  actor = 'System'
): Promise<ExportRecord> {
  const created = await apiFetch<ExportRecord>('/exports', {
    method: 'POST',
    body: JSON.stringify({ record, actor }),
  });
  await reloadCache();
  return created;
}

export type { Task, Strategy, MediaFile, Design, DesignTemplate, ExportRecord };
