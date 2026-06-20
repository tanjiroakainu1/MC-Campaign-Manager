import 'package:flutter/material.dart';
import '../../styles/theme.dart';
import '../../utils/chartData.dart';
import '../../utils/responsive.dart';

class AppAreaChart extends StatelessWidget {
  final List<ChartPoint> data;
  final double? height;
  final String Function(double)? formatValue;

  const AppAreaChart({super.key, required this.data, this.height, this.formatValue});

  @override
  Widget build(BuildContext context) {
    final h = height ?? (context.isMobile ? 140.0 : 160.0);
    if (data.isEmpty) {
      return SizedBox(height: h, child: const Center(child: Text('No trend data')));
    }

    final minVal = data.map((d) => d.value).reduce((a, b) => a < b ? a : b);
    final maxVal = data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
    final fmt = formatValue ?? (v) => v.toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: h,
          width: double.infinity,
          child: CustomPaint(
            painter: _AreaPainter(data),
            size: Size.infinite,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text('Min: ${fmt(minVal)}', style: const TextStyle(fontSize: 10, color: AppColors.slate500), overflow: TextOverflow.ellipsis)),
            Flexible(child: Text('Peak: ${fmt(maxVal)}', style: const TextStyle(fontSize: 10, color: AppColors.slate500), overflow: TextOverflow.ellipsis)),
          ],
        ),
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: data.map((d) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(d.label, style: const TextStyle(fontSize: 10, color: AppColors.slate500)),
                )).toList(),
          ),
        ),
      ],
    );
  }
}

class _AreaPainter extends CustomPainter {
  final List<ChartPoint> data;
  _AreaPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final maxVal = data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
    if (maxVal <= 0) return;
    final stepX = size.width / (data.length - 1).clamp(1, 999);
    final points = <Offset>[];
    for (var i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - 8 - (data[i].value / maxVal) * (size.height - 24);
      points.add(Offset(x, y));
    }
    final path = Path()..moveTo(points.first.dx, size.height - 8);
    for (final p in points) {
      path.lineTo(p.dx, p.dy);
    }
    path.lineTo(points.last.dx, size.height - 8);
    path.close();
    canvas.drawPath(path, Paint()..color = AppColors.brand100.withValues(alpha: 0.8));
    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      line.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(line, Paint()..color = AppColors.brand600..strokeWidth = 2..style = PaintingStyle.stroke);
    for (final p in points) {
      canvas.drawCircle(p, 4, Paint()..color = AppColors.brand600);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
