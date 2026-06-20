import 'package:flutter/material.dart';
import '../styles/theme.dart';

const themeName = 'Blue Diamond';

class StatGradients {
  static const a = LinearGradient(
    colors: [AppColors.brand100, AppColors.brand200],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const b = LinearGradient(
    colors: [AppColors.brand200, Color(0xFF9BBFE8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const c = LinearGradient(
    colors: [AppColors.diamond100, AppColors.diamond200],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const d = LinearGradient(
    colors: [AppColors.brand50, AppColors.diamond100],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class StatusBadgeStyle {
  final Color background;
  final Color foreground;
  const StatusBadgeStyle({required this.background, required this.foreground});
}

const statusBadges = {
  'active': StatusBadgeStyle(background: AppColors.brand100, foreground: AppColors.brand800),
  'inactive': StatusBadgeStyle(background: Color(0xFFF1F5F9), foreground: AppColors.slate500),
  'pending': StatusBadgeStyle(background: AppColors.diamond100, foreground: AppColors.diamond600),
  'approved': StatusBadgeStyle(background: AppColors.brand200, foreground: AppColors.brand900),
  'draft': StatusBadgeStyle(background: Color(0xFFF1F5F9), foreground: AppColors.slate500),
  'completed': StatusBadgeStyle(background: AppColors.brand100, foreground: AppColors.brand800),
  'rejected': StatusBadgeStyle(background: Color(0xFFFEE2E2), foreground: Color(0xFFB91C1C)),
  'success': StatusBadgeStyle(background: AppColors.brand100, foreground: AppColors.brand800),
  'warning': StatusBadgeStyle(background: AppColors.diamond100, foreground: AppColors.diamond600),
  'excellent': StatusBadgeStyle(background: AppColors.brand200, foreground: AppColors.brand900),
  'good': StatusBadgeStyle(background: AppColors.brand100, foreground: AppColors.brand700),
  'poor': StatusBadgeStyle(background: Color(0xFFFEE2E2), foreground: Color(0xFFB91C1C)),
};

StatusBadgeStyle statusBadgeStyle(String status) =>
    statusBadges[status] ?? StatusBadgeStyle(background: const Color(0xFFF1F5F9), foreground: AppColors.slate500);

Widget statusBadge(String status, {String? label}) {
  final style = statusBadgeStyle(status);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: style.background,
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: style.foreground.withValues(alpha: 0.15)),
    ),
    child: Text(
      label ?? status,
      style: TextStyle(color: style.foreground, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.2),
    ),
  );
}

class ProgressColors {
  static const high = LinearGradient(colors: [AppColors.brand500, AppColors.diamond400]);
  static const medium = LinearGradient(colors: [AppColors.brand500, AppColors.brand600]);
  static const low = LinearGradient(colors: [AppColors.diamond400, AppColors.brand500]);
  static const danger = LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)]);
}

LinearGradient progressColor(double percent) {
  if (percent > 80) return ProgressColors.danger;
  if (percent > 50) return ProgressColors.medium;
  return ProgressColors.high;
}

const textPositive = AppColors.brand600;
const textNegative = Color(0xFFDC2626);
