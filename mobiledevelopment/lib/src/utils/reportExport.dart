import 'package:flutter/material.dart';
import '../config/currency.dart';
import '../data/dataStore.dart';
import '../types/index.dart';
import '../components/common/Toast.dart';

void downloadCampaignExcel(BuildContext context, List<Campaign> campaigns, {String label = 'campaign-report'}) {
  final date = DateTime.now().toIso8601String().split('T').first;
  showToast(context, 'Export ready: $label-$date.csv (${campaigns.length} campaigns). Download is simulated on mobile.', type: ToastType.info);
}

void downloadCampaignPDF(BuildContext context, List<Campaign> campaigns, String title) {
  final date = DateTime.now().toString().split('.').first;
  final summary = campaigns.map((c) {
    final metrics = dataStore.getCampaignMetrics(c.id);
      return '${c.name}: ${formatCurrency(c.budget)} budget, ${metrics?['reach'] ?? 0} reach';
  }).join('; ');
  showToast(context, '$title — $date — $summary', type: ToastType.info);
}
