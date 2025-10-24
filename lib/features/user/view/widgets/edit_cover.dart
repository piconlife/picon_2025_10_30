import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';
import 'package:picon/app/dialogs/dialog_image_cropper.dart';

import '../../../../app/contents/media.dart';
import '../../../../app/res/icons.dart';
import '../../../../app/res/placeholders.dart';
import '../../../../app/utils/media_picker.dart';
import '../../../../roots/widgets/icon_button.dart';
import '../../../../roots/widgets/image.dart';

class EditableCover extends StatefulWidget {
  final bool loading;
  final bool isAlreadyUploaded;
  final dynamic image;
  final void Function(BuildContext context, MediaData? value)? imageChosen;
  final Future<bool> Function(BuildContext context)? imageRemove;

  const EditableCover({
    super.key,
    this.isAlreadyUploaded = false,
    this.loading = false,
    this.image,
    this.imageChosen,
    this.imageRemove,
  });

  @override
  State<EditableCover> createState() => _EditableCoverState();
}

class _EditableCoverState extends State<EditableCover> {
  MediaData? _data;

  void _choose(BuildContext context) async {
    final value = await MediaPicker.I.chooseImage(
      context,
      crop: true,
      cropOptions: InAppImageCropperOptions(
        title: "Cover photo",
        withAspectRatio: 1,
      ),
    );
    if (!context.mounted) return;
    _data = value ?? _data;
    if (widget.imageChosen != null) widget.imageChosen!(context, _data);
    setState(() {});
  }

  void _remove(BuildContext context) async {
    if (widget.imageRemove != null) {
      final value = await widget.imageRemove!(context);
      if (value) {
        _data = null;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: context.light.t05,
            foregroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [context.light.t01, context.light.t05, context.light],
              ),
            ),
            child: InAppImage(
              _data?.data ?? widget.image ?? InAppPlaceholders.image,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InAppIconButton(
              widget.isAlreadyUploaded
                  ? InAppIcons.nativeClose.solid
                  : InAppIcons.camera.solid,
              size: 50,
              activated: widget.isAlreadyUploaded,
              loading: widget.loading,
              borderRadius: BorderRadius.circular(50),
              activatedColor: const Color(0xFFFA9F98),
              iconColor: Colors.white,
              activatedIconColor: Colors.white,
              onTap: () {
                if (widget.isAlreadyUploaded) {
                  _remove(context);
                } else {
                  _choose(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
