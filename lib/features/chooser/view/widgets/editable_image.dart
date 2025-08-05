import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy_kits/widgets.dart';

import '../../../../app/res/icons.dart';
import '../../../../roots/utils/image_provider.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/image.dart';

class ChoosingEditableImage extends StatelessWidget {
  final EditablePhoto? photo;
  final VoidCallback? onCropped;
  final VoidCallback? onRemoved;

  const ChoosingEditableImage({
    super.key,
    this.photo,
    this.onCropped,
    this.onRemoved,
  });

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    if (photo == null) {
      return AspectRatio(
        aspectRatio: 12 / 9,
        child: AndrossyShimmer(child: Container(color: dark.t10)),
      );
    }

    return AndrossySingleton(
      child: ColoredBox(
        color: dark.t05,
        child: Stack(
          children: [
            InAppImage(
              photo!.data,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            Positioned(
              top: dimen.dp(8),
              right: dimen.dp(8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(dimen.dp(10)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (photo!.editable && photo!.data is! String)
                      InAppGesture(
                        onTap: onCropped,
                        child: Padding(
                          padding: EdgeInsets.all(dimen.dp(8)),
                          child: InAppIcon(
                            InAppIcons.crop.regular,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    InAppGesture(
                      onTap: onRemoved,
                      child: Padding(
                        padding: EdgeInsets.all(dimen.dp(8)),
                        child: InAppIcon(
                          InAppIcons.nativeClose.regular,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
