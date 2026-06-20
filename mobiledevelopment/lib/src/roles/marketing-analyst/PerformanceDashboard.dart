import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/charts/DashboardCharts.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/PageHeader.dart';
import '../../components/common/StatCard.dart';
import '../../config/currency.dart';
import '../../config/theme.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';

class PerformanceDashboard extends StatefulWidget {
  const PerformanceDashboard({super.key});
  @override
  State<PerformanceDashboard> createState() => _PerformanceDashboardState();
}

class _PerformanceDashboardState extends State<PerformanceDashboard> {
  bool _editMode = false;
  final _widgets = {
    'charts': true,
    'spend': true,
    'content': true,
    'pending': true,
  };

  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final campaigns = dataStore.getCampaigns();
    final content = dataStore.getContent();
    final active = campaigns.where((c) => c.status == 'active').length;
    final spent = campaigns.fold<double>(0, (s, c) => s + c.spent);
    final pending = content.where((c) => c.status == 'pending').length;
    return AppScreen(children: [
      PageHeader(title: 'Performance Dashboard', description: 'Customizable analytics dashboard', action: TextButton(onPressed: () => setState(() => _editMode = !_editMode), child: Text(_editMode ? 'Done' : 'Customize Dashboard'))),
      statGrid(context, [
        StatCard(title: 'Active Campaigns', value: '$active', color: StatGradients.a),
        StatCard(title: 'Total Spent', value: formatCurrency(spent), color: StatGradients.b),
        StatCard(title: 'Content Items', value: '${content.length}', color: StatGradients.c),
        StatCard(title: 'Pending Reviews', value: '$pending', color: StatGradients.d),
      ]),
      if (_editMode) AppCard(title: 'Widget Visibility', child: Column(children: _widgets.keys.map((k) => SwitchListTile(title: Text('Show $k'), value: _widgets[k]!, onChanged: (v) => setState(() => _widgets[k] = v))).toList())),
      if (_widgets['charts']!) DashboardCharts(campaigns: campaigns, variant: DashboardChartVariant.performance),
      if (_widgets['spend']!) AppCard(
        child: AppListItem(
          showDivider: false,
          title: const Text('Spend Summary'),
          subtitle: Text('Total spent across ${campaigns.length} campaigns: ${formatCurrency(spent)}'),
        ),
      ),
      if (_widgets['content']!) AppCard(
        child: AppListItem(
          showDivider: false,
          title: const Text('Content Pipeline'),
          subtitle: Text('${content.length} items · $pending pending review'),
        ),
      ),
      if (_widgets['pending']!) AppCard(
        child: AppListItem(
          showDivider: false,
          title: const Text('Pending Reviews'),
          subtitle: Text('$pending content pieces awaiting approval'),
        ),
      ),
    ]);
  }
}
