import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/Toast.dart';
import '../../config/theme.dart';
import '../../context/AuthContext.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';

class SubmitApproval extends StatefulWidget {
  const SubmitApproval({super.key});
  @override
  State<SubmitApproval> createState() => _SubmitApprovalState();
}

class _SubmitApprovalState extends State<SubmitApproval> {
  final _selected = <String>{};

  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final user = context.watch<AuthProvider>().user!;
    final content = dataStore.getContentByUser(user.id);
    final drafts = content.where((c) => c.status == 'draft').toList();
    final pending = content.where((c) => c.status == 'pending').toList();
    return AppScreen(children: [
      PageHeader(
        title: 'Submit Approval',
        description: 'Submit drafts for manager review',
        action: _selected.isEmpty ? null : ElevatedButton(onPressed: () async {
          for (final id in _selected) {
            await dataStore.updateContent(id, {'status': 'pending'}, user.name);
          }
          showToast(context, '${_selected.length} item(s) submitted');
          setState(() => _selected.clear());
        }, child: Text('Submit ${_selected.length} Selected')),
      ),
      const SectionHeader(title: 'Drafts'),
      ...drafts.map((item) => CheckboxListTile(
        value: _selected.contains(item.id),
        onChanged: (v) => setState(() => v == true ? _selected.add(item.id) : _selected.remove(item.id)),
        title: Text(item.title),
        subtitle: Text(item.type),
      )),
      const SectionHeader(title: 'Pending Review'),
      ...pending.map((item) => AppCard(
        child: AppListItem(
          showDivider: false,
          title: Text(item.title),
          trailing: statusBadge(item.status),
        ),
      )),
    ]);
  }
}
