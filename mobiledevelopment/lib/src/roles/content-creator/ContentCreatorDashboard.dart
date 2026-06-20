import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/EmptyState.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/QuickActionCard.dart';
import '../../components/common/StatCard.dart';
import '../../config/navigation.dart';
import '../../config/roles.dart';
import '../../config/theme.dart';
import '../../context/AuthContext.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';

class ContentCreatorDashboard extends StatelessWidget {
  const ContentCreatorDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final user = context.watch<AuthProvider>().user!;
    final content = dataStore.getContentByUser(user.id);
    final campaigns = dataStore.getCampaigns();
    String campaignName(String id) => campaigns.where((c) => c.id == id).firstOrNull?.name ?? id;

    return AppScreen(
      children: [
        const PageHeader(title: 'Content Creator Dashboard', description: 'Your content workspace and assignments'),
        statGrid(context, [
          StatCard(title: 'My Content', value: '${content.length}', color: StatGradients.a),
          StatCard(title: 'Approved', value: '${content.where((c) => c.status == 'approved').length}', color: StatGradients.b),
          StatCard(title: 'Pending Review', value: '${content.where((c) => c.status == 'pending').length}', color: StatGradients.c),
          StatCard(title: 'Drafts', value: '${content.where((c) => c.status == 'draft').length}', color: StatGradients.d),
        ]),
        const SectionHeader(title: 'Content Tools'),
        actionGrid(context, contentCreatorNav.map((item) => QuickActionCard(to: item.path, label: item.label, accent: roleActionAccent[UserRoles.contentCreator])).toList()),
        AppCard(
          title: 'Recent Content',
          child: content.isEmpty
              ? const EmptyState(message: 'No content yet', description: 'Create your first content piece', icon: Icons.edit_note)
              : Column(
                  children: [
                    for (var i = 0; i < content.take(6).length; i++)
                      AppListItem(
                        showDivider: i < content.take(6).length - 1,
                        title: Text(content[i].title, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('${campaignName(content[i].campaignId)} · ${content[i].type}'),
                        trailing: statusBadge(content[i].status),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
