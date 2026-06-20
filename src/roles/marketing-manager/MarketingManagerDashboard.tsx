import { Link } from 'react-router-dom';
import PageHeader from '../../components/common/PageHeader';
import StatCard from '../../components/common/StatCard';
import EmptyState from '../../components/common/EmptyState';
import DashboardCharts from '../../components/charts/DashboardCharts';
import { getCampaigns } from '../../data/dataStore';
import { marketingManagerNav } from '../../config/navigation';
import { useAuth } from '../../context/AuthContext';
import { STAT_GRADIENTS, STATUS_BADGES } from '../../config/theme';
import { formatCurrency } from '../../config/currency';

export default function MarketingManagerDashboard() {
  const { user } = useAuth();
  const campaigns = getCampaigns();
  const myCampaigns = user ? campaigns.filter((c) => c.managerId === user.id) : campaigns;
  const pending = myCampaigns.filter((c) => c.status === 'pending').length;
  const active = myCampaigns.filter((c) => c.status === 'active').length;
  const totalBudget = myCampaigns.reduce((sum, c) => sum + c.budget, 0);
  const totalSpent = myCampaigns.reduce((sum, c) => sum + c.spent, 0);

  const statusBadge = (status: string) => {
    if (status === 'active') return STATUS_BADGES.active;
    if (status === 'pending') return STATUS_BADGES.pending;
    return STATUS_BADGES.draft;
  };

  return (
    <div>
      <PageHeader title="Marketing Manager Dashboard" description="Plan, execute, and monitor marketing campaigns" />

      <div className="stat-grid">
        <StatCard title="My Campaigns" value={myCampaigns.length} color={STAT_GRADIENTS.a} />
        <StatCard title="Active" value={active} color={STAT_GRADIENTS.b} />
        <StatCard title="Pending Approval" value={pending} color={STAT_GRADIENTS.c} />
        <StatCard title="Budget Used" value={formatCurrency(totalSpent)} color={STAT_GRADIENTS.d} />
      </div>

      <div className="mb-8">
        <h2 className="section-title mb-4">Campaign Charts</h2>
        <DashboardCharts campaigns={myCampaigns} variant="manager" />
      </div>

      <div className="content-grid">
        <div className="card">
          <h2 className="section-title mb-4">Budget Overview</h2>
          <div className="space-y-3">
            <div className="flex justify-between text-sm">
              <span className="text-slate-500">Total Allocated</span>
              <span className="font-bold">{formatCurrency(totalBudget)}</span>
            </div>
            <div className="flex justify-between text-sm">
              <span className="text-slate-500">Total Spent</span>
              <span className="font-bold">{formatCurrency(totalSpent)}</span>
            </div>
            <div className="progress-bar">
              <div className="progress-fill" style={{ width: `${totalBudget ? (totalSpent / totalBudget) * 100 : 0}%` }} />
            </div>
            <p className="text-xs font-medium text-brand-500">{totalBudget ? Math.round((totalSpent / totalBudget) * 100) : 0}% utilized</p>
          </div>
        </div>

        <div className="card">
          <h2 className="section-title mb-4">Quick Actions</h2>
          <div className="grid gap-2">
            {marketingManagerNav.slice(0, 4).map((item) => (
              <Link key={item.id} to={item.path} className="action-link">
                <span className="flex h-8 w-8 items-center justify-center rounded-lg bg-brand-100 text-sm font-bold text-brand-600">→</span>
                {item.label}
              </Link>
            ))}
          </div>
        </div>
      </div>

      <div className="card">
        <h2 className="section-title mb-4">Recent Campaigns</h2>
        {myCampaigns.length === 0 ? (
          <EmptyState message="No campaigns yet" description="Create your first campaign to get started." />
        ) : (
          <div className="space-y-1">
            {myCampaigns.map((c) => (
              <div key={c.id} className="list-row">
                <div className="min-w-0">
                  <p className="truncate font-semibold text-slate-900">{c.name}</p>
                  <p className="truncate text-xs text-slate-500">{c.category} — {c.startDate} to {c.endDate}</p>
                </div>
                <span className={`badge w-fit capitalize ${statusBadge(c.status)}`}>{c.status}</span>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
