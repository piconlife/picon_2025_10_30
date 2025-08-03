import 'package:app_color/app_color.dart';
import 'package:auth_management/auth_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/object.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/res/configs.dart';
import '../../../../roots/res/listeners.dart';
import '../../../../roots/utils/platform.dart';
import '../../../../roots/widgets/align.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/system_overlay.dart';
import '../../../../routes/paths.dart';
import '../../enums/authorization_mode.dart';
import '../widgets/logo.dart';
import '../widgets/onboarding_appbar.dart';
import '../widgets/onboarding_auth_button.dart';
import '../widgets/onboarding_filled_button.dart';
import '../widgets/startup_screen.dart';

const kAuthorizationAnywhere = "authorization_anywhere_mode";

class LoginPage extends StatefulWidget {
  final Object? args;
  final bool isBackMode;
  final VoidCallback? onSkipped;
  final VoidCallback? onLoggedIn;

  const LoginPage({
    super.key,
    this.args,
    this.isBackMode = true,
    this.onLoggedIn,
    this.onSkipped,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with TranslationMixin, ColorMixin {
  bool get isAnywhereMode {
    return widget.args.find(
      key: "authorization_anywhere_mode",
      defaultValue: false,
    );
  }

  bool get isViewMode => widget.onLoggedIn != null;

  void _login(OauthButtonType type) async {
    RootListeners.login(context, type, () {
      if (widget.onLoggedIn != null) widget.onLoggedIn!();
      _next();
    });
  }

  void _next() {
    if (isAnywhereMode) {
      context.close();
      return;
    }
    context.close();
    context.next(Routes.login, clearMode: false);
  }

  @override
  Widget build(BuildContext context) {
    final mode = AuthorizationMode.detect;
    return InAppSystemOverlay(
      child: OnboardScreen(
        onWillPop: !widget.isBackMode ? () async => false : null,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: InAppLayout(
              layout: LayoutType.stack,
              children: [
                if (!isViewMode)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 8,
                    child: OnboardingAppbar(
                      title: localize("title", defaultValue: ''),
                      showLeading: widget.isBackMode,
                      onSkip:
                          widget.onSkipped ?? (mode.isNormal ? _next : null),
                    ),
                  ),
                InAppAlign(
                  alignment: const Alignment(0, -0.2),
                  child: OnboardingLogo(),
                ),
                InAppAlign(
                  alignment: Alignment.bottomCenter,
                  child: InAppLayout(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!mode.isNone && RemoteConfigs.isGoogleAuthEnabled)
                        OnboardingAuthButton(
                          text: localize(
                            "button_1",
                            defaultValue: "Continue with Google",
                          ),
                          logo: "assets/icons/ic_google.svg",
                          fill: false,
                          onTap: () => _login(OauthButtonType.google),
                        ),
                      if (!mode.isNone &&
                          isIosDevice &&
                          RemoteConfigs.isAppleAuthEnabled)
                        OnboardingAuthButton(
                          text: localize(
                            "button_2",
                            defaultValue: "Continue with Apple",
                          ),
                          logo: "assets/icons/ic_apple.svg",
                          fill: mode.isNormal || mode.isHard,
                          logoColor: mode.isSoft
                              ? color.icon.dark ?? color.base.dark
                              : color.icon.light ?? color.base.light,
                          onTap: () => _login(OauthButtonType.apple),
                        ),
                      if (!isViewMode &&
                          (mode.isSoft || mode.isNone) &&
                          !isAnywhereMode)
                        OnboardingFilledButton(
                          text: localize(
                            mode.isNone ? "button_4" : "button_3",
                            defaultValue: mode.isNone
                                ? "Continue"
                                : "Skip For Now",
                          ),
                          onTap: _next,
                        ),
                    ],
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
  String get name => "startup:login";
}
