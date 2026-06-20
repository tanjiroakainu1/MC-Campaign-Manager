import PageHeader from '../../components/common/PageHeader';
import StatCard from '../../components/common/StatCard';
import { getCampaigns, computeCampaignROI } from '../../data/dataStore';
import { STAT_GRADIENTS, STATUS_BADGES, TEXT_POSITIVE, TEXT_NEGATIVE } from '../../config/theme';
import { formatCurrency } from '../../config/currency';

export default function ROITracking() {
  const campaigns = getCampaigns();
  const roiData = campaigns.map((c) => ({ ...c, ...computeCampaignROI(c) }));

  const totalSpent = roiData.reduce((s, c) => s + c.spent, 0);
  const totalRevenue = roiData.reduce((s, c) => s + c.revenue, 0);
  const overallROI = totalSpent > 0 ? Math.round(((totalRevenue - totalSpent) / totalSpent) * 100) : 0;

  const roiBadge = (roi: number) => {
    if (roi >= 200) return STATUS_BADGES.excellent;
    if (roi >= 100) return STATUS_BADGES.good;
    return STATUS_BADGES.poor;
  };

  const roiText = (roi: number) => {
    if (roi >= 200) return TEXT_POSITIVE;
    if (roi >= 100) return 'text-brand-500';
    return TEXT_NEGATIVE;
  };

  return (
    <div>
      <PageHeader title="ROI Tracking" description="Measure return on investment from actual campaign spend data" />

      <div className="stat-grid mb-8">
        <StatCard title="Total Investment" value={formatCurrency(totalSpent)} color={STAT_GRADIENTS.a} />
        <StatCard title="Total Revenue" value={formatCurrency(totalRevenue)} color={STAT_GRADIENTS.b} />
        <StatCard title="Overall ROI" value={`${overallROI}%`} color={STAT_GRADIENTS.c} />
        <StatCard title="Net Profit" value={formatCurrency(totalRevenue - totalSpent)} color={STAT_GRADIENTS.d} />
      </div>

      <div className="card">
        <h2 className="section-title mb-4">Campaign ROI Breakdown</h2>
        {roiData.length === 0 ? (
          <p className="text-sm text-slate-500">No campaign data available.</p>
        ) : (
          <div className="table-wrap scrollbar-thin -mx-4 sm:mx-0">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Campaign</th>
                  <th>Spent</th>
                  <th>Revenue</th>
                  <th>ROI</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tbody>
                {roiData.map((c) => (
                  <tr key={c.id}>
                    <td className="font-semibold text-slate-900">{c.name}</td>
                    <td className="text-slate-500">{formatCurrency(c.spent)}</td>
                    <td className="text-slate-500">{formatCurrency(c.revenue)}</td>
                    <td><span className={`font-bold ${roiText(c.roi)}`}>{c.roi}%</span></td>
                    <td><span className={`badge ${roiBadge(c.roi)}`}>{c.roi >= 200 ? 'Excellent' : c.roi >= 100 ? 'Good' : 'Poor'}</span></td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}
