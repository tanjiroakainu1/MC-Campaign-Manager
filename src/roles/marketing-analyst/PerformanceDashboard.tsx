import { useState, useEffect } from 'react';
import PageHeader from '../../components/common/PageHeader';
import StatCard from '../../components/common/StatCard';
import DashboardCharts from '../../components/charts/DashboardCharts';
import { getCampaigns, getContent, getUserPreferences, updateUserPreferences } from '../../data/dataStore';
import { formatCurrency } from '../../config/currency';
import { useAuth } from '../../context/AuthContext';

export default function PerformanceDashboard() {
  const { user } = useAuth();
  const campaigns = getCampaigns();
  const content = getContent();
  const activeCampaigns = campaigns.filter((c) => c.status === 'active');
  const pendingContent = content.filter((c) => c.status === 'pending').length;
  const totalSpent = campaigns.reduce((s, c) => s + c.spent, 0);

  const prefs = user ? getUserPreferences(user.id) : { dashboardWidgets: {} };
  const [widgets, setWidgets] = useState([
    { id: 'w1', title: 'Active Campaigns', value: String(activeCampaigns.length), visible: prefs.dashboardWidgets.w1 ?? true },
    { id: 'w2', title: 'Total Content', value: String(content.length), visible: prefs.dashboardWidgets.w2 ?? true },
    { id: 'w3', title: 'Pending Reviews', value: String(pendingContent), visible: prefs.dashboardWidgets.w3 ?? true },
    { id: 'w4', title: 'Total Budget', value: formatCurrency(campaigns.reduce((s, c) => s + c.budget, 0)), visible: prefs.dashboardWidgets.w4 ?? true },
  ]);
  const [editMode, setEditMode] = useState(false);

  useEffect(() => {
    if (!user) return;
    const p = getUserPreferences(user.id);
    setWidgets((w) => w.map((item) => ({ ...item, visible: p.dashboardWidgets[item.id] ?? item.visible })));
  }, [user?.id]);

  const toggleWidget = async (id: string) => {
    const next = widgets.map((w) => (w.id === id ? { ...w, visible: !w.visible } : w));
    setWidgets(next);
    if (user) {
      const dashboardWidgets = Object.fromEntries(next.map((w) => [w.id, w.visible]));
      await updateUserPreferences(user.id, { dashboardWidgets });
    }
  };

  const visibleWidgets = widgets.filter((w) => w.visible);

  return (
    <div>
      <PageHeader
        title="Performance Dashboard"
        description="Real-time charts and metrics from Prisma database"
        action={<button onClick={() => setEditMode(!editMode)} className="btn-secondary">{editMode ? 'Done Editing' : 'Customize Dashboard'}</button>}
      />

      <div className="stat-grid mb-8">
        <StatCard title="Active Campaigns" value={activeCampaigns.length} />
        <StatCard title="Total Spent" value={formatCurrency(totalSpent)} />
        <StatCard title="Content Items" value={content.length} />
        <StatCard title="Pending Reviews" value={pendingContent} />
      </div>

      <div className="mb-8">
        <h2 className="section-title mb-4">Performance Charts</h2>
        <DashboardCharts campaigns={campaigns} variant="performance" />
      </div>

      {editMode && (
        <div className="card mb-6">
          <h2 className="section-title mb-4">Widget Settings (saved to database)</h2>
          <div className="flex flex-wrap gap-2">
            {widgets.map((w) => (
              <button key={w.id} onClick={() => toggleWidget(w.id)} className={`badge cursor-pointer transition ${w.visible ? 'bg-brand-100 text-brand-800' : 'bg-slate-100 text-slate-400'}`}>
                {w.visible ? '✓' : '○'} {w.title}
              </button>
            ))}
          </div>
        </div>
      )}

      <div className="content-grid">
        {visibleWidgets.map((widget) => (
          <div key={widget.id} className="card">
            <h3 className="font-semibold text-slate-900">{widget.title}</h3>
            <p className="mt-4 text-4xl font-bold text-brand-600">{widget.value}</p>
          </div>
        ))}
      </div>
    </div>
  );
}
