import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/StatCard.dart';
import '../../config/currency.dart';
import '../../config/theme.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';

class ROITracking extends StatelessWidget {
  const ROITracking({super.key});
  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final campaigns = dataStore.getCampaigns();
    double investment = 0, revenue = 0;
    for (final c in campaigns) {
      investment += c.spent;
      revenue += dataStore.computeCampaignROI(c).revenue;
    }
    final overallRoi = investment > 0 ? (((revenue - investment) / investment) * 100).round() : 0;
    String roiStatus(int roi) => roi >= 200 ? 'excellent' : roi >= 100 ? 'good' : 'poor';
    return AppScreen(children: [
      const PageHeader(title: 'ROI Tracking', description: 'Return on investment analysis'),
      statGrid(context, [
        StatCard(title: 'Total Investment', value: formatCurrency(investment), color: StatGradients.a),
        StatCard(title: 'Total Revenue', value: formatCurrency(revenue), color: StatGradients.b),
        StatCard(title: 'Overall ROI', value: '$overallRoi%', color: StatGradients.c),
        StatCard(title: 'Net Profit', value: formatCurrency(revenue - investment), color: StatGradients.d),
      ]),
      ...campaigns.map((c) {
        final roi = dataStore.computeCampaignROI(c);
        return AppCard(
          child: AppListItem(
            showDivider: false,
            title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Spent: ${formatCurrency(c.spent)} · Revenue: ${formatCurrency(roi.revenue)} · ROI: ${roi.roi}%'),
            trailing: statusBadge(roiStatus(roi.roi)),
          ),
        );
      }),
    ]);
  }
}
