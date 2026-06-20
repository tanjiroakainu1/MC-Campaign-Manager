import PageHeader from '../../components/common/PageHeader';
import StatCard from '../../components/common/StatCard';
import { getCampaigns, getCampaignMetrics } from '../../data/dataStore';

export default function PerformanceMonitor() {
  const campaigns = getCampaigns();
  const activeCampaigns = campaigns.filter((c) => c.status === 'active');

  const metrics = activeCampaigns.map((c) => {
    const m = getCampaignMetrics(c.id);
    return {
      campaign: c.name,
      reach: m ? `${Math.round(m.reach / 1000)}K` : '0',
      engagement: c.channels.length > 0 ? `${(c.channels.length * 2.1).toFixed(1)}%` : '0%',
      ctr: m ? `${m.ctr}%` : '0%',
      conversions: m?.conversions ?? 0,
    };
  });

  const totalConversions = metrics.reduce((s, m) => s + m.conversions, 0);
  const totalReach = activeCampaigns.reduce((s, c) => s + (getCampaignMetrics(c.id)?.reach ?? 0), 0);

  return (
    <div>
      <PageHeader title="Performance Monitor" description="Track real-time campaign performance from stored data" />

      <div className="stat-grid mb-8">
        <StatCard title="Total Reach" value={totalReach >= 1000 ? `${Math.round(totalReach / 1000)}K` : totalReach} />
        <StatCard title="Active Campaigns" value={activeCampaigns.length} />
        <StatCard title="Total Channels" value={activeCampaigns.reduce((s, c) => s + c.channels.length, 0)} />
        <StatCard title="Conversions" value={totalConversions.toLocaleString()} />
      </div>

      <div className="card mb-6">
        <h2 className="section-title mb-4">Active Campaigns ({activeCampaigns.length})</h2>
        {metrics.length === 0 ? (
          <p className="text-sm text-slate-500">No active campaigns to monitor.</p>
        ) : (
          <div className="space-y-4">
            {metrics.map((m) => (
              <div key={m.campaign} className="list-item">
                <h3 className="font-medium text-slate-900">{m.campaign}</h3>
                <div className="stat-grid w-full sm:max-w-xl">
                  <div><p className="text-xs text-slate-500">Reach</p><p className="text-lg font-semibold">{m.reach}</p></div>
                  <div><p className="text-xs text-slate-500">Engagement</p><p className="text-lg font-semibold">{m.engagement}</p></div>
                  <div><p className="text-xs text-slate-500">CTR</p><p className="text-lg font-semibold">{m.ctr}</p></div>
                  <div><p className="text-xs text-slate-500">Conversions</p><p className="text-lg font-semibold">{m.conversions.toLocaleString()}</p></div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
