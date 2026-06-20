import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/QuickActionCard.dart';
import '../../components/common/StatCard.dart';
import '../../config/navigation.dart';
import '../../config/roles.dart';
import '../../config/theme.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';
import '../../data/userStore.dart';
import '../../styles/theme.dart';

class SuperAdminDashboard extends StatelessWidget {
  const SuperAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final users = userStore.getAllUsers();
    final campaigns = dataStore.getCampaigns();
    final auditLogs = dataStore.getAuditLogs();
    final activeCampaigns = campaigns.where((c) => c.status == 'active').length;
    final activeUsers = users.where((u) => u.status == 'active').length;

    return AppScreen(
      children: [
        const PageHeader(title: 'Super Admin Dashboard', description: 'Full system overview and administration'),
        statGrid(context, [
          StatCard(title: 'Total Users', value: '${users.length}', color: StatGradients.a),
          StatCard(title: 'Active Users', value: '$activeUsers', color: StatGradients.b),
          StatCard(title: 'Total Campaigns', value: '${campaigns.length}', color: StatGradients.c),
          StatCard(title: 'Active Campaigns', value: '$activeCampaigns', color: StatGradients.d),
        ]),
        const SectionHeader(title: 'Quick Actions'),
        actionGrid(context, superAdminNav.map((item) => QuickActionCard(to: item.path, label: item.label, accent: roleActionAccent[UserRoles.superAdmin])).toList()),
        AppCard(
          title: 'Recent Activity',
          child: Column(
            children: [
              for (var i = 0; i < auditLogs.take(8).length; i++)
                AppListItem(
                  showDivider: i < auditLogs.take(8).length - 1,
                  title: Text(auditLogs[i].action, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('${auditLogs[i].user} — ${auditLogs[i].resource}'),
                  trailing: Text(
                    DateTime.tryParse(auditLogs[i].timestamp)?.toLocal().toString().split('.').first ?? auditLogs[i].timestamp,
                    style: const TextStyle(fontSize: 11, color: AppColors.slate500),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
