import type { CampaignCategory } from '../src/types';
import {
  SEED_CAMPAIGNS,
  SEED_CONTENT,
  SEED_CATEGORIES,
  SEED_NOTIFICATIONS,
  SEED_AUDIT_LOGS,
  SEED_TASKS,
  SEED_STRATEGIES,
  SEED_MEDIA,
  SEED_DESIGNS,
  SEED_DESIGN_TEMPLATES,
  SEED_PASSWORDS,
} from '../src/data/seedData';
import { prisma } from './prisma';
import {
  computeMetricsForCampaign,
  DEFAULT_SYSTEM_SETTINGS,
  type CampaignLike,
  type SystemSettingsData,
} from './metrics';

const SEED_USERS = [
  { id: '1', name: 'Alex Rivera', email: 'alex@company.com', role: 'super-admin', status: 'active', createdAt: '2024-01-15' },
  { id: '2', name: 'Sarah Chen', email: 'sarah@company.com', role: 'marketing-manager', status: 'active', createdAt: '2024-02-20' },
  { id: '3', name: 'Mike Johnson', email: 'mike@company.com', role: 'content-creator', status: 'active', createdAt: '2024-03-10' },
  { id: '4', name: 'Emma Wilson', email: 'emma@company.com', role: 'marketing-analyst', status: 'active', createdAt: '2024-03-15' },
  { id: '5', name: 'John Doe', email: 'john@company.com', role: 'content-creator', status: 'inactive', createdAt: '2024-04-01' },
];

export function withCategoryCounts(
  categories: CampaignCategory[],
  campaigns: Array<{ category: string }>
): CampaignCategory[] {
  return categories.map((cat) => ({
    ...cat,
    campaignCount: campaigns.filter((c) => c.category === cat.name).length,
  }));
}

export async function ensureSystemSettings(): Promise<SystemSettingsData> {
  const existing = await prisma.systemSetting.findUnique({ where: { id: 'global' } });
  if (existing) return existing.data as SystemSettingsData;

  const created = await prisma.systemSetting.create({
    data: {
      id: 'global',
      data: DEFAULT_SYSTEM_SETTINGS,
      updatedAt: new Date().toISOString(),
    },
  });
  return created.data as SystemSettingsData;
}

export async function upsertCampaignMetrics(campaign: CampaignLike) {
  const m = computeMetricsForCampaign(campaign);
  const updatedAt = new Date().toISOString();
  await prisma.campaignMetric.upsert({
    where: { campaignId: campaign.id },
    create: { ...m, updatedAt },
    update: { ...m, updatedAt },
  });
}

export async function ensureDesignTemplates() {
  const count = await prisma.designTemplate.count();
  if (count > 0) return;
  for (const t of SEED_DESIGN_TEMPLATES) {
    await prisma.designTemplate.create({ data: t });
  }
}

export async function ensureCampaignMetrics() {
  const campaigns = await prisma.campaign.findMany();
  for (const c of campaigns) {
    const mapped: CampaignLike = {
      id: c.id,
      spent: c.spent,
      budget: c.budget,
      channels: c.channels as string[],
      status: c.status,
    };
    const exists = await prisma.campaignMetric.findUnique({ where: { campaignId: c.id } });
    if (!exists) await upsertCampaignMetrics(mapped);
  }
}

export async function ensureDatabaseDefaults() {
  await ensureSystemSettings();
  await ensureDesignTemplates();
  await ensureCampaignMetrics();
}

