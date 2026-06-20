import 'package:flutter/material.dart';
import '../../styles/theme.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final String? description;
  final Widget? action;
  final IconData icon;

  const EmptyState({
    super.key,
    required this.message,
    this.description,
    this.action,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.brand50, AppColors.diamond100],
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.brand100),
              ),
              child: Icon(icon, size: 30, color: AppColors.brand600),
            ),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.slate700)),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(description!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.slate500, height: 1.45, fontSize: 13)),
            ],
            if (action != null) ...[const SizedBox(height: 20), action!],
          ],
        ),
      ),
    );
  }
}
