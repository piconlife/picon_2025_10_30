import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/int.dart';
import 'package:flutter_andomie/extensions/spacing.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:flutter_androssy_kits/widgets.dart';

import '../../app/styles/fonts.dart';
import '../../roots/widgets/text.dart';
import '../../roots/widgets/text_button.dart';

const kMaxCharacters = "maxCharacters";

class InAppEditorDialog extends StatefulWidget {
  final String? hint;
  final String? title;
  final String? text;
  final int? maxCharacters;
  final int? minCharacters;
  final int? maxLines;
  final int? minLines;
  final TextInputType? inputType;
  final TextInputAction? actionType;
  final Object? args;

  const InAppEditorDialog({
    super.key,
    this.hint,
    this.title,
    this.text,
    this.maxCharacters,
    this.minCharacters,
    this.maxLines,
    this.minLines,
    this.inputType,
    this.actionType,
    this.args,
  });

  @override
  State<InAppEditorDialog> createState() => _InAppEditorDialogState();
}

class _InAppEditorDialogState extends State<InAppEditorDialog> {
  final controller = TextEditingController();

  String get text {
    return controller.text;
  }

  @override
  void initState() {
    controller.text = widget.text ?? "";
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final value = text.trim();
    context.dismiss(result: value.isNotEmpty ? value : null);
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final color = context.dark;
    final primary = context.primary;
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    return Dialog(
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(dimen.dp(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            dimen.dp(8).h,
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: dimen.dp(8)),
              child: InAppText(
                widget.title,
                style: TextStyle(
                  fontSize: dimen.dp(20),
                  color: color.t50,
                  fontWeight: dimen.mediumFontWeight,
                  fontFamily: InAppFonts.secondary,
                ),
              ),
            ),
            dimen.dp(12).h,
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: dimen.dp(8)),
              child: AndrossyField(
                controller: controller,
                constraints: BoxConstraints(
                  maxHeight: keyboardHeight > 0
                      ? (context.screenHeight - keyboardHeight) * 0.5
                      : double.infinity,
                ),
                text: widget.text,
                style: TextStyle(color: color),
                hintText: widget.text ?? widget.hint,
                hintColor: color.t25,
                underlineColor: AndrossyFieldProperty(enabled: color.t10),
                inputAction: widget.actionType ?? TextInputAction.newline,
                inputType: widget.inputType ?? TextInputType.multiline,
                maxLines: widget.maxLines ?? 5,
                minLines: widget.minLines ?? 1,
                maxCharacters: widget.maxCharacters,
                minCharacters: widget.minCharacters,
                maxCharactersAsLimit: true,
                counterVisibility: widget.maxCharacters.isValid
                    ? FloatingVisibility.auto
                    : FloatingVisibility.hide,
                counterStyle: AndrossyFieldProperty.all(
                  TextStyle(color: color.t25),
                ),
                onSubmitted: widget.actionType == TextInputAction.done
                    ? (value) => _submit(context)
                    : null,
              ),
            ),
            dimen.dp(24).h,
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InAppTextButton(
                    "dialog_button_negative".trWithOption(
                      defaultValue: "Cancel",
                      name: "dialog_editor",
                    ),
                    padding: EdgeInsets.zero,
                    textAllCaps: true,
                    width: dimen.dp(90),
                    height: dimen.dp(36),
                    foregroundColor: color.t50,
                    backgroundColor: color.t05,
                    borderRadius: BorderRadius.circular(dimen.dp(10)),
                    onTap: context.dismiss,
                    style: TextStyle(
                      color: color.t50,
                      fontFamily: InAppFonts.secondary,
                      fontWeight: dimen.semiBoldFontWeight,
                      fontSize: dimen.dp(14),
                    ),
                  ),
                  SizedBox(width: dimen.dp(8)),
                  InAppTextButton(
                    "dialog_button_positive".trWithOption(
                      defaultValue: "Save",
                      name: "dialog_editor",
                    ),
                    padding: EdgeInsets.zero,
                    textAllCaps: true,
                    width: dimen.dp(70),
                    height: dimen.dp(36),
                    foregroundColor: primary.t50,
                    backgroundColor: primary.t10,
                    borderRadius: BorderRadius.circular(dimen.dp(10)),
                    onTap: () => _submit(context),
                    style: TextStyle(
                      color: primary,
                      fontFamily: InAppFonts.secondary,
                      fontWeight: dimen.semiBoldFontWeight,
                      fontSize: dimen.dp(14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
