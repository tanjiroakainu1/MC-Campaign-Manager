import 'package:flutter/material.dart';
import '../../styles/theme.dart';
import '../../utils/responsive.dart';

class AppBarChart extends StatelessWidget {
  final List<BarChartData> data;
  final String Function(double)? formatValue;
  final bool horizontal;

  const AppBarChart({super.key, required this.data, this.formatValue, this.horizontal = false});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox(height: 120, child: Center(child: Text('No data available', style: TextStyle(color: AppColors.slate500))));
    }
    if (horizontal) return _horizontal(context);
    return _vertical(context);
  }

  Widget _vertical(BuildContext context) {
    final maxVal = data.map((d) => d.max ?? d.value).reduce((a, b) => a > b ? a : b);
    final barHeight = context.isMobile ? 150.0 : 180.0;

    return SizedBox(
      height: barHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: data.map((item) {
            final heightFactor = maxVal > 0 ? item.value / maxVal : 0.0;
            return SizedBox(
              width: context.isMobile ? 56 : 64,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      formatValue?.call(item.value) ?? item.value.toStringAsFixed(0),
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: FractionallySizedBox(
                        heightFactor: heightFactor.clamp(0.05, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [AppColors.brand600, AppColors.diamond400],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 9, color: AppColors.slate500),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _horizontal(BuildContext context) {
    final maxVal = data.map((d) => d.value).fold<double>(0, (a, b) => a > b ? a : b);
    final labelWidth = context.isMobile ? 56.0 : 70.0;
    return Column(
      children: data.map((item) {
        final widthFactor = maxVal > 0 ? item.value / maxVal : 0.0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              SizedBox(
                width: labelWidth,
                child: Text(item.label, style: const TextStyle(fontSize: 11, color: AppColors.slate500), overflow: TextOverflow.ellipsis),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(height: 20, decoration: BoxDecoration(color: AppColors.brand50, borderRadius: BorderRadius.circular(6))),
                    FractionallySizedBox(
                      widthFactor: widthFactor.clamp(0.05, 1.0),
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [AppColors.brand500, AppColors.diamond400]),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(formatValue?.call(item.value) ?? item.value.toStringAsFixed(0), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class BarChartData {
  final String label;
  final double value;
  final double? max;
  const BarChartData({required this.label, required this.value, this.max});
}
