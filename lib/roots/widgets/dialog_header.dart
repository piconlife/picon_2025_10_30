import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:in_app_navigator/route.dart';

import '../../app/res/icons.dart';
import 'action.dart';
import 'text.dart';

class InAppDialogHeader extends StatelessWidget {
  final String data;

  const InAppDialogHeader(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.dark;
    final dimen = context.dimens;
    return Container(
      width: double.infinity,
      height: dimen.appbar.normal?.height ?? dimen.dp(kToolbarHeight),
      padding: EdgeInsets.only(left: dimen.dp(24), right: dimen.dp(12)),
      child: Row(
        children: [
          Expanded(
            child: InAppText(
              data,
              style: TextStyle(fontSize: dimen.dp(20), color: dark),
            ),
          ),
          SizedBox(width: dimen.dp(16)),
          InAppAction(
            InAppIcons.close.regular,
            onTap: () => context.close(),
            primary: dark,
          ),
        ],
      ),
    );
  }
}
