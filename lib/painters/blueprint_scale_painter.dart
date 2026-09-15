import 'package:flutter/material.dart';

class BlueprintScalePainter extends CustomPainter {
  final int ratioDenom; // e.g. 50 for 1:50, 100 for 1:100

  const BlueprintScalePainter({required this.ratioDenom});

  @override
  void paint(Canvas canvas, Size size) {
    // Drafting blueprint grid background
    final bgPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.fill;
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(16));
    canvas.drawRRect(rrect, bgPaint);

    final linePaint = Paint()
      ..color = const Color(0xFF0EA5E9).withValues(alpha: 0.3)
      ..strokeWidth = 1.0;

    // Grid lines
    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Architectural ruler bar
    final rulerRect = Rect.fromLTWH(16, size.height * 0.42, size.width - 32, 44);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rulerRect, const Radius.circular(8)),
      Paint()..color = const Color(0xFF1E293B),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rulerRect, const Radius.circular(8)),
      Paint()..color = const Color(0xFF0EA5E9)..style = PaintingStyle.stroke..strokeWidth = 1.5,
    );

    // Ruler tick marks
    final tickPaint = Paint()..strokeCap = StrokeCap.round;
    const double tickStep = 18.0;
    for (double x = rulerRect.left + 10; x < rulerRect.right - 10; x += tickStep) {
      final isMajor = ((x - rulerRect.left) ~/ tickStep) % 5 == 0;
      tickPaint
        ..color = isMajor ? const Color(0xFF38BDF8) : Colors.white30
        ..strokeWidth = isMajor ? 2.0 : 1.0;

      final double tickHeight = isMajor ? 16.0 : 8.0;
      canvas.drawLine(Offset(x, rulerRect.top), Offset(x, rulerRect.top + tickHeight), tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant BlueprintScalePainter oldDelegate) {
    return oldDelegate.ratioDenom != ratioDenom;
  }
}
