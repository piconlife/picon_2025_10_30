import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:in_app_navigator/in_app_navigator.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../roots/widgets/align.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/padding.dart';
import '../../../../roots/widgets/text.dart';
import '../../../main/views/widgets/secondary_button.dart';

class ExerciseDonePage extends StatefulWidget {
  final Object? args;
  final bool dialogMode;
  final VoidCallback? onBackToHome;

  const ExerciseDonePage({
    super.key,
    this.args,
    this.dialogMode = false,
    this.onBackToHome,
  });

  static Future<T?>? show<T extends Object?>({
    required BuildContext context,
    Object? args,
    VoidCallback? onBackToHome,
  }) {
    return showCupertinoModalBottomSheet(
      expand: true,
      topRadius: Radius.circular(28),
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ExerciseDonePage(
        dialogMode: true,
        args: args,
        onBackToHome: () {
          context.close();
          onBackToHome?.call();
        },
      ),
    );
  }

  @override
  State<ExerciseDonePage> createState() => _ExerciseDonePageState();
}

class _ExerciseDonePageState extends State<ExerciseDonePage>
    with ColorMixin, TranslationMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: InAppLayout(
          layout: LayoutType.stack,
          children: [
            InAppAlign(
              alignment: Alignment(0, -0.85),
              child: InAppImage(
                'assets/images/img_exercise_done.png',
                fit: BoxFit.fitWidth,
                width: double.infinity,
              ),
            ),
            InAppAlign(
              alignment: Alignment(0, 0.16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InAppLayout(
                  layout: LayoutType.column,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InAppText(
                      (localizes(
                        'titles',
                        defaultValue: ['Pelvic floor: upgraded💪'],
                      )..shuffle()).first,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: dark,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    InAppText(
                      (localizes(
                        'subtitles',
                        defaultValue: [
                          'You just trained your secret\nsuperpower.',
                        ],
                      )..shuffle()).first,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: dark.t50,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InAppAlign(
              alignment: Alignment(0, 0.9),
              child: InAppPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InAppSecondaryButton(
                  text: localize("button", defaultValue: "Back to Home"),
                  height: 70,
                  onTap: widget.dialogMode
                      ? widget.onBackToHome
                      : () => context.close(result: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  String get name => "exercise:done";
}
