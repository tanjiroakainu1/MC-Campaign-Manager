import { getCampaigns, computeCampaignROI, getCampaignMetrics } from '../data/dataStore';
import type { Campaign } from '../types';

export interface ChartPoint {
  label: string;
  value: number;
}

export interface ChartSegment {
  label: string;
  value: number;
  color: string;
}

export const CHART_COLORS = ['#2b8fff', '#38c8ff', '#1470eb', '#7ddcff', '#0cb0f5', '#1048a3', '#0d58c7', '#0090d4'];

export function getCampaignSpendBars(campaigns: Campaign[]): { label: string; value: number; max: number }[] {
  return campaigns.map((c) => ({
    label: c.name.length > 14 ? `${c.name.slice(0, 14)}…` : c.name,
    value: c.spent,
    max: c.budget || c.spent || 1,
  }));
}

export function getChannelSegments(campaigns: Campaign[]): ChartSegment[] {
  const map: Record<string, number> = {};
  campaigns.forEach((c) => {
    c.channels.forEach((ch) => { map[ch] = (map[ch] ?? 0) + 1; });
  });
  return Object.entries(map).map(([label, value], i) => ({
    label,
    value,
    color: CHART_COLORS[i % CHART_COLORS.length],
  }));
}

export function getStatusSegments(campaigns: Campaign[]): ChartSegment[] {
  const map: Record<string, number> = {};
  campaigns.forEach((c) => { map[c.status] = (map[c.status] ?? 0) + 1; });
  return Object.entries(map).map(([label, value], i) => ({
    label,
    value,
    color: CHART_COLORS[i % CHART_COLORS.length],
  }));
}

export function getRoiBars(campaigns: Campaign[]): ChartPoint[] {
  return campaigns.map((c) => ({
    label: c.name.length > 10 ? `${c.name.slice(0, 10)}…` : c.name,
    value: computeCampaignROI(c).roi,
  }));
}

export function getSpendTrend(campaigns: Campaign[]): ChartPoint[] {
  const map: Record<string, number> = {};
  campaigns.forEach((c) => {
    const month = new Date(c.startDate).toLocaleString('en-PH', { month: 'short' });
    map[month] = (map[month] ?? 0) + c.spent;
  });
  const entries = Object.entries(map);
  if (entries.length === 0) {
    return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'].map((label, i) => ({
      label,
      value: Math.round(campaigns.reduce((s, c) => s + c.spent, 0) * (0.08 + i * 0.04)),
    }));
  }
  return entries.map(([label, value]) => ({ label, value }));
}

export function getReachBars(campaigns: Campaign[]): ChartPoint[] {
  return campaigns.map((c) => {
    const m = getCampaignMetrics(c.id);
    return {
      label: c.name.length > 10 ? `${c.name.slice(0, 10)}…` : c.name,
      value: m?.reach ?? 0,
    };
  });
}

export function getBudgetUtilization(campaigns: Campaign[]): number {
  const budget = campaigns.reduce((s, c) => s + c.budget, 0);
  const spent = campaigns.reduce((s, c) => s + c.spent, 0);
  return budget > 0 ? Math.round((spent / budget) * 100) : 0;
}

export function getAvgRoi(campaigns: Campaign[]): number {
  if (campaigns.length === 0) return 0;
  return Math.round(campaigns.reduce((s, c) => s + computeCampaignROI(c).roi, 0) / campaigns.length);
}

export function getAllCampaigns() {
  return getCampaigns();
}
