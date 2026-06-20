import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/Modal.dart';
import '../../components/common/PageHeader.dart';
import '../../config/currency.dart';
import '../../config/theme.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';
import '../../types/index.dart';

class AllCampaigns extends StatefulWidget {
  const AllCampaigns({super.key});
  @override
  State<AllCampaigns> createState() => _AllCampaignsState();
}

class _AllCampaignsState extends State<AllCampaigns> {
  String _filter = 'all';
  Campaign? _selected;

  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final campaigns = dataStore.getCampaigns().where((c) => _filter == 'all' || c.status == _filter).toList();
    return Stack(children: [
      AppScreen(children: [
        const PageHeader(title: 'All Campaigns', description: 'View all campaigns across the system'),
        Wrap(spacing: 8, children: ['all','active','pending','draft','completed'].map((f) => ChoiceChip(label: Text(f), selected: _filter == f, onSelected: (_) => setState(() => _filter = f))).toList()),
        ...campaigns.map((c) => AppCard(
          child: InkWell(
            onTap: () => setState(() => _selected = c),
            child: AppListItem(
              showDivider: false,
              title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${c.category} · ${formatCurrency(c.budget)}'),
              trailing: statusBadge(c.status),
            ),
          ),
        )),
      ]),
      AppModal(isOpen: _selected != null, onClose: () => setState(() => _selected = null), title: _selected?.name ?? 'Campaign', child: _selected == null ? const SizedBox.shrink() : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_selected!.description),
        const SizedBox(height: 8),
        Text('Category: ${_selected!.category}'),
        Text('Status: ${_selected!.status}'),
        Text('Budget: ${formatCurrency(_selected!.budget)}'),
        Text('Spent: ${formatCurrency(_selected!.spent)}'),
        Text('Dates: ${_selected!.startDate} — ${_selected!.endDate}'),
        Text('Channels: ${_selected!.channels.join(', ')}'),
      ])),
    ]);
  }
}
