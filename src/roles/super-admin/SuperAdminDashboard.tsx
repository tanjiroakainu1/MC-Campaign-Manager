import PageHeader from '../../components/common/PageHeader';
import StatCard from '../../components/common/StatCard';
import QuickActionCard from '../../components/common/QuickActionCard';
import { getAllUsers } from '../../data/userStore';
import { getCampaigns, getAuditLogs } from '../../data/dataStore';
import { superAdminNav } from '../../config/navigation';
import { ROLE_ACTION_ACCENT } from '../../config/roles';
import { STAT_GRADIENTS } from '../../config/theme';

export default function SuperAdminDashboard() {
  const users = getAllUsers();
  const campaigns = getCampaigns();
  const auditLogs = getAuditLogs();
  const activeCampaigns = campaigns.filter((c) => c.status === 'active').length;
  const activeUsers = users.filter((u) => u.status === 'active').length;

  return (
    <div>
      <PageHeader title="Super Admin Dashboard" description="Full system overview and administration" />

      <div className="stat-grid">
        <StatCard title="Total Users" value={users.length} color={STAT_GRADIENTS.a} />
        <StatCard title="Active Users" value={activeUsers} color={STAT_GRADIENTS.b} />
        <StatCard title="Total Campaigns" value={campaigns.length} color={STAT_GRADIENTS.c} />
        <StatCard title="Active Campaigns" value={activeCampaigns} color={STAT_GRADIENTS.d} />
      </div>

      <div>
        <h2 className="section-title mb-4">Quick Actions</h2>
        <div className="action-grid">
          {superAdminNav.map((item) => (
            <QuickActionCard key={item.id} to={item.path} label={item.label} accent={ROLE_ACTION_ACCENT['super-admin']} />
          ))}
        </div>
      </div>

      <div className="card">
        <h2 className="section-title mb-4">Recent Activity</h2>
        <div className="space-y-1">
          {auditLogs.slice(0, 8).map((log) => (
            <div key={log.id} className="list-row">
              <div className="min-w-0">
                <p className="truncate text-sm font-semibold text-slate-900">{log.action}</p>
                <p className="truncate text-xs text-slate-500">{log.user} — {log.resource}</p>
              </div>
              <span className="shrink-0 text-xs text-slate-400">{new Date(log.timestamp).toLocaleString()}</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
