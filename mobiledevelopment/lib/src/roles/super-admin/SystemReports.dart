import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/StatCard.dart';
import '../../components/common/Toast.dart';
import '../../config/theme.dart';
import '../../context/AuthContext.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';
import '../../data/userStore.dart';
import '../../styles/theme.dart';

class SystemReports extends StatefulWidget {
  const SystemReports({super.key});
  @override
  State<SystemReports> createState() => _SystemReportsState();
}

class _SystemReportsState extends State<SystemReports> {
  String _reportType = 'overview';
  String _dateRange = '30';

  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final user = context.watch<AuthProvider>().user;
    final users = userStore.getAllUsers();
    final campaigns = dataStore.getCampaigns();
    final content = dataStore.getContent();
    final logs = dataStore.getAuditLogs();
    final recentLogs = logs.take(6).toList();
    return AppScreen(children: [
      const PageHeader(title: 'System Reports', description: 'Generate system-wide reports'),
      statGrid(context, [
        StatCard(title: 'Users', value: '${users.length}', color: StatGradients.a),
        StatCard(title: 'Campaigns', value: '${campaigns.length}', color: StatGradients.b),
        StatCard(title: 'Content', value: '${content.length}', color: StatGradients.c),
        StatCard(title: 'Activity Logs', value: '${logs.length}', color: StatGradients.d),
      ]),
      AppCard(title: 'Report Configuration', child: FormSection(children: [
        DropdownButtonFormField(value: _reportType, decoration: const InputDecoration(labelText: 'Report Type'), items: const [
          DropdownMenuItem(value: 'overview', child: Text('Overview')),
          DropdownMenuItem(value: 'users', child: Text('Users')),
          DropdownMenuItem(value: 'campaigns', child: Text('Campaigns')),
          DropdownMenuItem(value: 'budget', child: Text('Budget')),
          DropdownMenuItem(value: 'audit', child: Text('Audit')),
        ], onChanged: (v) => setState(() => _reportType = v!)),
        DropdownButtonFormField(value: _dateRange, decoration: const InputDecoration(labelText: 'Date Range'), items: const [
          DropdownMenuItem(value: '7', child: Text('Last 7 days')),
          DropdownMenuItem(value: '30', child: Text('Last 30 days')),
          DropdownMenuItem(value: '90', child: Text('Last 90 days')),
          DropdownMenuItem(value: '365', child: Text('Last year')),
        ], onChanged: (v) => setState(() => _dateRange = v!)),
        ElevatedButton(onPressed: user == null ? null : () async {
          await dataStore.createExportRecord({
            'kind': 'system-report',
            'dataset': _reportType,
            'format': 'summary',
            'dateRange': _dateRange,
            'summary': '$_reportType system report — ${users.length} users, ${campaigns.length} campaigns',
            'recordCount': users.length + campaigns.length + content.length,
          }, user.name);
          if (context.mounted) showToast(context, 'Report saved to database');
        }, child: const Text('Generate Report')),
      ])),
      AppCard(
        title: 'Recent Activity',
        child: Column(
          children: [
            for (var i = 0; i < recentLogs.length; i++)
              AppListItem(
                showDivider: i < recentLogs.length - 1,
                title: Text(recentLogs[i].action),
                subtitle: Text('${recentLogs[i].user} — ${recentLogs[i].resource}'),
              ),
          ],
        ),
      ),
    ]);
  }
}
