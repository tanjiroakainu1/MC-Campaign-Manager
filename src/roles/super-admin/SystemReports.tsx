import { useState } from 'react';
import PageHeader from '../../components/common/PageHeader';
import Toast from '../../components/common/Toast';
import { getAllUsers } from '../../data/userStore';
import { getCampaigns, getAuditLogs, getContent, getExportRecords, createExportRecord } from '../../data/dataStore';
import { formatCurrency } from '../../config/currency';
import { useAuth } from '../../context/AuthContext';

export default function SystemReports() {
  const { user } = useAuth();
  const users = getAllUsers();
  const campaigns = getCampaigns();
  const auditLogs = getAuditLogs();
  const content = getContent();
  const reportHistory = getExportRecords().filter((r) => r.kind === 'system-report');
  const [toast, setToast] = useState('');
  const [dateRange, setDateRange] = useState('30');
  const [reportType, setReportType] = useState('overview');

  const generateReport = async () => {
    const summaryMap = {
      overview: `${users.length} users, ${campaigns.length} campaigns, ${content.length} content items`,
      users: `${users.length} users (${users.filter((u) => u.status === 'active').length} active)`,
      campaigns: `${campaigns.length} campaigns`,
      budget: `${formatCurrency(campaigns.reduce((s, c) => s + c.spent, 0))} total spent`,
      audit: `${auditLogs.length} audit log entries`,
    };
    const summary = summaryMap[reportType as keyof typeof summaryMap] ?? '';
    await createExportRecord({
      kind: 'system-report',
      dataset: reportType,
      format: 'summary',
      dateRange,
      summary: `${reportType} report (${dateRange} days): ${summary}`,
      recordCount: users.length + campaigns.length + content.length,
    }, user?.name);
    setToast(`${reportType} report generated and saved to database — ${summary}`);
  };

  return (
    <div>
      <PageHeader title="System Reports" description="Generate reports from Prisma database" />

      <div className="stat-grid mb-6">
        <div className="card text-center"><p className="text-2xl font-bold">{users.length}</p><p className="text-xs text-slate-500">Users</p></div>
        <div className="card text-center"><p className="text-2xl font-bold">{campaigns.length}</p><p className="text-xs text-slate-500">Campaigns</p></div>
        <div className="card text-center"><p className="text-2xl font-bold">{content.length}</p><p className="text-xs text-slate-500">Content</p></div>
        <div className="card text-center"><p className="text-2xl font-bold">{auditLogs.length}</p><p className="text-xs text-slate-500">Activity Logs</p></div>
      </div>

      <div className="card mb-6">
        <h2 className="section-title mb-4">Generate New Report</h2>
        <div className="form-grid-3">
          <div>
            <label className="label">Report Type</label>
            <select className="input-field" value={reportType} onChange={(e) => setReportType(e.target.value)}>
              <option value="overview">System Overview</option>
              <option value="users">User Activity</option>
              <option value="campaigns">Campaign Performance</option>
              <option value="budget">Budget Utilization</option>
              <option value="audit">Audit Logs</option>
            </select>
          </div>
          <div>
            <label className="label">Date Range (days)</label>
            <select className="input-field" value={dateRange} onChange={(e) => setDateRange(e.target.value)}>
              <option value="7">Last 7 days</option>
              <option value="30">Last 30 days</option>
              <option value="90">Last 90 days</option>
              <option value="365">Last year</option>
            </select>
          </div>
          <div className="flex items-end">
            <button onClick={generateReport} className="btn-primary w-full">Generate Report</button>
          </div>
        </div>
      </div>

      <div className="card mb-6">
        <h2 className="section-title mb-4">Recent Activity (from audit log)</h2>
        <div className="space-y-3">
          {auditLogs.slice(0, 6).map((log) => (
            <div key={log.id} className="list-item">
              <div>
                <p className="font-medium text-slate-900">{log.action}</p>
                <p className="text-xs text-slate-500">{log.user} — {log.resource}</p>
              </div>
              <span className="text-xs text-slate-400">{new Date(log.timestamp).toLocaleDateString()}</span>
            </div>
          ))}
          {auditLogs.length === 0 && <p className="text-sm text-slate-500">No activity logs yet.</p>}
        </div>
      </div>

      {reportHistory.length > 0 && (
        <div className="card">
          <h2 className="section-title mb-4">Generated Reports (database)</h2>
          {reportHistory.slice(0, 8).map((r) => (
            <div key={r.id} className="py-2 text-sm border-b border-slate-100 flex justify-between">
              <span>{r.summary}</span>
              <span className="text-slate-400">{new Date(r.createdAt).toLocaleString()}</span>
            </div>
          ))}
        </div>
      )}

      {toast && <Toast message={toast} onClose={() => setToast('')} />}
    </div>
  );
}
