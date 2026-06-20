import express from 'express';
import cors from 'cors';
import { prisma } from './prisma';
import { addAuditLog, buildSyncPayload, seedDatabase, withCategoryCounts, upsertCampaignMetrics } from './db';
import { DEFAULT_SYSTEM_SETTINGS, DEFAULT_DASHBOARD_PREFERENCES, type SystemSettingsData } from './metrics';
import type { UserRole } from '../src/types';

const DEMO_ROLE_ORDER: UserRole[] = ['super-admin', 'marketing-manager', 'content-creator', 'marketing-analyst'];

const router = express.Router();

router.get('/health', async (_req, res) => {
  try {
    await prisma.$queryRaw`SELECT 1`;
    res.json({ ok: true, database: 'connected' });
  } catch {
    res.status(503).json({ ok: false, database: 'disconnected' });
  }
});

router.get('/sync', async (_req, res) => {
  try {
    await seedDatabase();
    const payload = await buildSyncPayload();
    res.json(payload);
  } catch (err) {
    console.error('Sync error:', err);
    res.status(500).json({ error: 'Failed to sync data' });
  }
});

// Auth
router.post('/auth/login', async (req, res) => {
  const { email, password } = req.body as { email?: string; password?: string };
  if (!email || !password) return res.status(400).json({ error: 'Email and password required' });

  const user = await prisma.user.findUnique({ where: { email: email.toLowerCase() } });
  if (!user || user.password !== password) {
    return res.status(401).json({ error: 'Invalid email or password' });
  }
  if (user.status !== 'active') {
    return res.status(403).json({ error: 'Account is inactive. Contact your administrator.' });
  }
  const { password: _p, ...safeUser } = user;
  res.json({ user: safeUser });
});

router.post('/auth/register', async (req, res) => {
  const { name, email, password, role } = req.body as {
    name?: string;
    email?: string;
    password?: string;
    role?: UserRole;
  };

  const trimmedName = name?.trim() ?? '';
  const trimmedEmail = email?.trim().toLowerCase() ?? '';

  if (!trimmedName) return res.status(400).json({ error: 'Name is required' });
  if (!trimmedEmail) return res.status(400).json({ error: 'Email is required' });
  if (!password || password.length < 6) return res.status(400).json({ error: 'Password must be at least 6 characters' });
  if (!role) return res.status(400).json({ error: 'Role is required' });
  if (role === 'super-admin') {
    return res.status(403).json({ error: 'Super Admin accounts cannot be created via registration. Contact your administrator.' });
  }

  const exists = await prisma.user.findUnique({ where: { email: trimmedEmail } });
  if (exists) return res.status(409).json({ error: 'An account with this email already exists' });

  const user = await prisma.user.create({
    data: {
      id: String(Date.now()),
      name: trimmedName,
      email: trimmedEmail,
      password,
      role,
      status: 'active',
      createdAt: new Date().toISOString().split('T')[0],
    },
  });
  await addAuditLog(trimmedName, 'Registered account', role);
  const { password: _p, ...safeUser } = user;
  res.status(201).json({ user: safeUser });
});

router.get('/auth/demo-accounts', async (_req, res) => {
  const users = await prisma.user.findMany({
    where: { status: 'active', role: { in: DEMO_ROLE_ORDER } },
  });
  const accounts = DEMO_ROLE_ORDER.map((role) => {
    const user = users.find((u) => u.role === role);
    if (!user) return null;
    return {
      role,
      name: user.name,
      email: user.email,
      password: user.password,
      userId: user.id,
      status: user.status,
    };
  }).filter((a) => a !== null);
  res.json({ accounts });
});

// Users
router.post('/users', async (req, res) => {
  const { user, password, actor } = req.body;
  const created = await prisma.user.create({
    data: {
      id: String(Date.now()),
      ...user,
      createdAt: new Date().toISOString().split('T')[0],
      password,
    },
  });
  await addAuditLog(actor ?? 'System', 'Created user', created.name);
  const { password: _p, ...safeUser } = created;
  res.status(201).json(safeUser);
});

router.patch('/users/:id', async (req, res) => {
  const { data, actor } = req.body;
  const existing = await prisma.user.findUnique({ where: { id: req.params.id } });
  if (!existing) return res.status(404).json({ error: 'User not found' });

  const updated = await prisma.user.update({
    where: { id: req.params.id },
    data,
  });
  await addAuditLog(actor ?? 'System', 'Updated user', updated.name);
  const { password: _p, ...safeUser } = updated;
  res.json(safeUser);
});

router.delete('/users/:id', async (req, res) => {
  const existing = await prisma.user.findUnique({ where: { id: req.params.id } });
  if (!existing) return res.status(404).json({ error: 'User not found' });
  await prisma.user.delete({ where: { id: req.params.id } });
  await addAuditLog(req.body?.actor ?? 'System', 'Deleted user', existing.name);
  res.json({ ok: true });
});

