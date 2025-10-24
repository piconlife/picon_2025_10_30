import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:in_app_translation/in_app_translation.dart';

import '../../app/interfaces/dialog_language.dart';
import '../../app/res/icons.dart';
import 'gesture.dart';
import 'icon.dart';
import 'text.dart';

class InAppLanguageDropdown extends StatefulWidget {
  final Color? primary;

  const InAppLanguageDropdown({super.key, this.primary});

  @override
  State<InAppLanguageDropdown> createState() => _InAppLanguageDropdownState();
}

class _InAppLanguageDropdownState extends State<InAppLanguageDropdown>
    with TranslationMixin {
  void _chose() async {
    final feedback = await LanguagePickerDialog.show(context);
    if (feedback == null) return;
    Translation.changeLocale(feedback);
  }

  @override
  Widget build(BuildContext context) {
    final locale = this.locale;
    final dimen = context.dimens;
    final primary = widget.primary ?? context.primary;
    return InAppGesture(
      scalerLowerBound: 1,
      onTap: _chose,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InAppIcon(InAppIcons.language.bold, color: primary),
          dimen.space.small.w,
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: primary, width: dimen.divider.normal),
              ),
            ),
            padding: EdgeInsets.only(bottom: dimen.space.smaller),
            constraints: BoxConstraints(minWidth: dimen.dx(90)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InAppText(
                  locale.nativeName ?? locale.name ?? locale.toString(),
                  style: TextStyle(
                    color: primary,
                    fontSize: dimen.fontSize.medium,
                    fontWeight: dimen.fontWeight.medium.fontWeight,
                  ),
                ),
                InAppIcon(InAppIcons.dropdown.regular, color: primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  String get name => "language_dropdown";
}
