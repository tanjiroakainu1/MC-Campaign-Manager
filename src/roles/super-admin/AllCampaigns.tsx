import { useState } from 'react';
import PageHeader from '../../components/common/PageHeader';
import Modal from '../../components/common/Modal';
import { getCampaigns } from '../../data/dataStore';

import { STATUS_BADGES } from '../../config/theme';
import { formatCurrency } from '../../config/currency';

const statusColors: Record<string, string> = {
  draft: STATUS_BADGES.draft,
  pending: STATUS_BADGES.pending,
  approved: STATUS_BADGES.active,
  active: STATUS_BADGES.active,
  completed: STATUS_BADGES.completed,
  rejected: STATUS_BADGES.rejected,
};

export default function AllCampaigns() {
  const campaigns = getCampaigns();
  const [selected, setSelected] = useState<ReturnType<typeof getCampaigns>[0] | null>(null);
  const [filter, setFilter] = useState('all');

  const filtered = filter === 'all' ? campaigns : campaigns.filter((c) => c.status === filter);

  return (
    <div>
      <PageHeader title="All Campaigns" description="View and manage all system campaigns" />

      <div className="filter-tabs mb-4">
        {['all', 'active', 'pending', 'draft', 'completed'].map((s) => (
          <button
            key={s}
            onClick={() => setFilter(s)}
            className={filter === s ? 'filter-tab filter-tab-active' : 'filter-tab'}
          >
            {s}
          </button>
        ))}
      </div>

      <div className="card overflow-hidden p-0 sm:p-0">
        <div className="table-wrap scrollbar-thin">
          <table className="data-table">
          <thead>
            <tr>
              <th>Campaign</th>
              <th>Category</th>
              <th>Status</th>
              <th>Budget</th>
              <th>Channels</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {filtered.map((campaign) => (
              <tr key={campaign.id}>
                <td className="font-semibold text-slate-900">{campaign.name}</td>
                <td className="text-slate-500">{campaign.category}</td>
                <td>
                  <span className={`badge capitalize ${statusColors[campaign.status]}`}>{campaign.status}</span>
                </td>
                <td className="font-medium text-slate-700">{formatCurrency(campaign.budget)}</td>
                <td>
                  <div className="flex gap-1">
                    {campaign.channels.map((ch) => (
                      <span key={ch} className="badge bg-slate-100 text-slate-600 capitalize">{ch}</span>
                    ))}
                  </div>
                </td>
                <td>
                  <button onClick={() => setSelected(campaign)} className="btn-link">View</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        </div>
        {filtered.length === 0 && (
          <p className="px-6 py-10 text-center text-sm text-slate-500">No campaigns found</p>
        )}
      </div>

      <Modal isOpen={!!selected} onClose={() => setSelected(null)} title={selected?.name ?? ''} size="lg">
        {selected && (
          <div className="space-y-4">
            <p className="text-sm text-slate-600">{selected.description}</p>
            <div className="form-grid text-sm">
              <div><span className="text-slate-500">Category:</span> <span className="font-medium">{selected.category}</span></div>
              <div><span className="text-slate-500">Status:</span> <span className={`badge capitalize ${statusColors[selected.status]}`}>{selected.status}</span></div>
              <div><span className="text-slate-500">Budget:</span> <span className="font-medium">{formatCurrency(selected.budget)}</span></div>
              <div><span className="text-slate-500">Spent:</span> <span className="font-medium">{formatCurrency(selected.spent)}</span></div>
              <div><span className="text-slate-500">Start:</span> <span className="font-medium">{selected.startDate}</span></div>
              <div><span className="text-slate-500">End:</span> <span className="font-medium">{selected.endDate}</span></div>
            </div>
          </div>
        )}
      </Modal>
    </div>
  );
}
