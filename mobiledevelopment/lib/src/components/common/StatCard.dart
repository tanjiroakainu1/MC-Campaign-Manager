import 'package:flutter/material.dart';
import '../../config/theme.dart' as app_theme;
import '../../styles/theme.dart';
import '../../utils/responsive.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final int? change;
  final Widget? icon;
  final Gradient? color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.change,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = color ?? app_theme.StatGradients.a;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.brand600.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(context.isMobile ? 14 : 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: context.isMobile ? 10 : 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.slate500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: context.isMobile ? 24 : 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.slate900,
                    ),
                  ),
                  if (change != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      '${change! >= 0 ? '↑' : '↓'} ${change!.abs()}% from last period',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: change! >= 0 ? app_theme.textPositive : app_theme.textNegative,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (icon != null)
              Container(
                padding: EdgeInsets.all(context.isMobile ? 10 : 12),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.brand500.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: icon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget statGrid(BuildContext context, List<Widget> children) {
  final cols = context.statGridColumns();
  return LayoutBuilder(
    builder: (context, constraints) {
      return GridView.count(
        crossAxisCount: cols,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: context.statCardAspectRatio(),
        children: children,
      );
    },
  );
}
