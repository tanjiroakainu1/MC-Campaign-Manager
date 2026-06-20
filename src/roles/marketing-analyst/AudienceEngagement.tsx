import PageHeader from '../../components/common/PageHeader';
import StatCard from '../../components/common/StatCard';
import { getCampaigns, getContent } from '../../data/dataStore';

export default function AudienceEngagement() {
  const campaigns = getCampaigns();
  const content = getContent();
  const approvedContent = content.filter((c) => c.status === 'approved').length;

  const channelEngagement = campaigns.reduce<Record<string, { campaigns: number; content: number }>>((acc, c) => {
    c.channels.forEach((ch) => {
      if (!acc[ch]) acc[ch] = { campaigns: 0, content: 0 };
      acc[ch].campaigns += 1;
    });
    return acc;
  }, {});

  content.forEach((item) => {
    const campaign = campaigns.find((c) => c.id === item.campaignId);
    campaign?.channels.forEach((ch) => {
      if (channelEngagement[ch]) channelEngagement[ch].content += 1;
    });
  });

  return (
    <div>
      <PageHeader title="Audience Engagement" description="Engagement metrics derived from campaign and content data" />

      <div className="stat-grid mb-8">
        <StatCard title="Total Campaigns" value={campaigns.length} />
        <StatCard title="Content Pieces" value={content.length} />
        <StatCard title="Approved Content" value={approvedContent} />
        <StatCard title="Active Channels" value={Object.keys(channelEngagement).length} />
      </div>

      <div className="card">
        <h2 className="section-title mb-4">Engagement by Channel</h2>
        {Object.keys(channelEngagement).length === 0 ? (
          <p className="text-sm text-slate-500">No channel data available.</p>
        ) : (
          <div className="space-y-4">
            {Object.entries(channelEngagement).map(([channel, data]) => (
              <div key={channel}>
                <p className="mb-2 font-medium capitalize text-slate-900">{channel}</p>
                <div className="form-grid text-center text-xs">
                  <div><p className="text-slate-500">Campaigns</p><p className="font-semibold">{data.campaigns}</p></div>
                  <div><p className="text-slate-500">Content Items</p><p className="font-semibold">{data.content}</p></div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
