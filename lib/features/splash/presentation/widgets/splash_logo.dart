import 'package:flutter/material.dart';
import 'package:pms_app/core/theme/app_colors.dart';

/// Reusable brand mark: two interlocking rounded parallelograms
/// (black + orange), matching the geometric logo shown in the PDF.
/// Implemented with `CustomPainter` so no binary asset is required and
/// the mark stays crisp at any size.
class SplashLogo extends StatelessWidget {
  final double size;

  const SplashLogo({super.key, this.size = 96});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _LogoPainter()),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.09;

    final blackPaint = Paint()
      ..color = AppColors.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.round;

    final orangePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Back parallelogram (black) — offset up-right.
    final backPath = Path()
      ..moveTo(w * 0.30, h * 0.10)
      ..lineTo(w * 0.95, h * 0.10)
      ..lineTo(w * 0.70, h * 0.55)
      ..lineTo(w * 0.05, h * 0.55)
      ..close();

    // Front parallelogram (orange) — offset down-left, overlapping.
    final frontPath = Path()
      ..moveTo(w * 0.05, h * 0.45)
      ..lineTo(w * 0.70, h * 0.45)
      ..lineTo(w * 0.95, h * 0.90)
      ..lineTo(w * 0.30, h * 0.90)
      ..close();

    canvas.drawPath(backPath, blackPaint);
    canvas.drawPath(frontPath, orangePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
