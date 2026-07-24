import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class GaugePainter extends CustomPainter {
  final double progress;

  const GaugePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const strokeWidth = 6.0;

    final bgPaint = Paint()
      ..color = AppColors.surfaceContainerHigh
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708,
      6.28319 * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
