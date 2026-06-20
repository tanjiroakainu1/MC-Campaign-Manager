import PageHeader from '../../components/common/PageHeader';
import StatCard from '../../components/common/StatCard';
import QuickActionCard from '../../components/common/QuickActionCard';
import EmptyState from '../../components/common/EmptyState';
import { getContentByUser, getCampaigns } from '../../data/dataStore';
import { contentCreatorNav } from '../../config/navigation';
import { useAuth } from '../../context/AuthContext';
import { ROLE_ACTION_ACCENT } from '../../config/roles';
import { STAT_GRADIENTS, STATUS_BADGES } from '../../config/theme';

export default function ContentCreatorDashboard() {
  const { user } = useAuth();
  const myContent = user ? getContentByUser(user.id) : [];
  const campaigns = getCampaigns();
  const pending = myContent.filter((c) => c.status === 'pending').length;
  const approved = myContent.filter((c) => c.status === 'approved').length;
  const drafts = myContent.filter((c) => c.status === 'draft').length;

  const statusBadge = (status: string) => {
    if (status === 'approved') return STATUS_BADGES.approved;
    if (status === 'pending') return STATUS_BADGES.pending;
    return STATUS_BADGES.draft;
  };

  return (
    <div>
      <PageHeader title="Content Creator Dashboard" description="Create and manage marketing content" />

      <div className="stat-grid">
        <StatCard title="My Content" value={myContent.length} color={STAT_GRADIENTS.a} />
        <StatCard title="Approved" value={approved} color={STAT_GRADIENTS.b} />
        <StatCard title="Pending Review" value={pending} color={STAT_GRADIENTS.c} />
        <StatCard title="Drafts" value={drafts} color={STAT_GRADIENTS.d} />
      </div>

      <div>
        <h2 className="section-title mb-4">Quick Actions</h2>
        <div className="action-grid">
          {contentCreatorNav.map((item) => (
            <QuickActionCard key={item.id} to={item.path} label={item.label} accent={ROLE_ACTION_ACCENT['content-creator']} />
          ))}
        </div>
      </div>

      <div className="card">
        <h2 className="section-title mb-4">Recent Content</h2>
        {myContent.length === 0 ? (
          <EmptyState message="No content created yet" description="Start by creating content for a campaign." />
        ) : (
          <div className="space-y-1">
            {myContent.map((content) => {
              const campaign = campaigns.find((c) => c.id === content.campaignId);
              return (
                <div key={content.id} className="list-row">
                  <div className="min-w-0">
                    <p className="truncate font-semibold text-slate-900">{content.title}</p>
                    <p className="truncate text-xs text-slate-500">{campaign?.name ?? 'Unknown campaign'} — {content.type}</p>
                  </div>
                  <span className={`badge w-fit capitalize ${statusBadge(content.status)}`}>{content.status}</span>
                </div>
              );
            })}
          </div>
        )}
      </div>
    </div>
  );
}
