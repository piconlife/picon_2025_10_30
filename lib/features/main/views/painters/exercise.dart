import 'dart:math' as m;

import 'package:flutter/material.dart';

enum ExercisePhase { countdown, squeeze, hold, relax, completed }

class ExerciseCurvePainter extends CustomPainter {
  final double progress;
  final ExercisePhase phase;

  ExerciseCurvePainter({required this.progress, required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    final path = Path();

    // Create a sine wave-like curve based on exercise phase
    for (int i = 0; i <= 100; i++) {
      final angle = (i / 100) * 2 * 3.14159;
      double amplitude = 0;

      switch (phase) {
        case ExercisePhase.squeeze:
          amplitude = radius * 0.3 * (progress * 4); // Quick increase
          break;
        case ExercisePhase.hold:
          amplitude = radius * 0.6; // Hold steady
          break;
        case ExercisePhase.relax:
          amplitude =
              radius * 0.6 * (1 - (progress - 0.25) * 1.33); // Gradual decrease
          break;
        default:
          amplitude = 0;
      }

      final x =
          center.dx + (radius + amplitude * m.sin(angle * 3)) * m.cos(angle);
      final y =
          center.dy + (radius + amplitude * m.sin(angle * 3)) * m.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw moving dot
    final dotAngle = progress * 2 * 3.14159;
    double dotAmplitude = 0;

    switch (phase) {
      case ExercisePhase.squeeze:
        dotAmplitude = radius * 0.3 * (progress * 4);
        break;
      case ExercisePhase.hold:
        dotAmplitude = radius * 0.6;
        break;
      case ExercisePhase.relax:
        dotAmplitude = radius * 0.6 * (1 - (progress - 0.25) * 1.33);
        break;
      default:
        dotAmplitude = 0;
    }

    final dotX =
        center.dx +
        (radius + dotAmplitude * m.sin(dotAngle * 3)) * m.cos(dotAngle);
    final dotY =
        center.dy +
        (radius + dotAmplitude * m.sin(dotAngle * 3)) * m.sin(dotAngle);

    final dotPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(dotX, dotY), 6, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
