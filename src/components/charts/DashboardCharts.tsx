import ChartCard from './ChartCard';
import BarChart from './BarChart';
import DonutChart from './DonutChart';
import AreaChart from './AreaChart';
import GaugeChart from './GaugeChart';
import { formatCurrency } from '../../config/currency';
import type { Campaign } from '../../types';
import {
  getCampaignSpendBars,
  getChannelSegments,
  getStatusSegments,
  getRoiBars,
  getSpendTrend,
  getReachBars,
  getBudgetUtilization,
  getAvgRoi,
} from '../../utils/chartData';

interface DashboardChartsProps {
  campaigns: Campaign[];
  variant: 'analyst' | 'performance' | 'manager';
}

export default function DashboardCharts({ campaigns, variant }: DashboardChartsProps) {
  const spendBars = getCampaignSpendBars(campaigns);
  const channels = getChannelSegments(campaigns);
  const statuses = getStatusSegments(campaigns);
  const roiBars = getRoiBars(campaigns);
  const spendTrend = getSpendTrend(campaigns);
  const reachBars = getReachBars(campaigns);
  const utilization = getBudgetUtilization(campaigns);
  const avgRoi = getAvgRoi(campaigns);

  if (variant === 'analyst') {
    return (
      <div className="chart-grid">
        <ChartCard title="Campaign Spend" subtitle="Spent vs budget per campaign" glow>
          <BarChart data={spendBars} formatValue={formatCurrency} />
        </ChartCard>
        <ChartCard title="Channel Mix" subtitle="Distribution across channels" glow>
          <DonutChart segments={channels} centerValue={String(channels.reduce((s, c) => s + c.value, 0))} centerLabel="Total" />
        </ChartCard>
        <ChartCard title="Spend Trend" subtitle="Monthly spend from campaign data" className="chart-span-2">
          <AreaChart data={spendTrend} formatValue={formatCurrency} />
        </ChartCard>
        <ChartCard title="ROI Pulse" subtitle="Return on investment by campaign">
          <BarChart data={roiBars.map((d) => ({ ...d, max: Math.max(...roiBars.map((r) => r.value), 100) }))} formatValue={(v) => `${v}%`} variant="horizontal" />
        </ChartCard>
        <ChartCard title="Budget Utilization" subtitle="Overall spend efficiency">
          <GaugeChart value={utilization} label="Budget Used" />
        </ChartCard>
      </div>
    );
  }

  if (variant === 'performance') {
    return (
      <div className="chart-grid">
        <ChartCard title="Reach Explosion" subtitle="Audience reach per campaign" glow className="chart-span-2">
          <BarChart data={reachBars.map((d) => ({ ...d, max: Math.max(...reachBars.map((r) => r.value), 1) }))} formatValue={(v) => (v >= 1000 ? `${Math.round(v / 1000)}K` : String(v))} />
        </ChartCard>
        <ChartCard title="Status Breakdown" subtitle="Campaign status distribution" glow>
          <DonutChart segments={statuses} centerValue={String(campaigns.length)} centerLabel="Campaigns" />
        </ChartCard>
        <ChartCard title="Spend Velocity" subtitle="Spending trend over time" className="chart-span-2">
          <AreaChart data={spendTrend} formatValue={formatCurrency} />
        </ChartCard>
        <ChartCard title="ROI Radar" subtitle="Performance return rates">
          <BarChart data={roiBars.map((d) => ({ ...d, max: Math.max(...roiBars.map((r) => r.value), 100) }))} formatValue={(v) => `${v}%`} variant="horizontal" />
        </ChartCard>
        <ChartCard title="Avg ROI Gauge" subtitle="Portfolio performance">
          <GaugeChart value={Math.min(avgRoi, 100)} label="Average ROI" suffix="%" />
        </ChartCard>
        <ChartCard title="Channel Dominance" subtitle="Where campaigns live">
          <DonutChart segments={channels} centerValue={String(channels.length)} centerLabel="Channels" />
        </ChartCard>
      </div>
    );
  }

  return (
    <div className="chart-grid">
      <ChartCard title="Budget Burn" subtitle="Spent per campaign" glow className="chart-span-2">
        <BarChart data={spendBars} formatValue={formatCurrency} />
      </ChartCard>
      <ChartCard title="Campaign Status" subtitle="Your portfolio breakdown" glow>
        <DonutChart segments={statuses} centerValue={String(campaigns.length)} centerLabel="Total" />
      </ChartCard>
      <ChartCard title="Spend Timeline" subtitle="Monthly spend trajectory" className="chart-span-2">
        <AreaChart data={spendTrend} formatValue={formatCurrency} />
      </ChartCard>
      <ChartCard title="Channel Allocation" subtitle="Active channel mix">
        <DonutChart segments={channels} centerValue={String(channels.reduce((s, c) => s + c.value, 0))} centerLabel="Uses" />
      </ChartCard>
      <ChartCard title="Budget Gauge" subtitle="How much budget is deployed">
        <GaugeChart value={utilization} label="Utilization" />
      </ChartCard>
    </div>
  );
}
