import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../components/charts/DashboardCharts.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/QuickActionCard.dart';
import '../../components/common/StatCard.dart';
import '../../config/currency.dart';
import '../../config/navigation.dart';
import '../../config/roles.dart';
import '../../config/theme.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';

class MarketingAnalystDashboard extends StatelessWidget {
  const MarketingAnalystDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final campaigns = dataStore.getCampaigns();
    final reach = campaigns.fold<int>(0, (s, c) => s + ((c.spent * 3.85 + c.budget * 0.12).round()));
    final spent = campaigns.fold<double>(0, (s, c) => s + c.spent);
    final avgRoi = campaigns.isEmpty ? 0 : (campaigns.fold<int>(0, (s, c) => s + dataStore.computeCampaignROI(c).roi) / campaigns.length).round();
    final top = [...campaigns]..sort((a, b) => dataStore.computeCampaignROI(b).roi.compareTo(dataStore.computeCampaignROI(a).roi));

    return AppScreen(
      children: [
        PageHeader(
          title: 'Marketing Analyst Dashboard',
          description: 'Analytics overview and insights',
          action: OutlinedButton(onPressed: () => context.go('/marketing-analyst/dashboard'), child: const Text('Performance Dashboard')),
        ),
        statGrid(context, [
          StatCard(title: 'Total Campaigns', value: '${campaigns.length}', color: StatGradients.a),
          StatCard(title: 'Total Reach', value: '$reach', color: StatGradients.b),
          StatCard(title: 'Total Spent', value: formatCurrency(spent), color: StatGradients.c),
          StatCard(title: 'Avg ROI', value: '$avgRoi%', color: StatGradients.d),
        ]),
        DashboardCharts(campaigns: campaigns, variant: DashboardChartVariant.analyst),
        const SectionHeader(title: 'Analytics Tools'),
        actionGrid(context, marketingAnalystNav.map((item) => QuickActionCard(to: item.path, label: item.label, accent: roleActionAccent[UserRoles.marketingAnalyst])).toList()),
        AppCard(
          title: 'Top Performing Campaigns',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < top.take(3).length; i++)
                AppListItem(
                  showDivider: i < top.take(3).length - 1,
                  title: Text(top[i].name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('ROI: ${dataStore.computeCampaignROI(top[i]).roi}% · Revenue: ${formatCurrency(dataStore.computeCampaignROI(top[i]).revenue)}'),
                  trailing: statusBadge(top[i].status),
                ),
              const SizedBox(height: 12),
              InfoBanner(
                message: '${campaigns.where((c) => c.status == 'active').length} active campaigns driving ${formatCurrency(spent)} in spend with $avgRoi% average ROI.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
