import { useState } from 'react';
import PageHeader from '../../components/common/PageHeader';
import Toast from '../../components/common/Toast';
import { getCampaigns, getContent, getAuditLogs, getExportRecords, createExportRecord } from '../../data/dataStore';
import { useAuth } from '../../context/AuthContext';

export default function AnalyticsReports() {
  const { user } = useAuth();
  const campaigns = getCampaigns();
  const content = getContent();
  const auditLogs = getAuditLogs();
  const reportHistory = getExportRecords().filter((r) => r.kind === 'analytics-report');
  const [toast, setToast] = useState('');
  const [reportConfig, setReportConfig] = useState({ type: 'performance', format: 'pdf', dateRange: '30', includeCharts: true });

  const generateReport = async () => {
    const summary = `${reportConfig.type} report — ${campaigns.length} campaigns, ${content.length} content items`;
    await createExportRecord({
      kind: 'analytics-report',
      dataset: reportConfig.type,
      format: reportConfig.format,
      dateRange: reportConfig.dateRange,
      summary,
      recordCount: campaigns.length + content.length,
    }, user?.name);
    setToast(`${reportConfig.type} report generated and saved to database`);
  };

  return (
    <div>
      <PageHeader title="Analytics Reports" description="Generate reports — stored in Prisma Postgres" />

      <div className="card mb-6">
        <h2 className="section-title mb-4">Configure Report</h2>
        <div className="stat-grid">
          <div>
            <label className="label">Report Type</label>
            <select className="input-field" value={reportConfig.type} onChange={(e) => setReportConfig({ ...reportConfig, type: e.target.value })}>
              <option value="performance">Performance</option>
              <option value="engagement">Engagement</option>
              <option value="roi">ROI Analysis</option>
              <option value="channels">Channel Comparison</option>
            </select>
          </div>
          <div>
            <label className="label">Format</label>
            <select className="input-field" value={reportConfig.format} onChange={(e) => setReportConfig({ ...reportConfig, format: e.target.value })}>
              <option value="pdf">PDF</option>
              <option value="csv">CSV</option>
              <option value="xlsx">Excel</option>
            </select>
          </div>
          <div>
            <label className="label">Date Range</label>
            <select className="input-field" value={reportConfig.dateRange} onChange={(e) => setReportConfig({ ...reportConfig, dateRange: e.target.value })}>
              <option value="7">Last 7 days</option>
              <option value="30">Last 30 days</option>
              <option value="90">Last 90 days</option>
            </select>
          </div>
          <div className="flex items-end">
            <button onClick={generateReport} className="btn-primary w-full">Generate</button>
          </div>
        </div>
      </div>

      <div className="card mb-6">
        <h2 className="section-title mb-4">Data Summary</h2>
        <div className="stat-grid">
          <div><p className="text-2xl font-bold text-slate-900">{campaigns.length}</p><p className="text-xs text-slate-500">Campaigns</p></div>
          <div><p className="text-2xl font-bold text-slate-900">{content.length}</p><p className="text-xs text-slate-500">Content Items</p></div>
          <div><p className="text-2xl font-bold text-slate-900">{auditLogs.length}</p><p className="text-xs text-slate-500">Activity Logs</p></div>
        </div>
      </div>

      {reportHistory.length > 0 && (
        <div className="card">
          <h2 className="section-title mb-4">Report History</h2>
          {reportHistory.slice(0, 6).map((r) => (
            <div key={r.id} className="flex justify-between py-2 text-sm border-b border-slate-100">
              <span>{r.summary}</span>
              <span className="text-slate-400">{new Date(r.createdAt).toLocaleDateString()}</span>
            </div>
          ))}
        </div>
      )}

      {toast && <Toast message={toast} onClose={() => setToast('')} />}
    </div>
  );
}
