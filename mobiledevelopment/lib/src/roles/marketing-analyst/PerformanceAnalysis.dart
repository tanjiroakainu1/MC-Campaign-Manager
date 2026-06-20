import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/common/AppUI.dart';
import '../../components/common/PageHeader.dart';
import '../../config/theme.dart';
import '../../context/BootstrapContext.dart';
import '../../data/dataStore.dart';
import '../../styles/theme.dart';

class PerformanceAnalysis extends StatefulWidget {
  const PerformanceAnalysis({super.key});
  @override
  State<PerformanceAnalysis> createState() => _PerformanceAnalysisState();
}

class _PerformanceAnalysisState extends State<PerformanceAnalysis> {
  String _period = '30';

  @override
  Widget build(BuildContext context) {
    context.watch<BootstrapProvider>();
    final campaigns = dataStore.getCampaigns();
    return AppScreen(children: [
      const PageHeader(title: 'Performance Analysis', description: 'Analyze campaign performance scores'),
      Wrap(spacing: 8, children: ['7','30','90'].map((p) => ChoiceChip(label: Text('$p days'), selected: _period == p, onSelected: (_) => setState(() => _period = p))).toList()),
      ...campaigns.map((c) {
        final score = dataStore.computePerformanceScore(c.id);
        final util = c.budget > 0 ? c.spent / c.budget * 100 : 0;
        final trend = util > 50 ? '↑' : '↓';
        return AppCard(title: c.name, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${c.category} · ${c.channels.join(', ')}'),
          const SizedBox(height: 8),
          Text('Performance Score: $score/100'),
          ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: score / 100, minHeight: 8, color: score >= 70 ? AppColors.brand600 : score >= 40 ? AppColors.diamond500 : Colors.red)),
          Text('Budget utilization trend: $trend ${util.toStringAsFixed(0)}%'),
        ]));
      }),
    ]);
  }
}
