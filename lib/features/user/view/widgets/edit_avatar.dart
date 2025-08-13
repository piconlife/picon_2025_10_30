import 'package:flutter/material.dart';

import '../../../../app/dialogs/dialog_image_cropper.dart';
import '../../../../app/res/icons.dart';
import '../../../../app/res/placeholders.dart';
import '../../../../app/utils/media_picker.dart';
import '../../../../roots/contents/media.dart';
import '../../../../roots/widgets/avatar.dart';
import '../../../../roots/widgets/icon_button.dart';

class EditableAvatar extends StatefulWidget {
  final bool isUploading;
  final bool isAlreadyUploaded;
  final dynamic image;
  final void Function(BuildContext context, MediaData? value)? imageChosen;
  final Future<bool> Function(BuildContext context)? imageRemove;

  const EditableAvatar({
    super.key,
    this.isAlreadyUploaded = false,
    this.isUploading = false,
    this.image,
    this.imageChosen,
    this.imageRemove,
  });

  @override
  State<EditableAvatar> createState() => _EditableAvatarState();
}

class _EditableAvatarState extends State<EditableAvatar> {
  MediaData? _data;

  void _choose(BuildContext context) async {
    final value = await MediaPicker.I.chooseImage(
      context,
      crop: true,
      cropOptions: InAppImageCropperOptions(
        title: "Avatar",
        withCircleShape: true,
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
    return SizedBox.square(
      dimension: 150,
      child: Stack(
        fit: StackFit.expand,
        children: [
          InAppAvatar(_data?.data ?? widget.image ?? InAppPlaceholders.user),
          Positioned(
            bottom: 0,
            right: 0,
            child: InAppIconButton(
              widget.isAlreadyUploaded
                  ? InAppIcons.nativeClose.solid
                  : InAppIcons.camera.solid,
              size: 50,
              activated: widget.isAlreadyUploaded,
              loading: widget.isUploading,
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
