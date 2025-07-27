import 'package:app_color/app_color.dart';
import 'package:auth_management/auth_management.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/res/configs.dart';
import '../../../../roots/data/models/user.dart';
import '../../../../roots/helpers/user.dart';
import '../../../../roots/utils/utils.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/screen.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../roots/widgets/user_avatar.dart';
import '../../../../routes/paths.dart';
import '../widgets/card.dart';
import '../widgets/card_layout.dart';

class ProfilePage extends StatefulWidget {
  final Object? args;

  const ProfilePage({super.key, this.args});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TranslationMixin, ColorMixin {
  bool isLoggedIn = false;

  void _authorization(bool value) {
    setState(() {
      isLoggedIn = value;
    });
  }

  void _contactUs() => Utils.sendEmail(context);

  void _termsAndConditions() => Utils.launchLink(link: RemoteConfigs.termsLink);

  void _privacyPolicy() => Utils.launchLink(link: RemoteConfigs.privacyLink);

  void _deleteAccount() async {
    final deleted = await UserHelper.deleteAccount(context);
    if (deleted && mounted) {
      context.clear(Routes.intro);
    }
  }

  void _login() {
    context.open(
      Routes.login,
      arguments: {"authorization_anywhere_mode": true},
    );
  }

  void _logout() {
    UserHelper.signOut(context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.isLoggedIn<User>().then(_authorization);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InAppScreen(
      child: AuthObserver<User>(
        onStatus: (context, status) =>
            _authorization(status == AuthStatus.authenticated),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: InAppAppbar(
            elevation: 0,
            titleText: localize("title", defaultValue: "Profile"),
            titleTextStyle: TextStyle(
              color: dark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: isLoggedIn
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: InAppLayout(
                    layout: LayoutType.row,
                    children: [
                      InAppGesture(
                        onTap: _logout,
                        child: InAppLayout(
                          layout: LayoutType.row,
                          children: [
                            InAppIcon(
                              "assets/icons/ic_logout_regular.svg",
                              color: dark.t30,
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            InAppText(
                              localize("sign_out", defaultValue: "Sign out"),
                              style: TextStyle(fontSize: 16, color: dark.t30),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                )
              : null,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: InAppLayout(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCard(),
                  SizedBox(height: 24),
                  SettingsCard(
                    title: localize("other", defaultValue: "Other"),
                    data: [
                      if (!kIsWeb)
                        SettingsCardData(
                          icon: "assets/icons/ic_send_regular.svg",
                          label: localize(
                            "contact_us",
                            defaultValue: "Contact Us",
                          ),
                          onTap: _contactUs,
                        ),
                      SettingsCardData(
                        icon: "assets/icons/ic_document_regular.svg",
                        label: localize(
                          "terms_and_conditions",
                          defaultValue: "Terms & Conditions",
                        ),
                        onTap: _termsAndConditions,
                      ),
                      SettingsCardData(
                        icon: "assets/icons/ic_document_regular.svg",
                        label: localize(
                          "privacy_and_policy",
                          defaultValue: "Privacy & Policy",
                        ),
                        onTap: _privacyPolicy,
                      ),
                      if (isLoggedIn)
                        SettingsCardData(
                          icon: "assets/icons/ic_delete_regular.svg",
                          label: localize(
                            "delete_account",
                            defaultValue: "Delete account",
                          ),
                          onTap: _deleteAccount,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    if (isLoggedIn) {
      return SettingsCardLayout(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: InAppLayout(
            layout: LayoutType.row,
            children: [
              InAppUserAvatar(isLocal: true, size: 75, backgroundColor: holo),
              SizedBox(width: 16),
              Expanded(
                child: InAppLayout(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InAppText(
                      UserHelper.nameOrNull ??
                          localize("unknown", defaultValue: "Unknown"),
                      style: TextStyle(
                        color: dark,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    InAppText(
                      UserHelper.emailOrNull ?? "unknown@email.com",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: dark, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return SettingsCardLayout(
      child: SettingsCardItem(
        data: SettingsCardData(
          icon: Icons.person,
          label: localize("sign_in", defaultValue: "Sign In"),
          onTap: _login,
        ),
      ),
    );
  }

  @override
  String get name => "settings:profile";
}
