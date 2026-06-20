import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/Modal.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/Toast.dart';
import '../../config/theme.dart';
import '../../context/AuthContext.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';

class MarketingStrategies extends StatefulWidget {
  const MarketingStrategies({super.key});
  @override
  State<MarketingStrategies> createState() => _MarketingStrategiesState();
}

class _MarketingStrategiesState extends State<MarketingStrategies> {
  bool _modalOpen = false;
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _channels = <String>{};
  static const _opts = ['social', 'email', 'sms', 'ads'];

  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final strategies = dataStore.getStrategies();
    return Stack(children: [
      AppScreen(children: [
        PageHeader(title: 'Marketing Strategies', description: 'Define and manage marketing strategies', action: ElevatedButton(onPressed: () => setState(() => _modalOpen = true), child: const Text('New Strategy'))),
        ...strategies.map((s) => AppCard(title: s.name, trailing: statusBadge(s.status), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(s.description),
          Wrap(spacing: 6, children: s.channels.map((ch) => Chip(label: Text(ch))).toList()),
          TextButton(onPressed: () async {
            final next = s.status == 'active' ? 'draft' : 'active';
            await dataStore.updateStrategy(s.id, {'status': next});
            showToast(context, 'Strategy set to $next');
            setState(() {});
          }, child: Text(s.status == 'active' ? 'Set to Draft' : 'Activate')),
        ]))),
      ]),
      AppModal(isOpen: _modalOpen, onClose: () => setState(() => _modalOpen = false), title: 'New Strategy', child: FormSection(children: [
        TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
        TextField(controller: _desc, decoration: const InputDecoration(labelText: 'Description')),
        Wrap(spacing: 8, children: _opts.map((ch) => FilterChip(label: Text(ch), selected: _channels.contains(ch), onSelected: (v) => setState(() => v ? _channels.add(ch) : _channels.remove(ch)))).toList()),
        ElevatedButton(onPressed: () async {
          await dataStore.addStrategy({'name': _name.text, 'description': _desc.text, 'channels': _channels.toList(), 'status': 'draft'}, context.read<AuthProvider>().user?.name ?? 'System');
          _name.clear(); _desc.clear(); _channels.clear();
          setState(() => _modalOpen = false);
          showToast(context, 'Strategy created');
        }, child: const Text('Create')),
      ])),
    ]);
  }
}
