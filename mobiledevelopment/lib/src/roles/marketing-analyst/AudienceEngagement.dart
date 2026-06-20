import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/StatCard.dart';
import '../../config/theme.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';

class AudienceEngagement extends StatelessWidget {
  const AudienceEngagement({super.key});
  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final campaigns = dataStore.getCampaigns();
    final content = dataStore.getContent();
    final channels = <String, ({int campaigns, int content})>{};
    for (final c in campaigns) {
      for (final ch in c.channels) {
        final cur = channels[ch] ?? (campaigns: 0, content: 0);
        channels[ch] = (campaigns: cur.campaigns + 1, content: cur.content);
      }
    }
    for (final item in content) {
      final camp = campaigns.where((c) => c.id == item.campaignId).firstOrNull;
      if (camp != null) {
        for (final ch in camp.channels) {
          final cur = channels[ch] ?? (campaigns: 0, content: 0);
          channels[ch] = (campaigns: cur.campaigns, content: cur.content + 1);
        }
      }
    }
    final channelEntries = channels.entries.toList();
    return AppScreen(children: [
      const PageHeader(title: 'Audience Engagement', description: 'Engagement breakdown by channel'),
      statGrid(context, [
        StatCard(title: 'Total Campaigns', value: '${campaigns.length}', color: StatGradients.a),
        StatCard(title: 'Content Pieces', value: '${content.length}', color: StatGradients.b),
        StatCard(title: 'Approved Content', value: '${content.where((c) => c.status == 'approved').length}', color: StatGradients.c),
        StatCard(title: 'Active Channels', value: '${channels.length}', color: StatGradients.d),
      ]),
      AppCard(
        title: 'Engagement by Channel',
        child: Column(
          children: [
            for (var i = 0; i < channelEntries.length; i++)
              AppListItem(
                showDivider: i < channelEntries.length - 1,
                title: Text(channelEntries[i].key),
                subtitle: Text('${channelEntries[i].value.campaigns} campaigns · ${channelEntries[i].value.content} content pieces'),
              ),
          ],
        ),
      ),
    ]);
  }
}
