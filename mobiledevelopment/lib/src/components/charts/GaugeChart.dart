import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../styles/theme.dart';

class AppGaugeChart extends StatelessWidget {
  final double value;
  final String label;
  final String suffix;
  final double size;

  const AppGaugeChart({super.key, required this.value, required this.label, this.suffix = '%', this.size = 120});

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0, 100);
    final color = clamped >= 75 ? AppColors.brand600 : clamped >= 45 ? AppColors.diamond500 : AppColors.slate500;
    return Column(
      children: [
        SizedBox(
          width: size,
          height: size * 0.6,
          child: CustomPaint(
            painter: _GaugePainter(clamped.toDouble(), color),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: size * 0.15),
                child: Text('${clamped.toStringAsFixed(0)}$suffix', style: TextStyle(fontSize: size * 0.2, fontWeight: FontWeight.bold, color: color)),
              ),
            ),
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.slate500, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final Color color;
  _GaugePainter(this.value, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    final bg = Paint()..color = AppColors.brand50..style = PaintingStyle.stroke..strokeWidth = 12..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, math.pi, math.pi, false, bg);
    final fg = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 12..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, math.pi, math.pi * (value / 100), false, fg);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
