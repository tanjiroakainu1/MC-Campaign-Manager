import 'package:flutter/material.dart';
import '../data/dataStore.dart';
import '../types/index.dart';

class ChartPoint {
  final String label;
  final double value;
  const ChartPoint({required this.label, required this.value});
}

class ChartSegment {
  final String label;
  final double value;
  final String color;
  const ChartSegment({required this.label, required this.value, required this.color});
}

class BarChartItem {
  final String label;
  final double value;
  final double max;
  const BarChartItem({required this.label, required this.value, required this.max});
}

const chartColors = ['#2b8fff', '#38c8ff', '#1470eb', '#7ddcff', '#0cb0f5', '#1048a3', '#0d58c7', '#0090d4'];

Color hexToColor(String hex) {
  final h = hex.replaceFirst('#', '');
  return Color(int.parse('FF$h', radix: 16));
}

List<BarChartItem> getCampaignSpendBars(List<Campaign> campaigns) {
  return campaigns.map((c) => BarChartItem(
        label: c.name.length > 14 ? '${c.name.substring(0, 14)}…' : c.name,
        value: c.spent,
        max: c.budget > 0 ? c.budget : (c.spent > 0 ? c.spent : 1),
      )).toList();
}

List<ChartSegment> getChannelSegments(List<Campaign> campaigns) {
  final map = <String, int>{};
  for (final c in campaigns) {
    for (final ch in c.channels) {
      map[ch] = (map[ch] ?? 0) + 1;
    }
  }
  return map.entries.toList().asMap().entries.map((e) => ChartSegment(
        label: e.value.key,
        value: e.value.value.toDouble(),
        color: chartColors[e.key % chartColors.length],
      )).toList();
}

List<ChartSegment> getStatusSegments(List<Campaign> campaigns) {
  final map = <String, int>{};
  for (final c in campaigns) {
    map[c.status] = (map[c.status] ?? 0) + 1;
  }
  return map.entries.toList().asMap().entries.map((e) => ChartSegment(
        label: e.value.key,
        value: e.value.value.toDouble(),
        color: chartColors[e.key % chartColors.length],
      )).toList();
}

List<ChartPoint> getRoiBars(List<Campaign> campaigns) {
  return campaigns.map((c) {
    final roi = dataStore.computeCampaignROI(c).roi;
    return ChartPoint(
      label: c.name.length > 10 ? '${c.name.substring(0, 10)}…' : c.name,
      value: roi.toDouble(),
    );
  }).toList();
}

List<ChartPoint> getSpendTrend(List<Campaign> campaigns) {
  final map = <String, double>{};
  for (final c in campaigns) {
    final month = _monthShort(c.startDate);
    map[month] = (map[month] ?? 0) + c.spent;
  }
  if (map.isEmpty) {
    final total = campaigns.fold<double>(0, (s, c) => s + c.spent);
    return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'].asMap().entries.map((e) => ChartPoint(label: e.value, value: (total * (0.08 + e.key * 0.04)).roundToDouble())).toList();
  }
  return map.entries.map((e) => ChartPoint(label: e.key, value: e.value)).toList();
}

List<ChartPoint> getReachBars(List<Campaign> campaigns) {
  return campaigns.map((c) {
    final m = dataStore.getCampaignMetrics(c.id);
    return ChartPoint(
      label: c.name.length > 10 ? '${c.name.substring(0, 10)}…' : c.name,
      value: (m?['reach'] as num?)?.toDouble() ?? 0,
    );
  }).toList();
}

int getBudgetUtilization(List<Campaign> campaigns) {
  final budget = campaigns.fold<double>(0, (s, c) => s + c.budget);
  final spent = campaigns.fold<double>(0, (s, c) => s + c.spent);
  return budget > 0 ? ((spent / budget) * 100).round() : 0;
}

int getAvgRoi(List<Campaign> campaigns) {
  if (campaigns.isEmpty) return 0;
  final total = campaigns.fold<int>(0, (s, c) => s + dataStore.computeCampaignROI(c).roi);
  return (total / campaigns.length).round();
}

String _monthShort(String date) {
  try {
    final d = DateTime.parse(date);
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[d.month - 1];
  } catch (_) {
    return 'N/A';
  }
}
