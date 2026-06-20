import { useState } from 'react';
import PageHeader from '../../components/common/PageHeader';
import { getCampaigns, computePerformanceScore } from '../../data/dataStore';
import { PROGRESS_COLORS, TEXT_POSITIVE, TEXT_NEGATIVE } from '../../config/theme';

export default function PerformanceAnalysis() {
  const [period, setPeriod] = useState('30');
  const campaigns = getCampaigns();

  const analysisData = campaigns.map((c) => {
    const score = computePerformanceScore(c.id);
    const utilization = c.budget > 0 ? Math.round((c.spent / c.budget) * 100) : 0;
    return { ...c, performance: score, trend: utilization > 50 ? 'up' as const : 'down' as const, trendValue: utilization };
  });

  return (
    <div>
      <PageHeader title="Performance Analysis" description="Analyze campaign performance from stored campaign data" />

      <div className="filter-tabs mb-6">
        {['7', '30', '90'].map((p) => (
          <button key={p} onClick={() => setPeriod(p)} className={period === p ? 'filter-tab filter-tab-active' : 'filter-tab'}>
            Last {p} days
          </button>
        ))}
      </div>

      {analysisData.length === 0 ? (
        <div className="card text-sm text-slate-500">No campaigns to analyze.</div>
      ) : (
        <div className="space-y-4">
          {analysisData.map((campaign) => (
            <div key={campaign.id} className="card-hover">
              <div className="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
                <div className="min-w-0 flex-1">
                  <h3 className="truncate font-bold text-slate-900">{campaign.name}</h3>
                  <p className="text-sm text-slate-500">{campaign.category} — {campaign.channels.join(', ')}</p>
                  <div className="progress-bar mt-3">
                    <div className={`progress-fill ${campaign.performance >= 80 ? PROGRESS_COLORS.high : campaign.performance >= 60 ? PROGRESS_COLORS.medium : PROGRESS_COLORS.danger}`} style={{ width: `${campaign.performance}%` }} />
                  </div>
                  <p className="mt-1.5 text-xs font-semibold text-slate-400">Performance score: {campaign.performance}%</p>
                </div>
                <div className="shrink-0 text-left lg:text-right">
                  <p className={`text-xl font-bold ${campaign.trend === 'up' ? TEXT_POSITIVE : TEXT_NEGATIVE}`}>
                    {campaign.trend === 'up' ? '↑' : '↓'} {campaign.trendValue}%
                  </p>
                  <p className="text-xs text-slate-500">budget utilization</p>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
