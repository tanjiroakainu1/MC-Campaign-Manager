import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/charts/DashboardCharts.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/EmptyState.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/QuickActionCard.dart';
import '../../components/common/StatCard.dart';
import '../../config/currency.dart';
import '../../config/navigation.dart';
import '../../config/roles.dart';
import '../../config/theme.dart';
import '../../context/AuthContext.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';
import '../../styles/theme.dart';

class MarketingManagerDashboard extends StatelessWidget {
  const MarketingManagerDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final user = context.watch<AuthProvider>().user!;
    final campaigns = dataStore.getCampaigns().where((c) => c.managerId == user.id).toList();
    final active = campaigns.where((c) => c.status == 'active').length;
    final pending = campaigns.where((c) => c.status == 'pending' || c.status == 'draft').length;
    final budget = campaigns.fold<double>(0, (s, c) => s + c.budget);
    final spent = campaigns.fold<double>(0, (s, c) => s + c.spent);
    final util = budget > 0 ? ((spent / budget) * 100).round() : 0;

    return AppScreen(
      children: [
        const PageHeader(title: 'Marketing Manager Dashboard', description: 'Campaign planning and performance overview'),
        statGrid(context, [
          StatCard(title: 'My Campaigns', value: '${campaigns.length}', color: StatGradients.a),
          StatCard(title: 'Active', value: '$active', color: StatGradients.b),
          StatCard(title: 'Pending Approval', value: '$pending', color: StatGradients.c),
          StatCard(title: 'Budget Used', value: '$util%', color: StatGradients.d),
        ]),
        DashboardCharts(campaigns: campaigns, variant: DashboardChartVariant.manager),
        AppCard(
          title: 'Budget Overview',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Allocated: ${formatCurrency(budget)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text('Spent: ${formatCurrency(spent)}', style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.brand600)),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(value: budget > 0 ? spent / budget : 0, minHeight: 10),
              ),
              const SizedBox(height: 8),
              Text('$util% utilized', style: const TextStyle(fontSize: 13, color: AppColors.slate500)),
            ],
          ),
        ),
        const SectionHeader(title: 'Quick Actions'),
        actionGrid(context, marketingManagerNav.take(4).map((item) => QuickActionCard(to: item.path, label: item.label, accent: roleActionAccent[UserRoles.marketingManager])).toList()),
        AppCard(
          title: 'Recent Campaigns',
          child: campaigns.isEmpty
              ? const EmptyState(message: 'No campaigns yet', description: 'Create your first campaign to get started', icon: Icons.campaign_outlined)
              : Column(
                  children: [
                    for (var i = 0; i < campaigns.take(5).length; i++)
                      AppListItem(
                        showDivider: i < campaigns.take(5).length - 1,
                        title: Text(campaigns[i].name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('${campaigns[i].status} · ${formatCurrency(campaigns[i].budget)}'),
                        trailing: statusBadge(campaigns[i].status),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
