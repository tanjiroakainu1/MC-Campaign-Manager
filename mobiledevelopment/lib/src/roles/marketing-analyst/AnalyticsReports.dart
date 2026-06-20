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

class AnalyticsReports extends StatefulWidget {
  const AnalyticsReports({super.key});
  @override
  State<AnalyticsReports> createState() => _AnalyticsReportsState();
}

class _AnalyticsReportsState extends State<AnalyticsReports> {
  String _type = 'performance';
  String _format = 'pdf';
  String _range = '30';

  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final user = context.watch<AuthProvider>().user;
    final campaigns = dataStore.getCampaigns();
    final content = dataStore.getContent();
    final logs = dataStore.getAuditLogs();
    return AppScreen(children: [
      const PageHeader(title: 'Analytics Reports', description: 'Configure and generate analytics reports'),
      AppCard(title: 'Report Configuration', child: FormSection(children: [
        DropdownButtonFormField(value: _type, decoration: const InputDecoration(labelText: 'Report Type'), items: const [DropdownMenuItem(value: 'performance', child: Text('Performance')), DropdownMenuItem(value: 'engagement', child: Text('Engagement')), DropdownMenuItem(value: 'roi', child: Text('ROI')), DropdownMenuItem(value: 'channels', child: Text('Channels'))], onChanged: (v) => setState(() => _type = v!)),
        DropdownButtonFormField(value: _format, decoration: const InputDecoration(labelText: 'Format'), items: const [DropdownMenuItem(value: 'pdf', child: Text('PDF')), DropdownMenuItem(value: 'csv', child: Text('CSV')), DropdownMenuItem(value: 'xlsx', child: Text('Excel'))], onChanged: (v) => setState(() => _format = v!)),
        DropdownButtonFormField(value: _range, decoration: const InputDecoration(labelText: 'Date Range'), items: const [DropdownMenuItem(value: '7', child: Text('7 days')), DropdownMenuItem(value: '30', child: Text('30 days')), DropdownMenuItem(value: '90', child: Text('90 days'))], onChanged: (v) => setState(() => _range = v!)),
        ElevatedButton(onPressed: user == null ? null : () async {
          await dataStore.createExportRecord({
            'kind': 'analytics-report',
            'dataset': _type,
            'format': _format,
            'dateRange': _range,
            'summary': '$_type analytics report',
            'recordCount': campaigns.length + content.length,
          }, user.name);
          if (context.mounted) showToast(context, 'Report saved to database');
        }, child: const Text('Generate')),
      ])),
      statGrid(context, [
        StatCard(title: 'Campaigns', value: '${campaigns.length}', color: StatGradients.a),
        StatCard(title: 'Content', value: '${content.length}', color: StatGradients.b),
        StatCard(title: 'Audit Logs', value: '${logs.length}', color: StatGradients.c),
        StatCard(title: 'Active', value: '${campaigns.where((c) => c.status == 'active').length}', color: StatGradients.d),
      ]),
    ]);
  }
}
