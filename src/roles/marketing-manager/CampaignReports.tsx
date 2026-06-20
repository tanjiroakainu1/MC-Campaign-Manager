import { useState } from 'react';
import PageHeader from '../../components/common/PageHeader';
import Toast from '../../components/common/Toast';
import { getCampaigns, createExportRecord } from '../../data/dataStore';
import { downloadCampaignExcel, downloadCampaignPDF } from '../../utils/reportExport';
import { formatCurrency } from '../../config/currency';
import { useAuth } from '../../context/AuthContext';

export default function CampaignReports() {
  const { user } = useAuth();
  const campaigns = getCampaigns();
  const [toast, setToast] = useState('');
  const [selectedCampaign, setSelectedCampaign] = useState('all');

  const getReportCampaigns = () =>
    selectedCampaign === 'all'
      ? campaigns
      : campaigns.filter((c) => c.id === selectedCampaign);

  const getReportLabel = () => {
    if (selectedCampaign === 'all') return 'All Campaigns';
    return campaigns.find((c) => c.id === selectedCampaign)?.name ?? 'Campaign';
  };

  const saveReport = async (format: string, label: string, count: number) => {
    await createExportRecord({
      kind: 'campaign-report',
      dataset: selectedCampaign,
      format,
      dateRange: '',
      summary: `${format.toUpperCase()} report for ${label}`,
      recordCount: count,
    }, user?.name);
  };

  const generateExcel = async () => {
    const reportCampaigns = getReportCampaigns();
    if (reportCampaigns.length === 0) {
      setToast('No campaign data to export');
      return;
    }
    downloadCampaignExcel(reportCampaigns, getReportLabel().toLowerCase().replace(/\s+/g, '-'));
    await saveReport('excel', getReportLabel(), reportCampaigns.length);
    setToast(`Excel report generated for ${getReportLabel()} — saved to database`);
  };

  const generatePDF = async () => {
    const reportCampaigns = getReportCampaigns();
    if (reportCampaigns.length === 0) {
      setToast('No campaign data to export');
      return;
    }
    downloadCampaignPDF(reportCampaigns, `Campaign Report — ${getReportLabel()}`);
    await saveReport('pdf', getReportLabel(), reportCampaigns.length);
    setToast(`PDF report opened for ${getReportLabel()} — saved to database`);
  };

  const downloadCampaignExcelSingle = async (campaignId: string) => {
    const campaign = campaigns.find((c) => c.id === campaignId);
    if (!campaign) return;
    downloadCampaignExcel([campaign], campaign.name.toLowerCase().replace(/\s+/g, '-'));
    await saveReport('excel', campaign.name, 1);
    setToast(`Excel report downloaded for ${campaign.name}`);
  };

  const downloadCampaignPDFSingle = async (campaignId: string) => {
    const campaign = campaigns.find((c) => c.id === campaignId);
    if (!campaign) return;
    downloadCampaignPDF([campaign], `Campaign Report — ${campaign.name}`);
    await saveReport('pdf', campaign.name, 1);
    setToast(`PDF report opened for ${campaign.name}`);
  };

  return (
    <div>
      <PageHeader title="Campaign Reports" description="Generate Excel and PDF reports from actual campaign data" />

      <div className="card mb-6">
        <h2 className="section-title mb-4">Generate Report</h2>
        <div className="form-grid-3">
          <div>
            <label className="label">Campaign</label>
            <select className="input-field" value={selectedCampaign} onChange={(e) => setSelectedCampaign(e.target.value)}>
              <option value="all">All Campaigns ({campaigns.length})</option>
              {campaigns.map((c) => (
                <option key={c.id} value={c.id}>{c.name}</option>
              ))}
            </select>
          </div>
          <div className="form-actions lg:col-span-2">
            <button onClick={generateExcel} className="btn-secondary">Generate Excel</button>
            <button onClick={generatePDF} className="btn-primary">Generate PDF</button>
          </div>
        </div>
      </div>

      <div className="content-grid">
        {campaigns.map((campaign) => (
          <div key={campaign.id} className="card">
            <h3 className="font-semibold text-slate-900">{campaign.name}</h3>
            <div className="mt-3 form-grid text-sm">
              <div><span className="text-slate-500">Budget:</span> {formatCurrency(campaign.budget)}</div>
              <div><span className="text-slate-500">Spent:</span> {formatCurrency(campaign.spent)}</div>
              <div><span className="text-slate-500">Status:</span> <span className="capitalize">{campaign.status}</span></div>
              <div><span className="text-slate-500">Channels:</span> {campaign.channels.join(', ')}</div>
            </div>
            <div className="btn-group mt-4 pt-0">
              <button onClick={() => downloadCampaignExcelSingle(campaign.id)} className="btn-secondary text-sm">Download Excel</button>
              <button onClick={() => downloadCampaignPDFSingle(campaign.id)} className="btn-primary text-sm">Download PDF</button>
            </div>
          </div>
        ))}
        {campaigns.length === 0 && <p className="text-sm text-slate-500">No campaigns in the system yet.</p>}
      </div>

      {toast && <Toast message={toast} onClose={() => setToast('')} />}
    </div>
  );
}
