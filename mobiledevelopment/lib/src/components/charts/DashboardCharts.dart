import 'package:flutter/material.dart';
import '../../config/currency.dart';
import '../../types/index.dart';
import '../../utils/chartData.dart';
import '../../utils/responsive.dart';
import 'AreaChart.dart';
import 'BarChart.dart';
import 'ChartCard.dart';
import 'DonutChart.dart';
import 'GaugeChart.dart';

enum DashboardChartVariant { analyst, performance, manager }

class DashboardCharts extends StatelessWidget {
  final List<Campaign> campaigns;
  final DashboardChartVariant variant;

  const DashboardCharts({super.key, required this.campaigns, required this.variant});

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case DashboardChartVariant.analyst:
        return _analyst(context);
      case DashboardChartVariant.performance:
        return _performance(context);
      case DashboardChartVariant.manager:
        return _manager(context);
    }
  }

  Widget _wrap(BuildContext context, List<Widget> charts) {
    return ResponsiveChartGrid(children: charts);
  }

  Widget _analyst(BuildContext context) {
    return _wrap(context, [
      ChartCard(title: 'Campaign Spend', child: AppBarChart(data: getCampaignSpendBars(campaigns).map((b) => BarChartData(label: b.label, value: b.value, max: b.max)).toList(), formatValue: (v) => formatCurrency(v))),
      ChartCard(title: 'Channel Mix', child: AppDonutChart(segments: segmentsFromChartData(getChannelSegments(campaigns)), centerLabel: 'Channels')),
      ChartCard(title: 'Spend Trend', child: AppAreaChart(data: getSpendTrend(campaigns), formatValue: (v) => formatCurrency(v))),
      ChartCard(title: 'ROI Pulse', child: AppBarChart(data: getRoiBars(campaigns).map((p) => BarChartData(label: p.label, value: p.value)).toList(), horizontal: true, formatValue: (v) => '${v.toStringAsFixed(0)}%')),
      ChartCard(title: 'Budget Utilization', child: Center(child: AppGaugeChart(value: getBudgetUtilization(campaigns).toDouble(), label: 'Budget Used'))),
    ]);
  }

  Widget _performance(BuildContext context) {
    return _wrap(context, [
      ChartCard(title: 'Reach', child: AppBarChart(data: getReachBars(campaigns).map((p) => BarChartData(label: p.label, value: p.value)).toList())),
      ChartCard(title: 'Status Breakdown', child: AppDonutChart(segments: segmentsFromChartData(getStatusSegments(campaigns)), centerLabel: 'Status')),
      ChartCard(title: 'Spend Velocity', child: AppAreaChart(data: getSpendTrend(campaigns), formatValue: (v) => formatCurrency(v))),
      ChartCard(title: 'ROI Radar', child: AppBarChart(data: getRoiBars(campaigns).map((p) => BarChartData(label: p.label, value: p.value)).toList(), horizontal: true, formatValue: (v) => '${v.toStringAsFixed(0)}%')),
      ChartCard(title: 'Avg ROI', child: Center(child: AppGaugeChart(value: getAvgRoi(campaigns).toDouble(), label: 'Average ROI', suffix: '%'))),
      ChartCard(title: 'Channel Dominance', child: AppDonutChart(segments: segmentsFromChartData(getChannelSegments(campaigns)), centerLabel: 'Mix')),
    ]);
  }

  Widget _manager(BuildContext context) {
    return _wrap(context, [
      ChartCard(title: 'Budget Burn', child: AppBarChart(data: getCampaignSpendBars(campaigns).map((b) => BarChartData(label: b.label, value: b.value, max: b.max)).toList(), formatValue: (v) => formatCurrency(v))),
      ChartCard(title: 'Campaign Status', child: AppDonutChart(segments: segmentsFromChartData(getStatusSegments(campaigns)), centerLabel: 'Status')),
      ChartCard(title: 'Spend Timeline', child: AppAreaChart(data: getSpendTrend(campaigns), formatValue: (v) => formatCurrency(v))),
      ChartCard(title: 'Channel Allocation', child: AppDonutChart(segments: segmentsFromChartData(getChannelSegments(campaigns)), centerLabel: 'Channels')),
      ChartCard(title: 'Budget Gauge', child: Center(child: AppGaugeChart(value: getBudgetUtilization(campaigns).toDouble(), label: 'Utilization'))),
    ]);
  }
}
