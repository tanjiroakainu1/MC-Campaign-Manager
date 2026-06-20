import { useState } from 'react';
import PageHeader from '../../components/common/PageHeader';
import Toast from '../../components/common/Toast';
import { getCampaigns, getContent, getMedia, getAuditLogs, getExportRecords, createExportRecord } from '../../data/dataStore';
import { useAuth } from '../../context/AuthContext';
import { downloadCampaignExcel } from '../../utils/reportExport';

export default function DataExport() {
  const { user } = useAuth();
  const campaigns = getCampaigns();
  const content = getContent();
  const media = getMedia();
  const auditLogs = getAuditLogs();
  const exportHistory = getExportRecords().filter((r) => r.kind === 'data-export');
  const [toast, setToast] = useState('');
  const [exportConfig, setExportConfig] = useState({ dataset: 'campaigns', format: 'csv', dateFrom: '', dateTo: '' });

  const datasets = [
    { id: 'campaigns', label: 'Campaign Data', count: campaigns.length },
    { id: 'content', label: 'Content Data', count: content.length },
    { id: 'media', label: 'Media Library', count: media.length },
    { id: 'audit', label: 'Activity Logs', count: auditLogs.length },
  ];

  const handleExport = async () => {
    const dataset = datasets.find((d) => d.id === exportConfig.dataset);
    const count = dataset?.count ?? 0;
    if (exportConfig.dataset === 'campaigns' && exportConfig.format === 'csv') {
      downloadCampaignExcel(campaigns, exportConfig.dataset);
    }
    await createExportRecord({
      kind: 'data-export',
      dataset: exportConfig.dataset,
      format: exportConfig.format,
      dateRange: exportConfig.dateFrom && exportConfig.dateTo ? `${exportConfig.dateFrom}–${exportConfig.dateTo}` : '',
      summary: `${dataset?.label} (${count} records)`,
      recordCount: count,
    }, user?.name);
    setToast(`Exported ${dataset?.label} (${count} records) as ${exportConfig.format.toUpperCase()} — saved to database`);
  };

  return (
    <div>
      <PageHeader title="Export Data" description="Export campaign data — records stored in Prisma" />

      <div className="content-grid">
        <div className="card">
          <h2 className="section-title mb-4">Export Configuration</h2>
          <div className="space-y-4">
            <div>
              <label className="label">Dataset</label>
              <select className="input-field" value={exportConfig.dataset} onChange={(e) => setExportConfig({ ...exportConfig, dataset: e.target.value })}>
                {datasets.map((d) => (
                  <option key={d.id} value={d.id}>{d.label} ({d.count} records)</option>
                ))}
              </select>
            </div>
            <div>
              <label className="label">Format</label>
              <select className="input-field" value={exportConfig.format} onChange={(e) => setExportConfig({ ...exportConfig, format: e.target.value })}>
                <option value="csv">CSV</option>
                <option value="xlsx">Excel (XLSX)</option>
                <option value="json">JSON</option>
              </select>
            </div>
            <button onClick={handleExport} className="btn-primary w-full">Export Data</button>
          </div>
        </div>

        <div className="card">
          <h2 className="section-title mb-4">Available Datasets</h2>
          <div className="space-y-3">
            {datasets.map((d) => (
              <div key={d.id} onClick={() => setExportConfig({ ...exportConfig, dataset: d.id })} className={`cursor-pointer rounded-lg border p-4 transition ${exportConfig.dataset === d.id ? 'border-brand-500 bg-brand-50' : 'border-slate-200 hover:border-slate-300'}`}>
                <div className="flex items-center justify-between">
                  <span className="font-medium text-slate-900">{d.label}</span>
                  <span className="text-sm text-slate-500">{d.count} records</span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {exportHistory.length > 0 && (
        <div className="card mt-6">
          <h2 className="section-title mb-4">Export History (from database)</h2>
          <div className="space-y-2">
            {exportHistory.slice(0, 8).map((r) => (
              <div key={r.id} className="flex justify-between text-sm border-b border-slate-100 py-2">
                <span>{r.summary}</span>
                <span className="text-slate-400">{new Date(r.createdAt).toLocaleString()}</span>
              </div>
            ))}
          </div>
        </div>
      )}

      {toast && <Toast message={toast} onClose={() => setToast('')} />}
    </div>
  );
}
