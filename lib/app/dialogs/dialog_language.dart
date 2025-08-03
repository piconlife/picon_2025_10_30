import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/models/language.dart';
import 'package:flutter_andomie/utils/translation.dart';

import '../../roots/widgets/auto_scroll.dart';

class LanguagePickerDialog extends StatefulWidget {
  final String? title;

  const LanguagePickerDialog({super.key, this.title});

  static Future<Locale?>? show(BuildContext context, {String? title}) {
    return showDialog(
      context: context,
      useSafeArea: true,
      useRootNavigator: true,
      builder: (context) => LanguagePickerDialog(title: title),
    );
  }

  @override
  State<LanguagePickerDialog> createState() => _LanguagePickerDialogState();
}

class _LanguagePickerDialogState extends State<LanguagePickerDialog>
    with TranslationMixin {
  final controller = ScrollController();

  final itemHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    final locale = this.locale;
    final supportedLocales = this.supportedLocales;
    final dimen = context.dimens;
    return Dialog(
      child: InAppAutoScroll(
        controller: controller,
        targetIndex: supportedLocales.indexOf(locale),
        adjustmentHeight: dimen.dy(15),
        itemHeight: dimen.dy(itemHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: dimen.dx(24),
                vertical: dimen.dy(20),
              ),
              child: Text(
                widget.title ??
                    localize("title", defaultValue: "Choose your language"),
                style: TextStyle(
                  color: context.dark,
                  fontWeight: context.mediumFontWeight,
                  fontSize: dimen.dp(18),
                ),
              ),
            ),
            ListenableBuilder(
              listenable: controller,
              builder: (context, child) {
                if (controller.positions.isNotEmpty && controller.offset == 0) {
                  return SizedBox.shrink();
                }
                return child!;
              },
              child: Divider(height: 0),
            ),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: supportedLocales.length,
                itemBuilder: (context, index) {
                  final item = supportedLocales.elementAt(index);
                  return SizedBox(
                    height: dimen.dy(itemHeight),
                    child: RadioListTile.adaptive(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: dimen.dx(16),
                      ),
                      groupValue: locale,
                      value: item,
                      onChanged: (value) => Navigator.pop(context, value),
                      fillColor: WidgetStateColor.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return context.primary;
                        }
                        return context.mid;
                      }),
                      title: Text(
                        item.nativeName ?? item.name ?? item.toString(),
                        style: TextStyle(
                          color: context.dark,
                          fontWeight: context.mediumFontWeight,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  String get name => "dialog_language";
}
