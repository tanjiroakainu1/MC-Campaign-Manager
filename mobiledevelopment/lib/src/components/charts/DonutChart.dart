import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../utils/chartData.dart';
import '../../utils/responsive.dart';

class DonutSegment {
  final String label;
  final double value;
  final Color color;
  const DonutSegment({required this.label, required this.value, required this.color});
}

class AppDonutChart extends StatelessWidget {
  final List<DonutSegment> segments;
  final String? centerLabel;
  final String? centerValue;
  final double? size;

  const AppDonutChart({super.key, required this.segments, this.centerLabel, this.centerValue, this.size});

  @override
  Widget build(BuildContext context) {
    if (segments.isEmpty) {
      return const SizedBox(height: 140, child: Center(child: Text('No data')));
    }

    final chartSize = size ?? (context.isMobile ? 120.0 : 140.0);
    final legend = _legend();

    final chart = SizedBox(
      width: chartSize,
      height: chartSize,
      child: CustomPaint(
        painter: _DonutPainter(segments),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (centerValue != null) Text(centerValue!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: context.isMobile ? 16 : 18)),
              if (centerLabel != null) Text(centerLabel!, style: const TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ),
    );

    if (context.stackChartLegend) {
      return Column(
        children: [
          Center(child: chart),
          const SizedBox(height: 16),
          legend,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        chart,
        const SizedBox(width: 16),
        Expanded(child: legend),
      ],
    );
  }

  Widget _legend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: segments.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: s.color, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(child: Text(s.label, style: const TextStyle(fontSize: 12))),
                Text(s.value.toStringAsFixed(0), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          )).toList(),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<DonutSegment> segments;
  _DonutPainter(this.segments);

  @override
  void paint(Canvas canvas, Size size) {
    final total = segments.fold<double>(0, (s, e) => s + e.value);
    if (total <= 0) return;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    var start = -math.pi / 2;
    for (final seg in segments) {
      final sweep = (seg.value / total) * 2 * math.pi;
      final paint = Paint()..color = seg.color..style = PaintingStyle.stroke..strokeWidth = size.width * 0.18;
      canvas.drawArc(rect.deflate(size.width * 0.09), start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

List<DonutSegment> segmentsFromChartData(List<ChartSegment> data) =>
    data.map((s) => DonutSegment(label: s.label, value: s.value, color: hexToColor(s.color))).toList();