export async function buildSyncPayload() {
  await ensureDatabaseDefaults();

  const [users, campaigns, content, categories, notifications, auditLogs, tasks, strategies, media, designs, settingsRow, metrics, templates, preferences, exportRecords] =
    await Promise.all([
      prisma.user.findMany({ orderBy: { createdAt: 'asc' } }),
      prisma.campaign.findMany(),
      prisma.content.findMany(),
      prisma.campaignCategory.findMany(),
      prisma.notification.findMany({ orderBy: { createdAt: 'desc' } }),
      prisma.auditLog.findMany({ orderBy: { timestamp: 'desc' }, take: 50 }),
      prisma.task.findMany(),
      prisma.strategy.findMany(),
      prisma.mediaFile.findMany({ orderBy: { uploadedAt: 'desc' } }),
      prisma.design.findMany({ orderBy: { savedAt: 'desc' } }),
      prisma.systemSetting.findUnique({ where: { id: 'global' } }),
      prisma.campaignMetric.findMany(),
      prisma.designTemplate.findMany({ orderBy: { name: 'asc' } }),
      prisma.userPreference.findMany(),
      prisma.exportRecord.findMany({ orderBy: { createdAt: 'desc' }, take: 100 }),
    ]);

  const safeUsers = users.map(({ password: _p, ...u }) => u);
  const mappedCampaigns = campaigns.map((c) => ({
    ...c,
    channels: c.channels as string[],
  }));
  const mappedCategories = withCategoryCounts(
    categories.map((c) => ({ ...c, campaignCount: 0 })),
    mappedCampaigns
  );

  return {
    users: safeUsers,
    campaigns: mappedCampaigns,
    content,
    categories: mappedCategories,
    notifications,
    auditLogs,
    tasks,
    strategies: strategies.map((s) => ({ ...s, channels: s.channels as string[] })),
    media: media.map(({ fileData: _fd, ...m }) => m),
    designs,
    settings: (settingsRow?.data ?? DEFAULT_SYSTEM_SETTINGS) as SystemSettingsData,
    metrics,
    templates,
    preferences: preferences.map((p) => ({ userId: p.userId, data: p.data, updatedAt: p.updatedAt })),
    exportRecords,
  };
}

export async function addAuditLog(user: string, action: string, resource: string) {
  const log = await prisma.auditLog.create({
    data: {
      id: `a${Date.now()}`,
      user,
      action,
      resource,
      timestamp: new Date().toISOString(),
    },
  });
  const count = await prisma.auditLog.count();
  if (count > 50) {
    const oldest = await prisma.auditLog.findMany({ orderBy: { timestamp: 'asc' }, take: count - 50 });
    await prisma.auditLog.deleteMany({ where: { id: { in: oldest.map((o) => o.id) } } });
  }
  return log;
}

export async function seedDatabase() {
  const userCount = await prisma.user.count();
  if (userCount > 0) return false;

  for (const user of SEED_USERS) {
    await prisma.user.create({
      data: {
        ...user,
        password: SEED_PASSWORDS[user.email] ?? 'password123',
      },
    });
  }

  for (const cat of SEED_CATEGORIES) {
    await prisma.campaignCategory.create({
      data: { id: cat.id, name: cat.name, description: cat.description },
    });
  }

  for (const campaign of SEED_CAMPAIGNS) {
    await prisma.campaign.create({
      data: { ...campaign, channels: campaign.channels },
    });
  }

  for (const item of SEED_CONTENT) {
    await prisma.content.create({ data: item });
  }

  for (const n of SEED_NOTIFICATIONS) {
    await prisma.notification.create({ data: n });
  }

  for (const log of SEED_AUDIT_LOGS) {
    await prisma.auditLog.create({ data: log });
  }

  for (const task of SEED_TASKS) {
    await prisma.task.create({ data: task });
  }

  for (const strategy of SEED_STRATEGIES) {
    await prisma.strategy.create({
      data: { ...strategy, channels: strategy.channels },
    });
  }

  for (const file of SEED_MEDIA) {
    await prisma.mediaFile.create({ data: file });
  }

  for (const design of SEED_DESIGNS) {
    await prisma.design.create({ data: design });
  }

  for (const t of SEED_DESIGN_TEMPLATES) {
    await prisma.designTemplate.create({ data: t });
  }

  await ensureDatabaseDefaults();
  return true;
}
