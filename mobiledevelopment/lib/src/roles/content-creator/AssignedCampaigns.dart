import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/EmptyState.dart';
import '../../components/common/PageHeader.dart';
import '../../config/theme.dart';
import '../../context/AuthContext.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';

class AssignedCampaigns extends StatelessWidget {
  const AssignedCampaigns({super.key});
  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final user = context.watch<AuthProvider>().user!;
    final myContent = dataStore.getContentByUser(user.id);
    final campaignIds = myContent.map((c) => c.campaignId).toSet();
    final campaigns = dataStore.getCampaigns().where((c) => campaignIds.contains(c.id)).toList();
    if (campaigns.isEmpty) {
      return const AppScreen(children: [
        PageHeader(title: 'Assigned Campaigns', description: 'Campaigns linked to your content'),
        EmptyState(message: 'No assigned campaigns', description: 'Create content linked to a campaign first'),
      ]);
    }
    return AppScreen(children: [
      const PageHeader(title: 'Assigned Campaigns', description: 'Campaigns you are contributing content to'),
      ...campaigns.map((c) {
        final items = myContent.where((x) => x.campaignId == c.id).toList();
        return AppCard(title: c.name, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(c.description),
          Wrap(spacing: 8, children: [statusBadge(c.status), Chip(label: Text(c.category))]),
          Text('Channels: ${c.channels.join(', ')}'),
          const SectionHeader(title: 'Your Content'),
          ...items.asMap().entries.map((entry) => AppListItem(
            showDivider: entry.key < items.length - 1,
            title: Text(entry.value.title),
            trailing: statusBadge(entry.value.status),
          )),
        ]));
      }),
    ]);
  }
}
