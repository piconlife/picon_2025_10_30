import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';

import '../../../../roots/widgets/align.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/position.dart';
import '../../../../roots/widgets/text.dart';

class OnboardingGenerating extends StatefulWidget {
  final String label;
  final ValueChanged<AnimationStatus>? onStatus;

  const OnboardingGenerating({super.key, required this.label, this.onStatus});

  @override
  State<OnboardingGenerating> createState() => _OnboardingGeneratingState();
}

class _OnboardingGeneratingState extends State<OnboardingGenerating>
    with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 5000),
  );

  @override
  void initState() {
    super.initState();
    controller.forward();
    if (widget.onStatus != null) {
      controller.addStatusListener(widget.onStatus!);
    }
  }

  @override
  void dispose() {
    if (widget.onStatus != null) {
      controller.removeStatusListener(widget.onStatus!);
    }
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: InAppLayout(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8, bottom: 8),
            child: InAppText(
              widget.label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: context.textColor.dark,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return CustomProgressIndicator(
                progress: controller.value,
                height: 70,
                width: double.infinity,
                borderRadius: 20,
              );
            },
          ),
        ],
      ),
    );
  }
}

class CustomProgressIndicator extends StatelessWidget {
  final double progress;
  final double height;
  final double width;
  final Color backgroundColor;
  final Color progressColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final bool showPercentage;

  const CustomProgressIndicator({
    super.key,
    required this.progress,
    required this.height,
    required this.width,
    this.backgroundColor = Colors.white,
    this.progressColor = const Color(0xFFE9632A),
    this.borderColor = const Color(0xFF5C6178),
    this.borderWidth = 4.0,
    this.borderRadius = 20.0,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      padding: EdgeInsets.all(6),
      child: InAppLayout(
        layout: LayoutType.stack,
        children: [
          FractionallySizedBox(
            widthFactor: progress,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: progressColor,
                borderRadius: BorderRadius.circular(borderRadius * 0.6),
              ),
              clipBehavior: Clip.antiAlias,
              child: InAppAlign(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 20,
                  height: height,
                  decoration: BoxDecoration(color: progressColor),
                  child: CustomPaint(
                    painter: ImprovedDiagonalLinesPainter(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (showPercentage)
            InAppPositioned(
              left: 15,
              top: 0,
              bottom: 0,
              child: Center(
                child: InAppText(
                  '${(progress * 100).toInt().trNumWithOption(applyRtl: true)}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: height * 0.45,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

enum DiagonalDirection { topLeftToBottomRight, topRightToBottomLeft, both }

class ImprovedDiagonalLinesPainter extends CustomPainter {
  final Color color;
  final DiagonalDirection direction;
  final double spacing;
  final double strokeWidth;

  const ImprovedDiagonalLinesPainter({
    required this.color,
    this.direction = DiagonalDirection.topRightToBottomLeft,
    this.spacing = 8.0,
    this.strokeWidth = 2.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Draw top-left to bottom-right diagonal lines
    if (direction == DiagonalDirection.topLeftToBottomRight ||
        direction == DiagonalDirection.both) {
      for (
        double i = -size.height;
        i <= size.width + size.height;
        i += spacing
      ) {
        canvas.drawLine(
          Offset(i, 0),
          Offset(i + size.height, size.height),
          paint,
        );
      }
    }

    // Draw top-right to bottom-left diagonal lines
    if (direction == DiagonalDirection.topRightToBottomLeft ||
        direction == DiagonalDirection.both) {
      for (double i = 0; i <= size.width + size.height; i += spacing) {
        canvas.drawLine(
          Offset(i, 0),
          Offset(i - size.height, size.height),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
