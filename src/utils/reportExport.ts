import type { Campaign } from '../types';
import { getCampaignMetrics } from '../data/dataStore';
import { formatCurrency } from '../config/currency';

function triggerDownload(blob: Blob, filename: string) {
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.download = filename;
  link.click();
  URL.revokeObjectURL(url);
}

function escapeCsv(value: string | number) {
  return `"${String(value).replace(/"/g, '""')}"`;
}

export function downloadCampaignExcel(campaigns: Campaign[], label = 'campaign-report') {
  const headers = ['Name', 'Category', 'Status', 'Budget', 'Spent', 'Start Date', 'End Date', 'Channels', 'Reach', 'CTR'];
  const rows = campaigns.map((campaign) => {
    const metrics = getCampaignMetrics(campaign.id);
    return [
      campaign.name,
      campaign.category,
      campaign.status,
      campaign.budget,
      campaign.spent,
      campaign.startDate,
      campaign.endDate,
      campaign.channels.join('; '),
      metrics?.reach ?? 0,
      metrics ? `${metrics.ctr}%` : '0%',
    ];
  });

  const csv = [headers, ...rows].map((row) => row.map(escapeCsv).join(',')).join('\n');
  const blob = new Blob(['\ufeff', csv], { type: 'text/csv;charset=utf-8;' });
  const date = new Date().toISOString().split('T')[0];
  triggerDownload(blob, `${label}-${date}.csv`);
}

export function downloadCampaignPDF(campaigns: Campaign[], title: string) {
  const date = new Date().toLocaleDateString();
  const rows = campaigns
    .map((campaign) => {
      const metrics = getCampaignMetrics(campaign.id);
      return `
        <tr>
          <td>${campaign.name}</td>
          <td>${campaign.category}</td>
          <td>${campaign.status}</td>
          <td>${formatCurrency(campaign.budget)}</td>
          <td>${formatCurrency(campaign.spent)}</td>
          <td>${campaign.channels.join(', ')}</td>
          <td>${metrics?.reach.toLocaleString() ?? '0'}</td>
          <td>${metrics ? `${metrics.ctr}%` : '0%'}</td>
        </tr>
      `;
    })
    .join('');

  const html = `<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <title>${title}</title>
    <style>
      body { font-family: Arial, sans-serif; color: #0f172a; padding: 32px; }
      h1 { color: #1d4ed8; margin-bottom: 4px; }
      p { color: #64748b; margin-top: 0; }
      table { width: 100%; border-collapse: collapse; margin-top: 24px; font-size: 12px; }
      th, td { border: 1px solid #dbeafe; padding: 10px; text-align: left; }
      th { background: #eff6ff; color: #1e3a8a; }
      tr:nth-child(even) { background: #f8fafc; }
    </style>
  </head>
  <body>
    <h1>${title}</h1>
    <p>Generated on ${date} — ${campaigns.length} campaign(s)</p>
    <table>
      <thead>
        <tr>
          <th>Campaign</th>
          <th>Category</th>
          <th>Status</th>
          <th>Budget</th>
          <th>Spent</th>
          <th>Channels</th>
          <th>Reach</th>
          <th>CTR</th>
        </tr>
      </thead>
      <tbody>${rows}</tbody>
    </table>
  </body>
</html>`;

  const blob = new Blob([html], { type: 'text/html;charset=utf-8;' });
  const printWindow = window.open(URL.createObjectURL(blob), '_blank');
  if (printWindow) {
    printWindow.onload = () => {
      printWindow.focus();
      printWindow.print();
    };
  }
}
