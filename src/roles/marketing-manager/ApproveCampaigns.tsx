import { useState } from 'react';
import PageHeader from '../../components/common/PageHeader';
import EmptyState from '../../components/common/EmptyState';
import Toast from '../../components/common/Toast';
import { getCampaigns, updateCampaign } from '../../data/dataStore';
import { useAuth } from '../../context/AuthContext';
import type { Campaign } from '../../types';
import { formatCurrency } from '../../config/currency';

export default function ApproveCampaigns() {
  const { user } = useAuth();
  const [campaigns, setCampaigns] = useState(() =>
    getCampaigns().filter((c) => c.status === 'pending' || c.status === 'draft')
  );
  const [toast, setToast] = useState('');

  const refresh = () => setCampaigns(getCampaigns().filter((c) => c.status === 'pending' || c.status === 'draft'));
  const actor = user?.name ?? 'System';

  const approve = async (id: string) => {
    await updateCampaign(id, { status: 'approved' }, actor);
    refresh();
    setToast('Campaign approved');
  };

  const reject = async (id: string) => {
    await updateCampaign(id, { status: 'rejected' }, actor);
    refresh();
    setToast('Campaign rejected');
  };

  return (
    <div>
      <PageHeader title="Approve Campaign Plans" description="Review and approve pending campaign plans" />

      {campaigns.length === 0 ? (
        <div className="card">
          <EmptyState message="No campaigns pending approval" description="All campaign plans have been reviewed." />
        </div>
      ) : (
        <div className="space-y-4">
          {campaigns.map((campaign) => (
            <CampaignCard key={campaign.id} campaign={campaign} onApprove={approve} onReject={reject} />
          ))}
        </div>
      )}

      {toast && <Toast message={toast} onClose={() => setToast('')} />}
    </div>
  );
}

function CampaignCard({ campaign, onApprove, onReject }: { campaign: Campaign; onApprove: (id: string) => void; onReject: (id: string) => void }) {
  return (
    <div className="card-hover">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
        <div>
          <h3 className="text-lg font-bold text-slate-900">{campaign.name}</h3>
          <p className="mt-1 text-sm text-slate-500">{campaign.description}</p>
          <div className="mt-3 flex flex-wrap gap-3 text-sm text-slate-600">
            <span>Category: {campaign.category}</span>
            <span>Budget: {formatCurrency(campaign.budget)}</span>
            <span>{campaign.startDate} — {campaign.endDate}</span>
          </div>
        </div>
        <div className="btn-group pt-0">
          <button onClick={() => onApprove(campaign.id)} className="btn-success btn-sm">Approve</button>
          <button onClick={() => onReject(campaign.id)} className="btn-danger btn-sm">Reject</button>
        </div>
      </div>
    </div>
  );
}
