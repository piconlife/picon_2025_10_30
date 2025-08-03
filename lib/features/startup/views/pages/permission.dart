import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/object.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/constants/app.dart';
import '../../../../roots/services/analytics.dart';
import '../../../../roots/services/notification.dart';
import '../../../../roots/widgets/align.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/position.dart';
import '../../../../roots/widgets/system_overlay.dart';
import '../../../../routes/paths.dart';
import '../../configs/onboard.dart';
import '../utils/parser.dart';
import '../widgets/onboarding_appbar.dart';
import '../widgets/onboarding_filled_button.dart';
import '../widgets/onboarding_text_button.dart';
import '../widgets/onboarding_titled_body.dart';
import '../widgets/startup_screen.dart';

class PermissionPage extends StatefulWidget {
  final Object? args;

  const PermissionPage({super.key, this.args});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage>
    with TranslationMixin, ColorMixin {
  late int step = widget.args.findByKey("step", defaultValue: 20);
  late int total = widget.args.findByKey("total", defaultValue: 21);

  void _allow() {
    Analytics.call(name, () async {
      bool status = await InAppNotifications.isPermissionAllow;
      if (status) {
        Analytics.log(name, msg: "Already permission allowed!");
        return _next();
      }
      status = await InAppNotifications.requestPermission();
      Analytics.log(name, msg: "Permission ${status ? "allowed!" : "denied!"}");
      if (!status) return;
      _next();
      InAppNotifications.init();
    });
  }

  void _next([bool check = false]) {
    Analytics.call(name, () async {
      if (check && await InAppNotifications.isPermissionAllow) {
        Analytics.log(name, msg: "Initial permission checked and move next!");
        return _next();
      }
      if (!mounted) return;
      context.next(
        Routes.permission,
        arguments: {"step": step + 1, "total": total},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final configs = OnboardConfigs.i;
    final dimen = context.dimens;

    String steps(String key) => stepsParser(key, total, step);

    return InAppSystemOverlay(
      child: OnboardScreen(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: InAppLayout(
              layout: LayoutType.stack,
              children: [
                InAppPositioned(
                  left: 0,
                  right: 0,
                  top: 16,
                  child: OnboardingAppbar(
                    title: localize("title", defaultValue: ''),
                    step: step,
                    total: total,
                    text: steps,
                  ),
                ),
                InAppAlign(
                  alignment: Alignment(0, -0.5),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ).apply(dimen),
                    child: OnboardingTitledBody(
                      configs: configs,
                      body: localize(
                        "description",
                        defaultValue:
                            "According to our data, {APP_NAME} users who receive notification are more likely achieve their goals",
                        replace: (value) =>
                            value.replaceAll("{APP_NAME}", AppConstants.name),
                      ),
                      title: localize(
                        "header",
                        defaultValue:
                            "{PROGRESS}% more successful with notifications",
                        applyNumber: true,
                        replace: (value) =>
                            value.replaceAll("{PROGRESS}", "87"),
                      ),
                      image: "assets/images/startup/notification.png",
                      imageWidth: dimen.width * 0.5,
                    ),
                  ),
                ),
                InAppAlign(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: dimen.padding.large,
                    ),
                    child: InAppLayout(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OnboardingFilledButton(
                          dimen: dimen,
                          text: localize("button_1", defaultValue: "Allow"),
                          onTap: _allow,
                          margin: EdgeInsets.zero,
                        ),
                        OnboardingTextButton(
                          dimen: dimen,
                          margin: EdgeInsets.zero,
                          text: localize("button_2", defaultValue: "Later"),
                          onTap: _next,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  String get name => "startup:permission";
}
