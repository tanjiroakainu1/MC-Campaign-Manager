import type { Campaign } from '../src/types';

export interface CampaignMetricData {
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
}

export function computeMetricsForCampaign(campaign: Campaign): CampaignMetricData {
  const reach = Math.round(campaign.spent * 3.85 + campaign.budget * 0.12);
  const impressions = Math.round(reach * 2.7);
  const clicks = Math.round(reach * 0.1);
  const conversions = Math.round(clicks * 0.1);
  const ctr = impressions > 0 ? Number(((clicks / impressions) * 100).toFixed(1)) : 0;
  const conversionRate = clicks > 0 ? Number(((conversions / clicks) * 100).toFixed(1)) : 0;
  const cpc = clicks > 0 ? Number((campaign.spent / clicks).toFixed(2)) : 0;
  const cpm = impressions > 0 ? Number(((campaign.spent / impressions) * 1000).toFixed(2)) : 0;
  const revenue =
    campaign.spent > 0
      ? Math.round(campaign.spent * (1.8 + campaign.channels.length * 0.35))
      : 0;
  const roi =
    campaign.spent > 0 ? Math.round(((revenue - campaign.spent) / campaign.spent) * 100) : 0;
  const utilization = campaign.budget > 0 ? campaign.spent / campaign.budget : 0;
  const channelBonus = campaign.channels.length * 8;
  const statusBonus =
    campaign.status === 'active' ? 20 : campaign.status === 'approved' ? 10 : 0;
  const performanceScore = Math.min(
    100,
    Math.round(utilization * 50 + channelBonus + statusBonus)
  );

  return {
    campaignId: campaign.id,
    reach,
    impressions,
    clicks,
    conversions,
    ctr,
    conversionRate,
    cpc,
    cpm,
    revenue,
    roi,
    performanceScore,
  };
}

export const DEFAULT_SYSTEM_SETTINGS = {
  companyName: 'Acme Marketing Corp',
  timezone: 'America/New_York',
  currency: 'PHP',
  emailNotifications: true,
  smsNotifications: false,
  autoBackup: true,
  backupFrequency: 'daily',
  sessionTimeout: '30',
  maxUploadSize: '50',
} as const;

export type SystemSettingsData = typeof DEFAULT_SYSTEM_SETTINGS;

export const DEFAULT_DASHBOARD_PREFERENCES = {
  dashboardWidgets: {
    w1: true,
    w2: true,
    w3: true,
    w4: true,
    charts: true,
    spend: true,
    content: true,
    pending: true,
  },
} as const;
