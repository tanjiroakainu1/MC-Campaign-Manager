import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/Toast.dart';
import '../../context/AuthContext.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';

class DataExport extends StatefulWidget {
  const DataExport({super.key});
  @override
  State<DataExport> createState() => _DataExportState();
}

class _DataExportState extends State<DataExport> {
  String _dataset = 'campaigns';
  String _format = 'csv';

  Future<void> _export(BuildContext context, String actor) async {
    final datasets = {
      'campaigns': dataStore.getCampaigns().length,
      'content': dataStore.getContent().length,
      'media': dataStore.getMedia().length,
      'audit': dataStore.getAuditLogs().length,
    };
    final count = datasets[_dataset] ?? 0;
    await dataStore.createExportRecord({
      'kind': 'data-export',
      'dataset': _dataset,
      'format': _format,
      'dateRange': '',
      'summary': '$_dataset export ($count records)',
      'recordCount': count,
    }, actor);
    if (context.mounted) showToast(context, 'Export saved to database ($_dataset, $count records)');
  }

  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final user = context.watch<AuthProvider>().user;
    final history = dataStore.getExportRecords().where((r) => r.kind == 'data-export').toList();
    final datasets = {
      'campaigns': dataStore.getCampaigns().length,
      'content': dataStore.getContent().length,
      'media': dataStore.getMedia().length,
      'audit': dataStore.getAuditLogs().length,
    };
    return AppScreen(children: [
      const PageHeader(title: 'Export Data', description: 'Export datasets — records stored in Prisma'),
      AppCard(title: 'Export Configuration', child: FormSection(children: [
        DropdownButtonFormField(value: _dataset, decoration: const InputDecoration(labelText: 'Dataset'), items: datasets.keys.map((k) => DropdownMenuItem(value: k, child: Text('$k (${datasets[k]})'))).toList(), onChanged: (v) => setState(() => _dataset = v!)),
        DropdownButtonFormField(value: _format, decoration: const InputDecoration(labelText: 'Format'), items: const [DropdownMenuItem(value: 'csv', child: Text('CSV')), DropdownMenuItem(value: 'xlsx', child: Text('Excel')), DropdownMenuItem(value: 'json', child: Text('JSON'))], onChanged: (v) => setState(() => _format = v!)),
        ElevatedButton(onPressed: user == null ? null : () => _export(context, user.name), child: const Text('Export')),
      ])),
      if (history.isNotEmpty) AppCard(title: 'Export History', child: Column(children: history.take(6).map((r) => AppListItem(showDivider: true, title: Text(r.summary), trailing: Text(r.createdAt.split('T').first))).toList())),
    ]);
  }
}
