import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/Toast.dart';
import '../../config/theme.dart';
import '../../context/AuthContext.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';

class ContentSchedule extends StatelessWidget {
  const ContentSchedule({super.key});
  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final user = context.watch<AuthProvider>().user!;
    final content = dataStore.getContentByUser(user.id);
    final scheduled = content.where((c) => c.scheduledDate != null).toList();
    final unscheduled = content.where((c) => c.scheduledDate == null).toList();
    return AppScreen(children: [
      const PageHeader(title: 'Content Schedule', description: 'Schedule content for publishing'),
      const SectionHeader(title: 'Scheduled'),
      ...scheduled.map((item) => AppCard(
        child: AppListItem(
          showDivider: false,
          title: Text(item.title),
          subtitle: Text('${item.type} · ${item.scheduledDate}'),
          trailing: statusBadge(item.status),
        ),
      )),
      const SectionHeader(title: 'Unscheduled'),
      ...unscheduled.map((item) => AppCard(
        child: AppListItem(
          showDivider: false,
          title: Text(item.title),
          subtitle: Text(item.type),
          trailing: ElevatedButton(onPressed: () async {
            final date = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2030), initialDate: DateTime.now());
            if (date != null) {
              await dataStore.updateContent(item.id, {'scheduledDate': date.toIso8601String().split('T').first}, user.name);
              showToast(context, 'Content scheduled');
            }
          }, child: const Text('Schedule')),
        ),
      )),
    ]);
  }
}
