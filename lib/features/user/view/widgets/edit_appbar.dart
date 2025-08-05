import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy_kits/widgets.dart';

import '../../../../roots/widgets/text.dart';

class EditUserAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? buttonText;
  final VoidCallback? onClick;

  const EditUserAppbar({super.key, this.title, this.buttonText, this.onClick});

  @override
  Widget build(BuildContext context) {
    final primary = context.primary;
    final dimen = context.dimens;
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: InAppText(
        title,
        style: TextStyle(
          fontSize: dimen.dp(20),
          color: context.dark,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AndrossyButton(
              primary: primary,
              activated: false,
              backgroundColor: AndrossyButtonProperty.all(primary.t10),
              text: buttonText,
              splashColor: Theme.of(context).splashColor,
              padding: EdgeInsets.symmetric(
                horizontal: dimen.dp(16),
                vertical: dimen.dp(8),
              ),
              borderRadius: BorderRadius.circular(dimen.dp(12)),
              textAllCaps: true,
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
              textColor: AndrossyButtonProperty.all(
                context.isDarkMode ? context.lightAsFixed : primary,
              ),
              onTap: onClick,
              textSize: dimen.dp(14),
            ),
          ],
        ),
        dimen.dp(12).w,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
