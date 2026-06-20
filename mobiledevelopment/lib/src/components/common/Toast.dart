import 'package:flutter/material.dart';
import '../../styles/theme.dart';

enum ToastType { success, error, info }

void showToast(BuildContext context, String message, {ToastType type = ToastType.success}) {
  final colors = switch (type) {
    ToastType.success => (bg: AppColors.brand50, fg: AppColors.brand800, border: AppColors.brand200, icon: '✓'),
    ToastType.error => (bg: const Color(0xFFFEF2F2), fg: const Color(0xFF991B1B), border: const Color(0xFFFECACA), icon: '!'),
    ToastType.info => (bg: AppColors.diamond100, fg: AppColors.diamond600, border: AppColors.diamond200, icon: 'i'),
  };

  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: colors.bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.border),
      ),
      content: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8), shape: BoxShape.circle),
            child: Text(colors.icon, style: TextStyle(fontWeight: FontWeight.bold, color: colors.fg)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: TextStyle(color: colors.fg, fontWeight: FontWeight.w600))),
        ],
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}
