import { useState } from 'react';
import PageHeader from '../../components/common/PageHeader';
import StatCard from '../../components/common/StatCard';
import { getCampaigns, getCampaignMetrics } from '../../data/dataStore';
import { formatCurrency, formatCurrencyDecimal } from '../../config/currency';

export default function CampaignMetrics() {
  const campaigns = getCampaigns();
  const [selectedCampaign, setSelectedCampaign] = useState(campaigns[0]?.id ?? '');
  const campaign = campaigns.find((c) => c.id === selectedCampaign);
  const metrics = selectedCampaign ? getCampaignMetrics(selectedCampaign) : null;

  return (
    <div>
      <PageHeader title="Campaign Metrics" description="Monitor detailed campaign performance metrics from stored data" />

      <div className="mb-6">
        <label className="label">Select Campaign</label>
        <select className="input-field max-w-md" value={selectedCampaign} onChange={(e) => setSelectedCampaign(e.target.value)}>
          {campaigns.map((c) => <option key={c.id} value={c.id}>{c.name}</option>)}
        </select>
      </div>

      {!campaign || !metrics ? (
        <div className="card text-sm text-slate-500">No campaign data available.</div>
      ) : (
        <>
          <div className="mb-6 stat-grid">
            <StatCard title="Reach" value={metrics.reach.toLocaleString()} />
            <StatCard title="Impressions" value={metrics.impressions.toLocaleString()} />
            <StatCard title="Clicks" value={metrics.clicks.toLocaleString()} />
            <StatCard title="Conversions" value={metrics.conversions.toLocaleString()} />
          </div>

          <div className="stat-grid">
            <div className="card text-center"><p className="text-sm text-slate-500">CTR</p><p className="mt-1 text-2xl font-bold">{metrics.ctr}%</p></div>
            <div className="card text-center"><p className="text-sm text-slate-500">Conversion Rate</p><p className="mt-1 text-2xl font-bold">{metrics.conversionRate}%</p></div>
            <div className="card text-center"><p className="text-sm text-slate-500">CPC</p><p className="mt-1 text-2xl font-bold">{formatCurrencyDecimal(metrics.cpc)}</p></div>
            <div className="card text-center"><p className="text-sm text-slate-500">CPM</p><p className="mt-1 text-2xl font-bold">{formatCurrencyDecimal(metrics.cpm)}</p></div>
          </div>

          <div className="card mt-6">
            <h2 className="section-title mb-4">Campaign Details — {campaign.name}</h2>
            <div className="form-grid">
              <div><span className="text-slate-500">Budget:</span> <span className="font-medium">{formatCurrency(campaign.budget)}</span></div>
              <div><span className="text-slate-500">Spent:</span> <span className="font-medium">{formatCurrency(campaign.spent)}</span></div>
              <div><span className="text-slate-500">Status:</span> <span className="font-medium capitalize">{campaign.status}</span></div>
              <div><span className="text-slate-500">Channels:</span> <span className="font-medium">{campaign.channels.join(', ')}</span></div>
            </div>
          </div>
        </>
      )}
    </div>
  );
}
