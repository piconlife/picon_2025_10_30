import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/spacing.dart';
import 'package:flutter_andomie/utils/icon.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:in_app_navigator/route.dart';

import '../../../../app/res/icons.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/text.dart';

const kMetubeFormatBSD = "metube_format_bsd";

class MetubeFormatBSD extends StatelessWidget {
  const MetubeFormatBSD({super.key});

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: dimen.dp(380)),
      decoration: BoxDecoration(
        color: context.dialogColor.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(dimen.dp(50)),
          topRight: Radius.circular(dimen.dp(50)),
        ),
        boxShadow: [
          BoxShadow(color: context.mid.t05, blurRadius: dimen.dp(50)),
        ],
      ),
      padding: EdgeInsets.only(top: dimen.dp(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(dimen.dp(16)),
            child: InAppText(
              "Choose action",
              textAlign: TextAlign.center,
              style: TextStyle(color: context.dark, fontSize: dimen.dp(20)),
            ),
          ),
          ...List.generate(MetubeFormats.values.length, (index) {
            final item = MetubeFormats.values.elementAt(index);
            return _Option(
              item: item,
              dimen: dimen,
              selected: item == MetubeFormats.uploadAVideo,
              onClick: (value) {
                InAppNavigator.close(context, result: value);
              },
            );
          }),
          dimen.dp(24).h,
        ],
      ),
    );
  }

  static Future<MetubeFormats?> show(BuildContext context) {
    return context.show(kMetubeFormatBSD);
  }
}

class _Option extends StatelessWidget {
  final DimenData dimen;
  final MetubeFormats item;
  final bool selected;
  final ValueChanged<MetubeFormats> onClick;

  const _Option({
    required this.dimen,
    required this.selected,
    required this.item,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.primary;
    return InAppGesture(
      onTap: () => onClick(item),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(dimen.dp(16)),
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: dimen.dp(22),
              backgroundColor: selected ? primary : primary.t10,
              child: InAppIcon(
                item.icon.solid,
                size: dimen.dp(24),
                color: selected ? Colors.white : primary,
              ),
            ),
            dimen.dp(16).w,
            Expanded(
              child: InAppText(
                item.title,
                style: TextStyle(color: context.dark, fontSize: dimen.dp(18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum MetubeFormats {
  uploadAVideo(title: "Upload a video", icon: InAppIcons.write);

  final String title;
  final AndomieIcon icon;

  const MetubeFormats({required this.title, required this.icon});
}
