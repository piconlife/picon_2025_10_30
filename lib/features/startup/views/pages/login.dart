import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:auth_management/core.dart';
import 'package:auth_management/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:flutter_androssy_kits/widgets.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_analytics/analytics.dart';
import 'package:in_app_navigator/route.dart';

import '../../../../app/constants/app.dart';
import '../../../../app/res/icons.dart';
import '../../../../data/models/user.dart';
import '../../../../data/parsers/phone_parser.dart';
import '../../../../data/parsers/user_parser.dart';
import '../../../../data/parsers/validations.dart';
import '../../../../data/use_cases/user/find_user_by_phone.dart';
import '../../../../roots/helpers/connectivity.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/filled_button.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/logo_trailing.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/paths.dart';
import '../../preferences/startup.dart';
import '../widgets/or_text.dart';
import '../widgets/screen.dart';
import '../widgets/title_with_subtitle.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final etEmail = TextEditingController();
  final etPassword = TextEditingController();
  final etPhone = TextEditingController();
  final etEmailKey = GlobalKey<AndrossyFieldState>();
  final etPhoneKey = GlobalKey<AndrossyFieldState>();
  final etPasswordKey = GlobalKey<AndrossyFieldState>();
  final btnSubmitKey = GlobalKey<InAppFilledButtonState>();

  final isPhoneMode = ValueNotifier(false);

  void _change(int index) {
    isPhoneMode.value = index == 1;
    btnSubmitKey.currentState?.setActivated(index == 1);
  }

  void _submit(BuildContext context) async {
    final isConnected = await ConnectivityHelper.isConnected;
    if (!context.mounted) return;
    if (!isConnected) {
      context.showErrorSnackBar(ResponseMessages.internetDisconnected);
      return;
    }
    if (isPhoneMode.value) {
      _continueWithPhone(context);
      return;
    }
    _continueWithEmail(context);
  }

  void _continueWithPhone(BuildContext context) async {
    final number = parsePhoneNumber(null, etPhone.text.trim());
    if (number == null || !isValidPhoneNumber(number)) {
      context.showWarningSnackBar("Phone number hasn't valid!");
      return;
    }

    btnSubmitKey.currentState?.showLoading();
    final value = await Analytics.future(name: 'find_user_by_phone', () {
      return FindUserByPhoneUseCase.i(number.international);
    });
    btnSubmitKey.currentState?.hideLoading();
    if (!context.mounted) return;
    if (value == null || !value.status.isSuccessful || value.result.isEmpty) {
      context.showErrorSnackBar("User account not found!");
      return;
    }

    _continueWithPhoneOtp(context, value.result.first);
  }

  void _continueWithPhoneOtp(BuildContext context, UserModel user) {
    final phone = user.phone.use;
    final email = user.email.use;
    final password = UserParser.decryptPassword(user.password).use;
    if (!isValidNumber(phone) ||
        !isValidEmail(email) ||
        !isValidPassword(password)) {
      context.showErrorSnackBar("User account not valid!");
      return;
    }

    context.signInByPhone<UserModel>(
      PhoneAuthenticator(phone: phone),
      id: Routes.login,
      onCodeSent: (token, _) async {
        if (Startup.puts({
          StartupKeys.idToken: token,
          StartupKeys.phone: phone,
          StartupKeys.provider: Provider.phone.name,
        })) {
          final value = await context.open(Routes.otp);
          if (!context.mounted) return;

          if (value is! bool || !value) {
            context.showErrorSnackBar("Verification failed!");
            return;
          }

          _login(context, email, password);
        }
      },
      onFailed: (error) {
        context.showErrorSnackBar(error.msg);
      },
    );
  }

  void _continueWithEmail(BuildContext context) async {
    String email = etEmail.text.trim();
    String password = etPassword.text.trim();
    if (!isValidPrefixOrEmail(email)) {
      if (email.contains("@")) {
        context.showWarningSnackBar("Email hasn't valid!");
        return;
      }
      context.showWarningSnackBar("Prefix hasn't valid!");
      return;
    }

    if (!isValidPassword(password)) {
      context.showWarningSnackBar("Password hasn't valid!");
      return;
    }

    if (isValidPrefix(email)) {
      email = UserParser.asEmail(email) ?? email;
    }

    _login(context, email, password);
  }

  void _login(BuildContext context, String email, String password) async {
    if (email.isEmpty || password.isEmpty) return;
    Analytics.callAsync(name: 'sign_in_by_email', () {
      return context.signInByEmail<UserModel>(
        EmailAuthenticator(email: email, password: password),
        id: Routes.login,
        // onBiometric: (_) => context.show("biometric"),
      );
    });
  }

  void _loginWithBiometric(BuildContext context) {
    context.signInByBiometric<UserModel>(id: Routes.login);
  }

  void _register(BuildContext context) {
    context.open(Routes.intro);
  }

  void _forget(BuildContext context) {
    context.open(Routes.forgotPassword);
  }

  void _finally(BuildContext context, AuthChanges<UserModel> changes) {
    if (!changes.status.isAuthenticated || changes.user == null) return;
    context.clear(Routes.main);
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final primary = context.primary;
    return AuthObserver<UserModel>(
      ids: const [Routes.login],
      onError: (context, value) => context.showErrorSnackBar(value),
      onLoading: (_, value) => btnSubmitKey.currentState?.setLoading(value),
      onMessage: (context, value) => context.showSnackBar(value),
      onChanges: _finally,
      child: StartupScreen(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const InAppAppbar(
            titleText: "Sign in",
            actions: [InAppLogoTrailing()],
          ),
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.all(dimen.dp(24)).copyWith(top: dimen.dp(16)),
              children: [
                AuthTitleWithSubtitle(
                  title: "Login Account",
                  subtitle: "Hello, welcome back to our account!",
                  dimen: dimen,
                ),
                dimen.dp(24).h,
                Container(
                  width: double.infinity,
                  height: dimen.dp(50),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(dimen.dp(50)),
                    border: Border.all(
                      color: primary,
                      width: dimen.dp(2),
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                  padding: EdgeInsets.all(dimen.dp(2)),
                  child: AndrossyOption(
                    direction: Axis.horizontal,
                    flex: const AndrossyOptionProperty.all(10),
                    onChanged: _change,
                    itemCount: 2,
                    builder: (context, index, selected) {
                      return Container(
                        height: double.infinity,
                        alignment: Alignment.center,
                        decoration:
                            !selected
                                ? null
                                : BoxDecoration(
                                  color:
                                      selected ? primary : Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                    dimen.dp(50),
                                  ),
                                  border: Border.all(
                                    color: primary,
                                    width: dimen.dp(2),
                                  ),
                                ),
                        child: InAppText(
                          index == 1 ? "Phone" : "Email",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: context.boldFontWeight,
                            fontSize: dimen.dp(16),
                            color: selected ? context.lightAsFixed : primary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                dimen.dp(24).h,
                ValueListenableBuilder(
                  valueListenable: isPhoneMode,
                  builder: (context, value, child) {
                    if (value) {
                      return _PhoneMode(
                        primary: primary,
                        dimen: dimen,
                        etPhone: etPhone,
                        globalPhoneKey: etPhoneKey,
                        onValid:
                            (v) => btnSubmitKey.currentState?.setEnabled(v),
                        onSubmit: _submit,
                      );
                    } else {
                      return _EmailMode(
                        primary: primary,
                        dimen: dimen,
                        etPrefix: etEmail,
                        etPassword: etPassword,
                        globalPrefixKey: etEmailKey,
                        globalPasswordKey: etPasswordKey,
                        onForget: () => _forget(context),
                        onValid:
                            (v) => btnSubmitKey.currentState?.setEnabled(v),
                        onSubmit: () => _submit(context),
                      );
                    }
                  },
                ),
                dimen.dp(24).h,
                ValueListenableBuilder(
                  valueListenable: isPhoneMode,
                  builder: (_, value, child) {
                    return InAppFilledButton(
                      key: btnSubmitKey,
                      enabled: false,
                      text: value ? "Send OTP" : "Login",
                      onTap: () => _submit(context),
                    );
                  },
                ),
                _Footer(
                  dimen: dimen,
                  onBiometric: () => _loginWithBiometric(context),
                  onRegister: _register,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailMode extends StatelessWidget {
  final TextEditingController etPrefix;
  final TextEditingController etPassword;
  final GlobalKey<AndrossyFieldState> globalPrefixKey;
  final GlobalKey<AndrossyFieldState> globalPasswordKey;
  final Color? primary;
  final DimenData dimen;
  final VoidCallback? onForget;
  final ValueChanged<bool>? onValid;
  final VoidCallback? onSubmit;

  const _EmailMode({
    required this.primary,
    required this.dimen,
    required this.etPrefix,
    required this.etPassword,
    required this.globalPrefixKey,
    required this.globalPasswordKey,
    this.onForget,
    this.onValid,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return AndrossyForm(
      primaryColor: context.primary,
      secondaryColor: context.dark.t30,
      errorColor: ColorThemeHelper(context).error,
      animationDuration: const Duration(milliseconds: 300),
      borderColor: const AndrossyFieldProperty.auto(),
      borderRadius: AndrossyFieldProperty.all(
        BorderRadius.circular(dimen.dp(16)),
      ),
      contentPadding: EdgeInsets.all(dimen.dp(16)),
      counterVisibility: FloatingVisibility.hide,
      drawableStartTint: AndrossyFieldProperty(
        enabled: context.iconColor.primary,
        focused: primary,
      ),
      drawableEndTint: AndrossyFieldProperty(
        enabled: context.iconColor.primary,
        focused: primary,
      ),
      drawableStartPadding: AndrossyFieldProperty(enabled: dimen.dp(12)),
      drawableEndPadding: AndrossyFieldProperty(enabled: dimen.dp(4)),
      floatingVisibility: FloatingVisibility.hide,
      onValid: onValid,
      children: [
        AndrossyField(
          key: globalPrefixKey,
          autoDisposeMode: false,
          controller: etPrefix,
          hintText: "Email or Prefix",
          characters: "_.@1234567890abcdefghijklmnopqrstuvwxyz",
          inputType: TextInputType.emailAddress,
          inputAction: TextInputAction.next,
          drawableStart: AndrossyFieldProperty(
            enabled: InAppIcons.email.regular,
            focused: InAppIcons.email.solid,
          ),
          drawableEndBuilder: (context, controller) {
            if (etPrefix.text.contains("@")) return const SizedBox();
            return InAppText(
              AppConstants.domain,
              style: TextStyle(color: context.mid, fontSize: dimen.dp(18)),
            );
          },
          onValidator: isValidPrefixOrEmail,
        ),
        dimen.dp(24).h,
        AndrossyField(
          key: globalPasswordKey,
          controller: etPassword,
          autoDisposeMode: false,
          hintText: "Password",
          inputType: TextInputType.visiblePassword,
          inputAction: TextInputAction.done,
          drawableStart: AndrossyFieldProperty(
            enabled: InAppIcons.lock.regular,
            focused: InAppIcons.lock.solid,
          ),
          drawableEye: const AndrossyFieldTweenProperty(
            inactive: Icons.visibility_off_outlined,
            active: Icons.visibility_outlined,
          ),
          onValidator: isValidPassword,
          onSubmitted: onSubmit != null ? (_) => onSubmit!() : null,
        ),
        dimen.dp(8).h,
        Container(
          width: double.infinity,
          alignment: Alignment.centerRight,
          child: InAppGesture(
            onTap: onForget,
            child: InAppText(
              "Forgot Password?",
              style: TextStyle(color: primary, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}

class _PhoneMode extends StatelessWidget {
  final TextEditingController etPhone;
  final GlobalKey<AndrossyFieldState> globalPhoneKey;
  final Color? primary;
  final DimenData dimen;
  final ValueChanged<bool>? onValid;
  final ValueChanged<BuildContext>? onSubmit;

  const _PhoneMode({
    required this.primary,
    required this.dimen,
    required this.etPhone,
    required this.globalPhoneKey,
    this.onValid,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return AndrossyField(
      key: globalPhoneKey,
      controller: etPhone,
      autoDisposeMode: false,
      hintText: "Phone Number",
      characters: "+1234567890",
      inputType: TextInputType.phone,
      inputAction: TextInputAction.done,
      drawableStart: AndrossyFieldProperty(
        focused: InAppIcons.phone.solid,
        enabled: InAppIcons.phone.regular,
      ),
      drawableStartTint: AndrossyFieldProperty(
        enabled: context.iconColor.primary,
        disabled: context.iconColor.disable,
        focused: primary,
      ),
      onValidator: isValidNumber,
      primaryColor: context.primary,
      secondaryColor: context.dark.t30,
      errorColor: ColorThemeHelper(context).error,
      animationDuration: const Duration(milliseconds: 300),
      borderColor: const AndrossyFieldProperty.auto(),
      borderRadius: AndrossyFieldProperty.all(
        BorderRadius.circular(dimen.dp(16)),
      ),
      contentPadding: EdgeInsets.all(dimen.dp(16)),
      counterVisibility: FloatingVisibility.hide,
      drawableEndTint: AndrossyFieldProperty(
        enabled: context.mid,
        validFocused: primary,
      ),
      drawableStartPadding: AndrossyFieldProperty(enabled: dimen.dp(12)),
      drawableEndPadding: AndrossyFieldProperty(enabled: dimen.dp(4)),
      floatingPadding: EdgeInsets.symmetric(
        horizontal: dimen.dp(12),
        vertical: dimen.dp(4),
      ),
      floatingStyle: AndrossyFieldProperty(
        enabled: TextStyle(
          color: context.dark.t50,
          fontWeight: FontWeight.w500,
        ),
        focused: TextStyle(color: primary, fontWeight: FontWeight.w500),
      ),
      floatingVisibility: FloatingVisibility.hide,
      onValid: onValid,
      onSubmitted: onSubmit != null ? (_) => onSubmit!(context) : null,
    );
  }
}

class _Footer extends StatelessWidget {
  final DimenData dimen;
  final VoidCallback? onBiometric;
  final ValueChanged<BuildContext> onRegister;

  const _Footer({
    required this.dimen,
    this.onBiometric,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.primary;
    return Column(
      children: [
        dimen.dp(24).h,
        const OrText(text: "Or sign in with"),
        dimen.dp(24).h,
        Center(
          child: InAppGesture(
            onTap: onBiometric,
            child: CircleAvatar(
              radius: dimen.dp(25),
              backgroundColor: Colors.transparent,
              child: AuthConsumer<UserModel>(
                builder: (context, user) {
                  return InAppIcon(
                    Icons.fingerprint,
                    size: dimen.dp(40),
                    color:
                        (user?.biometric ?? false)
                            ? primary
                            : context.iconColor.mid,
                  );
                },
              ),
            ),
          ),
        ),
        dimen.dp(16).h,
        InAppText(
          "Not register yet? ",
          textAlign: TextAlign.center,
          suffix: "Create Account",
          suffixStyle: TextStyle(color: primary, fontWeight: FontWeight.bold),
          onSuffixClick: onRegister,
        ),
      ],
    );
  }
}
