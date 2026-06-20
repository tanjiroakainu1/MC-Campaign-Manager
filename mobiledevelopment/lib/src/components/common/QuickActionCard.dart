import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../styles/theme.dart';
import '../../utils/responsive.dart';

class QuickActionCard extends StatelessWidget {
  final String to;
  final String label;
  final Gradient? accent;

  const QuickActionCard({super.key, required this.to, required this.label, this.accent});

  @override
  Widget build(BuildContext context) {
    final gradient = accent ?? const LinearGradient(colors: [AppColors.brand100, AppColors.diamond200]);
    return Card(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.go(to),
          child: Padding(
            padding: EdgeInsets.all(context.isMobile ? 14 : 16),
            child: Row(
              children: [
                Container(
                  width: context.isMobile ? 44 : 48,
                  height: context.isMobile ? 44 : 48,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brand500.withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.bolt, color: AppColors.brand700, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate700,
                      fontSize: context.isMobile ? 14 : 15,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: AppColors.slate500.withValues(alpha: 0.7), size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget actionGrid(BuildContext context, List<Widget> children) {
  final cols = context.actionGridColumns();
  return GridView.count(
    crossAxisCount: cols,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    mainAxisSpacing: 12,
    crossAxisSpacing: 12,
    childAspectRatio: context.actionCardAspectRatio(),
    children: children,
  );
}
