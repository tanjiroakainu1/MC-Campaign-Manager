import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/PageHeader.dart';
import '../../config/currency.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';
import '../../utils/reportExport.dart';
import '../../utils/responsive.dart';

class CampaignReports extends StatefulWidget {
  const CampaignReports({super.key});
  @override
  State<CampaignReports> createState() => _CampaignReportsState();
}

class _CampaignReportsState extends State<CampaignReports> {
  String _selected = 'all';

  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final campaigns = dataStore.getCampaigns();
    final filtered = _selected == 'all' ? campaigns : campaigns.where((c) => c.id == _selected).toList();
    return AppScreen(children: [
      const PageHeader(title: 'Campaign Reports', description: 'Generate and export campaign reports'),
      AppCard(title: 'Export Report', child: FormSection(children: [
        DropdownButtonFormField(value: _selected, decoration: const InputDecoration(labelText: 'Campaign'), items: [
          const DropdownMenuItem(value: 'all', child: Text('All Campaigns')),
          ...campaigns.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))),
        ], onChanged: (v) => setState(() => _selected = v!)),
        ResponsiveButtonRow(children: [
          ElevatedButton(onPressed: () => downloadCampaignExcel(context, filtered), child: const Text('Generate Excel')),
          OutlinedButton(onPressed: () => downloadCampaignPDF(context, filtered, 'Campaign Report'), child: const Text('Generate PDF')),
        ]),
      ])),
      ...campaigns.map((c) => AppCard(
        child: AppListItem(
          showDivider: false,
          title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${formatCurrency(c.budget)} · ${formatCurrency(c.spent)} · ${c.status}'),
          trailing: Wrap(children: [
            IconButton(onPressed: () => downloadCampaignExcel(context, [c], label: c.name), icon: const Icon(Icons.table_chart)),
            IconButton(onPressed: () => downloadCampaignPDF(context, [c], c.name), icon: const Icon(Icons.picture_as_pdf)),
          ]),
        ),
      )),
    ]);
  }
}
