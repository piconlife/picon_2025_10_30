import 'dart:typed_data';

import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/spacing.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';

import '../../roots/widgets/appbar.dart';
import '../../roots/widgets/padding.dart';
import '../../roots/widgets/shimmer.dart';
import '../../roots/widgets/texted_action.dart';
import '../widgets/leading.dart';

class InAppImageCroppedResult {
  final Uint8List original;
  final Uint8List cropped;

  const InAppImageCroppedResult._(this.original, this.cropped);
}

class InAppImageCropperOptions {
  final String? title;
  final String? actionTitle;
  final double? initialAspectRatio;
  final double? withAspectRatio;
  final bool? withCircleShape;
  final bool? extendBody;
  final bool? extendBodyBehindAppBar;
  final bool? centerTitle;
  final TextStyle? titleTextStyle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final GridOptions? gridOptions;

  const InAppImageCropperOptions({
    this.extendBody,
    this.extendBodyBehindAppBar,
    this.centerTitle,
    this.titleTextStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.title,
    this.actionTitle,
    this.initialAspectRatio,
    this.withAspectRatio,
    this.withCircleShape,
    this.gridOptions,
  });
}

class InAppImageCropper extends StatefulWidget {
  final Uint8List data;
  final InAppImageCropperOptions options;

  const InAppImageCropper(
    this.data, {
    super.key,
    this.options = const InAppImageCropperOptions(),
  });

  static Future<InAppImageCroppedResult?> crop(
    BuildContext context,
    Uint8List data, {
    InAppImageCropperOptions? options,
  }) async {
    final feedback = await showAndrossyDialog(
      context: context,
      builder: (context) {
        return InAppImageCropper(
          data,
          options: options ?? InAppImageCropperOptions(),
        );
      },
    );
    if (feedback is Uint8List) return InAppImageCroppedResult._(data, feedback);
    return null;
  }

  @override
  State<InAppImageCropper> createState() => _InAppImageCropperState();
}

class _InAppImageCropperState extends State<InAppImageCropper> with ColorMixin {
  final _controller = CropController();
  bool _cropping = false;

  void _crop() {
    setState(() => _cropping = true);
    _controller.crop();
  }

