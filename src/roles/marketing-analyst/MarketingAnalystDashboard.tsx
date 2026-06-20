import { Link } from 'react-router-dom';
import PageHeader from '../../components/common/PageHeader';
import StatCard from '../../components/common/StatCard';
import EmptyState from '../../components/common/EmptyState';
import DashboardCharts from '../../components/charts/DashboardCharts';
import { getCampaigns, computeCampaignROI } from '../../data/dataStore';
import { marketingAnalystNav } from '../../config/navigation';
import { ROLE_ACTION_ACCENT } from '../../config/roles';
import { STAT_GRADIENTS, TEXT_POSITIVE } from '../../config/theme';
import { formatCurrency } from '../../config/currency';

export default function MarketingAnalystDashboard() {
  const campaigns = getCampaigns();
  const totalSpent = campaigns.reduce((s, c) => s + c.spent, 0);
  const totalReach = campaigns.reduce((s, c) => s + Math.round(c.spent * 3.85 + c.budget * 0.12), 0);
  const avgRoi = campaigns.length > 0
    ? Math.round(campaigns.reduce((s, c) => s + computeCampaignROI(c).roi, 0) / campaigns.length)
    : 0;

  const topCampaigns = [...campaigns]
    .map((c) => ({ ...c, ...computeCampaignROI(c) }))
    .sort((a, b) => b.roi - a.roi)
    .slice(0, 3);

  return (
    <div>
      <PageHeader
        title="Marketing Analyst Dashboard"
        description="Monitor metrics and analyze campaign performance"
        action={<Link to="/marketing-analyst/dashboard" className="btn-primary">Performance Dashboard</Link>}
      />

      <div className="stat-grid">
        <StatCard title="Total Campaigns" value={campaigns.length} color={STAT_GRADIENTS.a} />
        <StatCard title="Total Reach" value={totalReach >= 1000 ? `${Math.round(totalReach / 1000)}K` : totalReach} color={STAT_GRADIENTS.b} />
        <StatCard title="Total Spent" value={formatCurrency(totalSpent)} color={STAT_GRADIENTS.c} />
        <StatCard title="Avg ROI" value={`${avgRoi}%`} color={STAT_GRADIENTS.d} />
      </div>

      <div className="mb-8">
        <h2 className="section-title mb-4">Analytics Charts</h2>
        <DashboardCharts campaigns={campaigns} variant="analyst" />
      </div>

      <div>
        <h2 className="section-title mb-4">Analytics Tools</h2>
        <div className="action-grid">
          {marketingAnalystNav.map((item) => (
            <Link key={item.id} to={item.path} className="card-hover group flex items-center gap-3 sm:gap-4">
              <div className={`flex h-11 w-11 shrink-0 items-center justify-center rounded-xl shadow-sm transition-all duration-300 group-hover:scale-110 group-hover:shadow-glow-sm sm:h-12 sm:w-12 ${ROLE_ACTION_ACCENT['marketing-analyst']}`}>
                <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                </svg>
              </div>
              <span className="font-bold text-slate-700 transition-colors group-hover:text-brand-700">{item.label}</span>
            </Link>
          ))}
        </div>
      </div>

      <div className="content-grid">
        <div className="card">
          <h2 className="section-title mb-4">Top Performing Campaigns</h2>
          {topCampaigns.length === 0 ? (
            <EmptyState message="No campaign data" />
          ) : (
            <div className="space-y-1">
              {topCampaigns.map((c) => (
                <div key={c.id} className="list-row">
                  <span className="truncate font-semibold text-slate-900">{c.name}</span>
                  <div className="text-sm">
                    <span className={`font-bold ${TEXT_POSITIVE}`}>ROI: {c.roi}%</span>
                    <span className="ml-3 text-slate-500">Spent: {formatCurrency(c.spent)}</span>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>

        <div className="card">
          <h2 className="section-title mb-4">Live Insights</h2>
          <div className="space-y-3 text-sm">
            <div className="list-item">
              <span className="text-slate-600">Best ROI campaign</span>
              <span className="font-bold text-brand-700">{topCampaigns[0]?.name ?? '—'}</span>
            </div>
            <div className="list-item">
              <span className="text-slate-600">Portfolio spend</span>
              <span className="font-bold text-brand-700">{formatCurrency(totalSpent)}</span>
            </div>
            <div className="list-item">
              <span className="text-slate-600">Average ROI</span>
              <span className="font-bold text-brand-700">{avgRoi}%</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
