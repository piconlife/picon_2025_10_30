import 'dart:typed_data';

import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';

import '../../roots/widgets/appbar.dart';
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
  final double? withAspectRatio;
  final bool? withCircleShape;

  const InAppImageCropperOptions({
    this.title,
    this.actionTitle,
    this.withAspectRatio,
    this.withCircleShape,
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

  void _cropped(CropResult data) {
    if (data is CropSuccess) {
      Navigator.pop(context, data.croppedImage);
      return;
    }
    return Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark,
      appBar: InAppAppbar(
        titleText: widget.options.title ?? "Edit",
        centerTitle: true,
        titleTextStyle: TextStyle(color: light),
        backgroundColor: dark.t10,
        leading: InAppLeading(
          icon: Icons.clear,
          color: light,
          backgroundColor: light.t05,
          borderRadius: BorderRadius.circular(50),
        ),
        actions: [
          InAppTextedAction(
            widget.options.actionTitle ?? "Crop",
            primary: light,
            background: light.t05,
            onTap: _controller.crop,
          ),
        ],
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Crop(
        image: widget.data,
        onCropped: _cropped,
        baseColor: dark,
        aspectRatio: widget.options.withAspectRatio,
        withCircleUi: widget.options.withCircleShape ?? false,
        controller: _controller,
        clipBehavior: Clip.antiAlias,
        maskColor: dark.t50,
        progressIndicator: InAppShimmer(child: Image.memory(widget.data)),
      ),
    );
  }
}
