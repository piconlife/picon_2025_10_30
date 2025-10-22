import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:auth_management/auth_management.dart';
import 'package:flutter/material.dart';

import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../roots/widgets/text_button.dart';

const kBiometricPermissionDialogKey = "biometric_dialog";

class InAppBiometricPermissionDialog extends StatelessWidget {
  final dynamic icon;
  final String titleText;
  final String subtitleText;
  final String positiveText;
  final String negativeText;

  const InAppBiometricPermissionDialog({
    super.key,
    this.icon = Icons.fingerprint,
    this.titleText = "Do you want to allow to use biometric login?",
    this.subtitleText = "Use Biometric ID or Face ID",
    this.positiveText = "OK",
    this.negativeText = "Don't Allow",
  });

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    return Dialog(
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(dimen.dp(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InAppText(
                  titleText,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: dimen.dp(16), color: dark),
                ),
                SizedBox(height: dimen.dp(24)),
                InAppIcon(icon, size: dimen.dp(40), color: dark.t50),
                SizedBox(height: dimen.dp(24)),
                InAppText(
                  subtitleText,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: dimen.dp(12), color: dark.t50),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: InAppTextButton(
                  negativeText,
                  height: dimen.dp(54),
                  foregroundColor: Colors.grey,
                  onTap: () => Navigator.pop(context, BiometricStatus.initial),
                ),
              ),
              SizedBox(
                height: dimen.dp(40),
                child: VerticalDivider(width: 0, thickness: dimen.dp(1)),
              ),
              Expanded(
                child: InAppTextButton(
                  positiveText,
                  borderRadius: BorderRadius.zero,
                  height: dimen.dp(54),
                  foregroundColor: context.primary,
                  onTap:
                      () => Navigator.pop(context, BiometricStatus.activated),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
