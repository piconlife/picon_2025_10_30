import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/helpers/clipboard_helper.dart';
import 'package:flutter_andomie/utils/configs.dart';
import 'package:flutter_andomie/utils/settings.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/constants/app.dart';
import '../../../../roots/helpers/user.dart';
import '../../../../roots/services/notification.dart';
import '../../../../roots/utils/utils.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/screen.dart';
import '../../../../roots/widgets/system_overlay.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/paths.dart';
import '../widgets/card.dart';
import '../widgets/remainder.dart';

const kHourlyNotificationStartTime = "hourly_notification_start_time";
const kHourlyNotificationEndTime = "hourly_notification_end_time";

int get mHourlyNotificationStartTime {
  return Settings.get(
    kHourlyNotificationStartTime,
    Configs.get(kHourlyNotificationStartTime, defaultValue: 8),
  );
}

int get mHourlyNotificationEndTime {
  return Settings.get(
    kHourlyNotificationEndTime,
    Configs.get(kHourlyNotificationEndTime, defaultValue: 22),
  );
}

class SettingsPage extends StatefulWidget {
  final Object? args;

  const SettingsPage({super.key, this.args});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with TranslationMixin, ColorMixin {
  void _profile() => context.open(Routes.profile);

  void _share() {
    Utils.share(
      context,
      subject: AppConstants.name,
      body: "Check out ${AppConstants.name}!",
    );
  }

  void _language() => selectLocale(context);

  void _copyUid() {
    if (UserHelper.uid.isEmpty) return;
    ClipboardHelper.setText(UserHelper.uid);
    context.showSnackBar(localize("copied", defaultValue: "Copied!"));
  }

  @override
  Widget build(BuildContext context) {
    return InAppSystemOverlay(
      child: InAppScreen(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: InAppAppbar(
            elevation: 0,
            titleText: localize("title", defaultValue: "Settings"),
            titleTextStyle: TextStyle(
              color: dark,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: InAppLayout(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingsCard(
                    title: localize("account", defaultValue: "Account"),
                    data: [
                      SettingsCardData(
                        icon: Icons.person_outline,
                        label: localize("profile", defaultValue: "Profile"),
                        onTap: _profile,
                      ),
                      SettingsCardData(
                        icon: Icons.share_outlined,
                        label: localize("share", defaultValue: "Share"),
                        onTap: _share,
                      ),
                    ],
                  ),
                  if (UserHelper.uid.isNotEmpty ||
                      supportedLocales.length > 1) ...[
                    SizedBox(height: 24),
                    SettingsCard(
                      title: localize("general", defaultValue: "General"),
                      data: [
                        if (supportedLocales.length > 1)
                          SettingsCardData(
                            icon: Icons.language,
                            label: localize(
                              "language",
                              defaultValue: "Language",
                            ),
                            trailing: TranslationButton(
                              ignorePointer: true,
                              type: TranslationButtonType.flagAndName,
                            ),
                            onTap: _language,
                          ),
                        if (UserHelper.uid.isNotEmpty)
                          SettingsCardData(
                            icon: Icons.copy_outlined,
                            label: localize(
                              "copy_user_id",
                              defaultValue: "Copy User Id",
                            ),
                            onTap: _copyUid,
                            trailing: InAppText(
                              localize(
                                "click_to_copy",
                                defaultValue: "Click to copy",
                              ),
                              style: TextStyle(color: mid, fontSize: 14),
                            ),
                          ),
                      ],
                    ),
                  ],
                  if (InAppNotifications.initialized) ...[
                    SizedBox(height: 24),
                    SettingsRemainder(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  String get name => "settings:main";
}