// Campaigns
router.post('/campaigns', async (req, res) => {
  const { campaign, actor } = req.body;
  const created = await prisma.campaign.create({
    data: {
      id: `c${Date.now()}`,
      ...campaign,
      channels: campaign.channels,
    },
  });
  await addAuditLog(actor ?? 'System', 'Created campaign', created.name);
  const mapped = { ...created, channels: created.channels as string[] };
  await upsertCampaignMetrics(mapped);
  res.status(201).json(mapped);
});

router.patch('/campaigns/:id', async (req, res) => {
  const { updates, actor } = req.body;
  const updated = await prisma.campaign.update({
    where: { id: req.params.id },
    data: updates,
  });
  await addAuditLog(actor ?? 'System', 'Updated campaign', updated.name);
  const mapped = { ...updated, channels: updated.channels as string[] };
  await upsertCampaignMetrics(mapped);
  res.json(mapped);
});

router.delete('/campaigns/:id', async (req, res) => {
  const existing = await prisma.campaign.findUnique({ where: { id: req.params.id } });
  if (!existing) return res.status(404).json({ error: 'Not found' });
  await prisma.campaign.delete({ where: { id: req.params.id } });
  await addAuditLog(req.body?.actor ?? 'System', 'Deleted campaign', existing.name);
  res.json({ ok: true });
});

// Content
router.post('/content', async (req, res) => {
  const { item, actor } = req.body;
  const created = await prisma.content.create({
    data: { id: `ct${Date.now()}`, ...item },
  });
  await addAuditLog(actor ?? 'System', 'Created content', created.title);
  res.status(201).json(created);
});

router.patch('/content/:id', async (req, res) => {
  const { updates, actor } = req.body;
  const updated = await prisma.content.update({
    where: { id: req.params.id },
    data: updates,
  });
  await addAuditLog(actor ?? 'System', 'Updated content', updated.title);
  res.json(updated);
});

router.delete('/content/:id', async (req, res) => {
  const existing = await prisma.content.findUnique({ where: { id: req.params.id } });
  if (!existing) return res.status(404).json({ error: 'Not found' });
  await prisma.content.delete({ where: { id: req.params.id } });
  await addAuditLog(req.body?.actor ?? 'System', 'Deleted content', existing.title);
  res.json({ ok: true });
});

// Notifications
router.patch('/notifications/:id', async (req, res) => {
  const { read } = req.body as { read?: boolean };
  const updated = await prisma.notification.update({
    where: { id: req.params.id },
    data: { read: read ?? true },
  });
  res.json(updated);
});

router.patch('/notifications/mark-all-read', async (_req, res) => {
  await prisma.notification.updateMany({ where: { read: false }, data: { read: true } });
  res.json({ ok: true });
});

// Categories
router.post('/categories', async (req, res) => {
  const { category, actor } = req.body;
  const created = await prisma.campaignCategory.create({
    data: { id: `cat${Date.now()}`, ...category },
  });
  await addAuditLog(actor ?? 'System', 'Created category', created.name);
  const campaigns = await prisma.campaign.findMany();
  const [mapped] = withCategoryCounts([{ ...created, campaignCount: 0 }], campaigns.map((c) => ({ ...c, channels: c.channels as string[] })));
  res.status(201).json(mapped);
});

router.patch('/categories/:id', async (req, res) => {
  const { updates, actor } = req.body;
  const updated = await prisma.campaignCategory.update({
    where: { id: req.params.id },
    data: updates,
  });
  await addAuditLog(actor ?? 'System', 'Updated category', updated.name);
  res.json({ ...updated, campaignCount: 0 });
});

router.delete('/categories/:id', async (req, res) => {
  const existing = await prisma.campaignCategory.findUnique({ where: { id: req.params.id } });
  if (!existing) return res.status(404).json({ error: 'Not found' });
  await prisma.campaignCategory.delete({ where: { id: req.params.id } });
  await addAuditLog(req.body?.actor ?? 'System', 'Deleted category', existing.name);
  res.json({ ok: true });
});

// Tasks
router.post('/tasks', async (req, res) => {
  const { task, actor } = req.body;
  const created = await prisma.task.create({
    data: { id: `t${Date.now()}`, ...task },
  });
  await addAuditLog(actor ?? 'System', 'Assigned task', created.title);
  res.status(201).json(created);
});

router.patch('/tasks/:id', async (req, res) => {
  const { updates } = req.body;
  const updated = await prisma.task.update({
    where: { id: req.params.id },
    data: updates,
  });
  res.json(updated);
});

router.delete('/tasks/:id', async (req, res) => {
  const existing = await prisma.task.findUnique({ where: { id: req.params.id } });
  if (!existing) return res.status(404).json({ error: 'Not found' });
  await prisma.task.delete({ where: { id: req.params.id } });
  await addAuditLog(req.body?.actor ?? 'System', 'Deleted task', existing.title);
  res.json({ ok: true });
});

// Strategies
router.post('/strategies', async (req, res) => {
  const { strategy, actor } = req.body;
  const created = await prisma.strategy.create({
    data: { id: `s${Date.now()}`, ...strategy, channels: strategy.channels },
  });
  await addAuditLog(actor ?? 'System', 'Created strategy', created.name);
  res.status(201).json({ ...created, channels: created.channels as string[] });
});

