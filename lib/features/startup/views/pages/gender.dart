import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:flutter_androssy_kits/widgets.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../data/models/user.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/filled_button.dart';
import '../../../../roots/widgets/logo_trailing.dart';
import '../../../../roots/widgets/screen.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/paths.dart';
import '../../preferences/startup.dart';
import '../widgets/title_with_subtitle.dart';

class GenderPage extends StatefulWidget {
  const GenderPage({super.key});

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  final optionKey = GlobalKey<AndrossyOptionState>();

  void _next(BuildContext context) {
    final gender = Gender.values.elementAtOrNull(
      optionKey.currentState?.currentIndex ?? 0,
    );
    if (gender == null) {
      context.showWarningSnackBar(
        "Please select your gender to receive a personalized experience.",
      );
      return;
    }

    if (Startup.puts({StartupKeys.gender: gender.id})) {
      context.open(Routes.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.primary;
    final dimen = context.dimens;
    final color = context.isDarkMode ? Colors.white : primary;
    return Scaffold(
      appBar: const InAppAppbar(
        titleText: "Gender",
        actions: [InAppLogoTrailing()],
      ),
      body: InAppScreen(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: dimen.dp(32),
            vertical: dimen.dp(24),
          ),
          child: Column(
            children: [
              AuthTitleWithSubtitle(
                dimen: dimen,
                title: "What's your gender?",
                subtitle:
                    "Please select your gender to receive a personalized experience.",
              ),
              dimen.dp(24).h,
              AndrossyOption(
                key: optionKey,
                itemCount: Gender.values.length,
                currentIndex: Startup.i.gender ?? 0,
                onChanged: (index) => Startup.put(StartupKeys.gender, index),
                builder: (context, index, selected) {
                  final item = Gender.values.elementAt(index);
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    padding: EdgeInsets.all(dimen.dp(16)),
                    margin: EdgeInsets.symmetric(vertical: dimen.dp(8)),
                    decoration: BoxDecoration(
                      color: color.t05,
                      border: Border.all(
                        width: dimen.dp(2),
                        color: selected ? color : color.t05,
                      ),
                      borderRadius: BorderRadius.circular(dimen.dp(25)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: dimen.dp(24),
                          height: dimen.dp(24),
                          decoration: BoxDecoration(
                            color: selected ? color.t75 : color.t01,
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: dimen.dp(2),
                              color: selected ? color.t01 : color.t75,
                            ),
                          ),
                        ),
                        dimen.dp(24).w,
                        Expanded(
                          child: InAppText(
                            item.name,
                            style: TextStyle(
                              color: color.t75,
                              fontSize: dimen.dp(18),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              dimen.dp(32).h,
              InAppFilledButton(text: "Next", onTap: () => _next(context)),
            ],
          ),
        ),
      ),
    );
  }
}
