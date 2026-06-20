import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/StatCard.dart';
import '../../config/theme.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';

class PerformanceMonitor extends StatelessWidget {
  const PerformanceMonitor({super.key});
  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final active = dataStore.getCampaigns().where((c) => c.status == 'active').toList();
    var reach = 0, conversions = 0, channels = 0;
    for (final c in active) {
      final m = dataStore.getCampaignMetrics(c.id);
      reach += (m?['reach'] as int?) ?? 0;
      conversions += (m?['conversions'] as int?) ?? 0;
      channels += c.channels.length;
    }
    return AppScreen(children: [
      const PageHeader(title: 'Performance Monitor', description: 'Track live campaign performance metrics'),
      statGrid(context, [
        StatCard(title: 'Total Reach', value: '$reach', color: StatGradients.a),
        StatCard(title: 'Active Campaigns', value: '${active.length}', color: StatGradients.b),
        StatCard(title: 'Total Channels', value: '$channels', color: StatGradients.c),
        StatCard(title: 'Conversions', value: '$conversions', color: StatGradients.d),
      ]),
      ...active.map((c) {
        final m = dataStore.getCampaignMetrics(c.id)!;
        final engagement = (c.channels.length * 2.1).toStringAsFixed(1);
        return AppCard(
          child: AppListItem(
            showDivider: false,
            title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Reach: ${m['reach']} · Engagement: $engagement% · CTR: ${m['ctr']}% · Conversions: ${m['conversions']}'),
          ),
        );
      }),
    ]);
  }
}