router.patch('/strategies/:id', async (req, res) => {
  const { updates } = req.body;
  const updated = await prisma.strategy.update({
    where: { id: req.params.id },
    data: updates,
  });
  res.json({ ...updated, channels: updated.channels as string[] });
});

router.delete('/strategies/:id', async (req, res) => {
  const existing = await prisma.strategy.findUnique({ where: { id: req.params.id } });
  if (!existing) return res.status(404).json({ error: 'Not found' });
  await prisma.strategy.delete({ where: { id: req.params.id } });
  await addAuditLog(req.body?.actor ?? 'System', 'Deleted strategy', existing.name);
  res.json({ ok: true });
});

// Media
router.post('/media', async (req, res) => {
  const { file, actor } = req.body;
  const created = await prisma.mediaFile.create({
    data: { id: `m${Date.now()}`, ...file },
  });
  await addAuditLog(actor ?? 'System', 'Uploaded media', created.name);
  const { fileData: _fd, ...safe } = created;
  res.status(201).json(safe);
});

router.get('/media/:id/file', async (req, res) => {
  const file = await prisma.mediaFile.findUnique({ where: { id: req.params.id } });
  if (!file) return res.status(404).json({ error: 'Not found' });
  res.json({ id: file.id, name: file.name, type: file.type, fileData: file.fileData ?? null });
});

router.delete('/media/:id', async (req, res) => {
  await prisma.mediaFile.delete({ where: { id: req.params.id } });
  res.json({ ok: true });
});

// Designs
router.post('/designs', async (req, res) => {
  const { design, actor } = req.body;
  const created = await prisma.design.create({
    data: { id: `d${Date.now()}`, ...design },
  });
  await addAuditLog(actor ?? 'System', 'Saved design', created.name);
  res.status(201).json(created);
});

router.patch('/designs/:id', async (req, res) => {
  const { updates, actor } = req.body;
  const updated = await prisma.design.update({
    where: { id: req.params.id },
    data: updates,
  });
  await addAuditLog(actor ?? 'System', 'Updated design', updated.name);
  res.json(updated);
});

router.delete('/designs/:id', async (req, res) => {
  const existing = await prisma.design.findUnique({ where: { id: req.params.id } });
  if (!existing) return res.status(404).json({ error: 'Not found' });
  await prisma.design.delete({ where: { id: req.params.id } });
  await addAuditLog(req.body?.actor ?? 'System', 'Deleted design', existing.name);
  res.json({ ok: true });
});

// System settings
router.get('/settings', async (_req, res) => {
  const row = await prisma.systemSetting.findUnique({ where: { id: 'global' } });
  res.json(row?.data ?? DEFAULT_SYSTEM_SETTINGS);
});

router.patch('/settings', async (req, res) => {
  const { settings, actor } = req.body as { settings: Partial<SystemSettingsData>; actor?: string };
  const existing = await prisma.systemSetting.findUnique({ where: { id: 'global' } });
  const merged = { ...(existing?.data as SystemSettingsData ?? DEFAULT_SYSTEM_SETTINGS), ...settings };
  const updated = await prisma.systemSetting.upsert({
    where: { id: 'global' },
    create: { id: 'global', data: merged, updatedAt: new Date().toISOString() },
    update: { data: merged, updatedAt: new Date().toISOString() },
  });
  await addAuditLog(actor ?? 'System', 'Updated system settings', 'Global settings');
  res.json(updated.data);
});

// User preferences
router.patch('/preferences/:userId', async (req, res) => {
  const { data } = req.body as { data: Record<string, unknown> };
  const existing = await prisma.userPreference.findUnique({ where: { userId: req.params.userId } });
  const merged = { ...(existing?.data as object ?? DEFAULT_DASHBOARD_PREFERENCES), ...data };
  const updated = await prisma.userPreference.upsert({
    where: { userId: req.params.userId },
    create: { userId: req.params.userId, data: merged, updatedAt: new Date().toISOString() },
    update: { data: merged, updatedAt: new Date().toISOString() },
  });
  res.json({ userId: updated.userId, data: updated.data, updatedAt: updated.updatedAt });
});

// Export / report records
router.post('/exports', async (req, res) => {
  const { record, actor } = req.body as {
    record: {
      kind: string;
      dataset?: string;
      format: string;
      dateRange?: string;
      summary: string;
      recordCount: number;
    };
    actor?: string;
  };
  const created = await prisma.exportRecord.create({
    data: {
      id: `ex${Date.now()}`,
      kind: record.kind,
      dataset: record.dataset ?? '',
      format: record.format,
      dateRange: record.dateRange ?? '',
      summary: record.summary,
      recordCount: record.recordCount,
      createdBy: actor ?? 'System',
      createdAt: new Date().toISOString(),
    },
  });
  await addAuditLog(actor ?? 'System', 'Generated export', `${record.kind}: ${record.summary}`);
  res.status(201).json(created);
});

export default router;
