import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/Toast.dart';
import '../../config/roles.dart';
import '../../config/theme.dart';
import '../../context/AuthContext.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';
import '../../data/userStore.dart';
import '../../types/index.dart';

class TaskAssignment extends StatefulWidget {
  const TaskAssignment({super.key});
  @override
  State<TaskAssignment> createState() => _TaskAssignmentState();
}

class _TaskAssignmentState extends State<TaskAssignment> {
  bool _showForm = false;
  final _title = TextEditingController();
  String _campaignId = '';
  String _assigneeId = '';
  DateTime _due = DateTime.now().add(const Duration(days: 7));

  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final campaigns = dataStore.getCampaigns();
    final creators = userStore.getAllUsers().where((u) => u.role == UserRoles.contentCreator).toList();
    final tasks = dataStore.getTasks();
    if (_campaignId.isEmpty && campaigns.isNotEmpty) _campaignId = campaigns.first.id;
    if (_assigneeId.isEmpty && creators.isNotEmpty) _assigneeId = creators.first.id;
    return AppScreen(children: [
      PageHeader(title: 'Task Assignment', description: 'Assign work to content creators', action: ElevatedButton(onPressed: () => setState(() => _showForm = !_showForm), child: Text(_showForm ? 'Cancel' : 'Assign New Task'))),
      if (_showForm) AppCard(title: 'New Task', child: FormSection(children: [
        TextField(controller: _title, decoration: const InputDecoration(labelText: 'Task Title')),
        DropdownButtonFormField(value: _campaignId, decoration: const InputDecoration(labelText: 'Campaign'), items: campaigns.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(), onChanged: (v) => setState(() => _campaignId = v!)),
        DropdownButtonFormField(value: _assigneeId, decoration: const InputDecoration(labelText: 'Assignee'), items: creators.map((u) => DropdownMenuItem(value: u.id, child: Text(u.name))).toList(), onChanged: (v) => setState(() => _assigneeId = v!)),
        ListTile(contentPadding: EdgeInsets.zero, title: Text('Due: ${_due.toString().split(' ').first}'), onTap: () async { final d = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2030), initialDate: _due); if (d != null) setState(() => _due = d); }),
        ElevatedButton(onPressed: () async {
          await dataStore.addTask({'title': _title.text, 'campaignId': _campaignId, 'assigneeId': _assigneeId, 'dueDate': _due.toIso8601String().split('T').first, 'status': 'todo'}, context.read<AuthProvider>().user?.name ?? 'System');
          _title.clear(); setState(() => _showForm = false);
          showToast(context, 'Task assigned');
        }, child: const Text('Create Task')),
      ])),
      ...tasks.map((t) {
        final campaign = campaigns.where((c) => c.id == t.campaignId).firstOrNull;
        final assignee = userStore.getUserById(t.assigneeId);
        return AppCard(
          child: AppListItem(
            showDivider: false,
            title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${campaign?.name ?? 'Campaign'} · ${assignee?.name ?? 'Assignee'} · Due ${t.dueDate}'),
            trailing: DropdownButton<String>(
              value: t.status,
              items: const [DropdownMenuItem(value: 'todo', child: Text('To Do')), DropdownMenuItem(value: 'in-progress', child: Text('In Progress')), DropdownMenuItem(value: 'done', child: Text('Done'))],
              onChanged: (v) async { if (v != null) { await dataStore.updateTask(t.id, {'status': v}); showToast(context, 'Task updated'); setState(() {}); } },
            ),
          ),
        );
      }),
    ]);
  }
}
