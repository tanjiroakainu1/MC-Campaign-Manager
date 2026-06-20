import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/Toast.dart';
import '../../config/currency.dart';
import '../../context/AuthContext.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';
import '../../utils/responsive.dart';

class CreateCampaign extends StatefulWidget {
  const CreateCampaign({super.key});
  @override
  State<CreateCampaign> createState() => _CreateCampaignState();
}

class _CreateCampaignState extends State<CreateCampaign> {
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _budget = TextEditingController();
  String _category = '';
  final _channels = <String>{};
  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now().add(const Duration(days: 30));
  static const _channelOptions = ['social', 'email', 'sms', 'ads'];

  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final categories = dataStore.getCategories();
    if (_category.isEmpty && categories.isNotEmpty) _category = categories.first.name;
    return AppScreen(children: [
      const PageHeader(title: 'Create Campaign', description: 'Plan a new marketing campaign'),
      AppCard(title: 'Campaign Details', child: FormSection(children: [
        TextField(controller: _name, decoration: const InputDecoration(labelText: 'Campaign Name')),
        DropdownButtonFormField(value: _category.isEmpty ? null : _category, decoration: const InputDecoration(labelText: 'Category'), items: categories.map((c) => DropdownMenuItem(value: c.name, child: Text(c.name))).toList(), onChanged: (v) => setState(() => _category = v ?? '')),
        TextField(controller: _desc, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
        TextField(controller: _budget, decoration: InputDecoration(labelText: budgetLabel), keyboardType: TextInputType.number),
        Wrap(spacing: 8, children: _channelOptions.map((ch) => FilterChip(label: Text(ch), selected: _channels.contains(ch), onSelected: (s) => setState(() => s ? _channels.add(ch) : _channels.remove(ch)))).toList()),
        ListTile(contentPadding: EdgeInsets.zero, title: Text('Start: ${_start.toString().split(' ').first}'), trailing: const Icon(Icons.calendar_today), onTap: () async { final d = await showDatePicker(context: context, firstDate: DateTime(2020), lastDate: DateTime(2030), initialDate: _start); if (d != null) setState(() => _start = d); }),
        ListTile(contentPadding: EdgeInsets.zero, title: Text('End: ${_end.toString().split(' ').first}'), trailing: const Icon(Icons.calendar_today), onTap: () async { final d = await showDatePicker(context: context, firstDate: DateTime(2020), lastDate: DateTime(2030), initialDate: _end); if (d != null) setState(() => _end = d); }),
        ElevatedButton(onPressed: () async {
          final user = context.read<AuthProvider>().user!;
          await dataStore.addCampaign({
            'name': _name.text,
            'category': _category,
            'description': _desc.text,
            'budget': double.tryParse(_budget.text) ?? 0,
            'spent': 0,
            'status': 'draft',
            'channels': _channels.toList(),
            'startDate': _start.toIso8601String().split('T').first,
            'endDate': _end.toIso8601String().split('T').first,
            'managerId': user.id,
          }, user.name);
          _name.clear(); _desc.clear(); _budget.clear(); _channels.clear();
          if (mounted) showToast(context, 'Campaign created successfully');
        }, child: const Text('Create Campaign')),
      ])),
    ]);
  }
}
