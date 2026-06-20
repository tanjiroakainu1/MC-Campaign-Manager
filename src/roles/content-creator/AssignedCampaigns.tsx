import PageHeader from '../../components/common/PageHeader';
import { getCampaigns, getContentByUser } from '../../data/dataStore';
import { useAuth } from '../../context/AuthContext';
import { STATUS_BADGES } from '../../config/theme';

export default function AssignedCampaigns() {
  const { user } = useAuth();
  const myContent = user ? getContentByUser(user.id) : [];
  const assignedCampaignIds = [...new Set(myContent.map((c) => c.campaignId))];
  const allCampaigns = getCampaigns();
  const assignedCampaigns = allCampaigns.filter((c) => assignedCampaignIds.includes(c.id));

  return (
    <div>
      <PageHeader title="Assigned Campaigns" description="Campaigns you have created content for" />

      {assignedCampaigns.length === 0 ? (
        <div className="card text-sm text-slate-500">No assigned campaigns yet. Create content for a campaign to see it here.</div>
      ) : (
        <div className="content-grid">
          {assignedCampaigns.map((campaign) => {
            const campaignContent = myContent.filter((c) => c.campaignId === campaign.id);
            return (
              <div key={campaign.id} className="card">
                <div className="flex items-start justify-between">
                  <div>
                    <h3 className="font-semibold text-slate-900">{campaign.name}</h3>
                    <p className="mt-1 text-sm text-slate-500">{campaign.description}</p>
                  </div>
                  <span className={`badge capitalize ${campaign.status === 'active' ? STATUS_BADGES.active : STATUS_BADGES.inactive}`}>{campaign.status}</span>
                </div>
                <div className="mt-4 form-grid text-sm">
                  <div><span className="text-slate-500">Category:</span> {campaign.category}</div>
                  <div><span className="text-slate-500">Channels:</span> {campaign.channels.join(', ')}</div>
                </div>
                <div className="mt-4 border-t border-slate-100 pt-4">
                  <p className="text-sm font-medium text-slate-700">Your Content ({campaignContent.length})</p>
                  <div className="mt-2 space-y-1">
                    {campaignContent.map((c) => (
                      <div key={c.id} className="flex items-center justify-between text-sm">
                        <span className="text-slate-600">{c.title}</span>
                        <span className={`badge capitalize text-xs ${c.status === 'approved' ? STATUS_BADGES.approved : c.status === 'pending' ? STATUS_BADGES.pending : STATUS_BADGES.draft}`}>{c.status}</span>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
