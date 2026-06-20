import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/EmptyState.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/Toast.dart';
import '../../config/currency.dart';
import '../../config/theme.dart';
import '../../context/AuthContext.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';

class ApproveCampaigns extends StatelessWidget {
  const ApproveCampaigns({super.key});
  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final pending = dataStore.getCampaigns().where((c) => c.status == 'pending' || c.status == 'draft').toList();
    return AppScreen(children: [
      const PageHeader(title: 'Approve Campaign Plans', description: 'Review and approve pending campaign plans'),
      if (pending.isEmpty) const EmptyState(message: 'No pending campaigns', description: 'All campaign plans are approved or active'),
      ...pending.map((c) => AppCard(title: c.name, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(c.description),
        Text('${c.category} · ${formatCurrency(c.budget)}'),
        Text('${c.startDate} — ${c.endDate}'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(onPressed: () async {
              await dataStore.updateCampaign(c.id, {'status': 'approved'}, context.read<AuthProvider>().user?.name ?? 'System');
              showToast(context, '${c.name} approved');
            }, child: const Text('Approve')),
            OutlinedButton(onPressed: () async {
              await dataStore.updateCampaign(c.id, {'status': 'rejected'}, context.read<AuthProvider>().user?.name ?? 'System');
              showToast(context, '${c.name} rejected', type: ToastType.error);
            }, child: const Text('Reject')),
          ],
        ),
      ]))),
    ]);
  }
}
