import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/EmptyState.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/StatCard.dart';
import '../../config/currency.dart';
import '../../config/theme.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';

class CampaignMetrics extends StatefulWidget {
  const CampaignMetrics({super.key});
  @override
  State<CampaignMetrics> createState() => _CampaignMetricsState();
}

class _CampaignMetricsState extends State<CampaignMetrics> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final campaigns = dataStore.getCampaigns();
    _selectedId ??= campaigns.firstOrNull?.id;
    final campaign = campaigns.where((c) => c.id == _selectedId).firstOrNull;
    final metrics = campaign != null ? dataStore.getCampaignMetrics(campaign.id) : null;
    return AppScreen(children: [
      const PageHeader(title: 'Campaign Metrics', description: 'Detailed metrics for each campaign'),
      DropdownButtonFormField(value: _selectedId, decoration: const InputDecoration(labelText: 'Campaign'), items: campaigns.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(), onChanged: (v) => setState(() => _selectedId = v)),
      if (metrics == null || campaign == null) const EmptyState(message: 'No metrics available') else ...[
        statGrid(context, [
          StatCard(title: 'Reach', value: '${metrics['reach']}', color: StatGradients.a),
          StatCard(title: 'Impressions', value: '${metrics['impressions']}', color: StatGradients.b),
          StatCard(title: 'Clicks', value: '${metrics['clicks']}', color: StatGradients.c),
          StatCard(title: 'Conversions', value: '${metrics['conversions']}', color: StatGradients.d),
        ]),
        AppCard(title: campaign.name, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('CTR: ${metrics['ctr']}% · Conversion Rate: ${metrics['conversionRate']}%'),
          Text('CPC: ${formatCurrencyDecimal(metrics['cpc'] as num)} · CPM: ${formatCurrencyDecimal(metrics['cpm'] as num)}'),
          const Divider(),
          Text('Category: ${campaign.category} · Status: ${campaign.status}'),
          Text('Budget: ${formatCurrency(campaign.budget)} · Spent: ${formatCurrency(campaign.spent)}'),
        ])),
      ],
    ]);
  }
}