  void _cropped(CropResult data) {
    setState(() => _cropping = false);
    if (data is CropSuccess) {
      Navigator.pop(context, data.croppedImage);
      return;
    }
    return Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.options.backgroundColor ?? darkAsFixed;
    final fg = widget.options.foregroundColor ?? lightAsFixed;
    return Scaffold(
      backgroundColor: bg,
      appBar: InAppAppbar(
        titleText: widget.options.title ?? "Edit",
        centerTitle: widget.options.centerTitle ?? true,
        titleTextStyle: widget.options.titleTextStyle ?? TextStyle(color: fg),
        backgroundColor: bg.t10,
        leading: InAppLeading(
          icon: Icons.clear,
          color: fg,
          backgroundColor: fg.t05,
          borderRadius: BorderRadius.circular(50),
        ),
        actions: [
          if (_cropping)
            Center(
              child: InAppPadding(
                padding: EdgeInsets.only(right: 8),
                child: SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(
                    strokeCap: StrokeCap.round,
                    color: fg,
                    strokeWidth: 2,
                  ),
                ),
              ),
            )
          else
            InAppTextedAction(
              widget.options.actionTitle ?? "Crop",
              primary: fg,
              background: fg.t05,
              onTap: _crop,
            ),
        ],
      ),
      extendBody: widget.options.extendBody ?? true,
      extendBodyBehindAppBar: widget.options.extendBodyBehindAppBar ?? true,
      body: Center(
        child: AspectRatio(
          aspectRatio: context.w / (context.h * 0.75),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Crop(
                image: widget.data,
                onCropped: _cropped,
                initialRectBuilder: InitialRectBuilder.withSizeAndRatio(
                  aspectRatio: widget.options.initialAspectRatio,
                ),
                baseColor: bg,
                aspectRatio: widget.options.withAspectRatio,
                withCircleUi: widget.options.withCircleShape ?? false,
                controller: _controller,
                clipBehavior: Clip.antiAlias,
                maskColor: bg.t50,
                progressIndicator: InAppShimmer(
                  child: Image.memory(widget.data),
                ),
                willUpdateScale: (newScale) => newScale < 5,
                fixCropRect: false,
                interactive: false,
                cornerDotBuilder: (size, edgeAlignment) {
                  return Container(
                    color: Colors.transparent,
                    width: size,
                    height: size,
                  );
                },
                overlayBuilder: (context, rect) {
                  return CustomPaint(
                    painter: GridPainter(
                      options:
                          widget.options.gridOptions ?? GridOptions(color: fg),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GridOptions {
  final int divisions;
  final double gridStroke;
  final double handleStroke;
  final double handleLength;
  final Color color;
  final bool showMiddleSideTicks;
  final bool showBorder;

  const GridOptions({
    this.divisions = 2,
    this.gridStroke = 1.0,
    this.handleStroke = 3.0,
    this.handleLength = 20.0,
    this.showMiddleSideTicks = false,
    this.showBorder = false,
    this.color = Colors.white,
  });
}

class GridPainter extends CustomPainter {
  final GridOptions options;

  const GridPainter({this.options = const GridOptions()});

  @override
  void paint(Canvas canvas, Size size) {
    final color = options.color;
    final divisions = options.divisions;
    final gridStroke = options.gridStroke;
    final handleStroke = options.handleStroke;
    final handleLength = options.handleLength;
    final showMiddleSideTicks = options.showMiddleSideTicks;
    final showBorder = options.showBorder;

    final gridPaint = Paint()
      ..strokeWidth = gridStroke
      ..color = color.withValues(alpha: 0.25);

    final handlePaint = Paint()
      ..strokeWidth = handleStroke
      ..strokeCap = StrokeCap.square
      ..color = color;

    final spacing = Size(
      size.width / (divisions + 1),
      size.height / (divisions + 1),
    );

    // Draw border

    if (showBorder) {
      final borderPaint = Paint()
        ..strokeWidth = gridStroke
        ..color = color.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke;

      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        borderPaint,
      );
    }

    // Draw grid lines
    for (var i = 1; i < divisions + 1; i++) {
      // vertical
      canvas.drawLine(
        Offset(spacing.width * i, 0),
        Offset(spacing.width * i, size.height),
        gridPaint,
      );
      // horizontal
      canvas.drawLine(
        Offset(0, spacing.height * i),
        Offset(size.width, spacing.height * i),
        gridPaint,
      );
    }

    // L-shaped corners
    // top-left
    canvas.drawLine(Offset(0, 0), Offset(handleLength, 0), handlePaint);
    canvas.drawLine(Offset(0, 0), Offset(0, handleLength), handlePaint);
    // top-right
    canvas.drawLine(
      Offset(size.width - handleLength, 0),
      Offset(size.width, 0),
      handlePaint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, handleLength),
      handlePaint,
    );
    // bottom-left
    canvas.drawLine(
      Offset(0, size.height - handleLength),
      Offset(0, size.height),
      handlePaint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(handleLength, size.height),
      handlePaint,
    );
    // bottom-right
    canvas.drawLine(
      Offset(size.width - handleLength, size.height),
      Offset(size.width, size.height),
      handlePaint,
    );
    canvas.drawLine(
      Offset(size.width, size.height - handleLength),
      Offset(size.width, size.height),
      handlePaint,
    );

    // Mid-side ticks
    if (showMiddleSideTicks) {
      // top center
      canvas.drawLine(
        Offset(size.width / 2 - handleLength / 2, 0),
        Offset(size.width / 2 + handleLength / 2, 0),
        handlePaint,
      );
      // bottom center
      canvas.drawLine(
        Offset(size.width / 2 - handleLength / 2, size.height),
        Offset(size.width / 2 + handleLength / 2, size.height),
        handlePaint,
      );
      // left center
      canvas.drawLine(
        Offset(0, size.height / 2 - handleLength / 2),
        Offset(0, size.height / 2 + handleLength / 2),
        handlePaint,
      );
      // right center
      canvas.drawLine(
        Offset(size.width, size.height / 2 - handleLength / 2),
        Offset(size.width, size.height / 2 + handleLength / 2),
        handlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => false;
}
