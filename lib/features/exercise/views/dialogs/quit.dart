import 'package:flutter/material.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../main/views/widgets/dialog_primary_button.dart';
import '../../../main/views/widgets/dialog_secondary_button.dart';
import '../../../main/views/widgets/dialog_title.dart';

class QuitDialog extends StatelessWidget {
  final String? title;
  final String? positiveButtonText;
  final String? negativeButtonText;
  final Function() onQuit;
  final Function() onCancel;

  const QuitDialog({
    super.key,
    required this.onQuit,
    required this.onCancel,
    this.title,
    this.positiveButtonText,
    this.negativeButtonText,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    String? positiveButtonText,
    String? negativeButtonText,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return QuitDialog(
          title: title,
          positiveButtonText: positiveButtonText,
          negativeButtonText: negativeButtonText,
          onQuit: () => context.close(result: true),
          onCancel: () => context.close(result: false),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InAppDialogTitle(text: title ?? 'Do you want to Quit?'),
            const SizedBox(height: 16),
            InAppDialogPrimaryButton(
              text: positiveButtonText ?? "Quit",
              onTap: onQuit,
            ),
            const SizedBox(height: 16),
            InAppDialogSecondaryButton(
              text: negativeButtonText ?? "Cancel",
              onTap: onCancel,
            ),
          ],
        ),
      ),
    );
  }
}
