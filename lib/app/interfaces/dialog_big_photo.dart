import 'package:flutter/material.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';

import '../../roots/widgets/image.dart';

const kBigPhotoDialogKey = "bsd_big_photo";

class InAppBigPhotoDialog extends StatelessWidget {
  final dynamic data;

  const InAppBigPhotoDialog(this.data, {super.key});

  static Future<Object?> show(BuildContext context, dynamic imageData) {
    return context.show(
      kBigPhotoDialogKey,
      content: DialogContent(args: imageData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InAppImage(data, width: double.infinity, fit: BoxFit.contain);
  }
}
