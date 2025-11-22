import 'dart:developer';

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
import 'package:in_app_navigator/route.dart';
import 'package:in_app_translation/utils/country.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../../../../app/constants/limitations.dart';
import '../../../../app/interfaces/bsd_country.dart';
import '../../../../app/res/icons.dart';
import '../../../../data/models/user.dart';
import '../../../../data/parsers/errors.dart';
import '../../../../data/parsers/phone_parser.dart';
import '../../../../data/parsers/user_parser.dart';
import '../../../../data/parsers/validations.dart';
import '../../../../data/use_cases/unifier/check_phone.dart';
import '../../../../data/use_cases/unifier/create_user_phone.dart';
import '../../../../data/use_cases/unifier/update_user_name.dart';
import '../../../../data/use_cases/unifier/update_user_prefix.dart';
import '../../../../roots/helpers/location.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/filled_button.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/logo_trailing.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/keys.dart';
import '../../../../routes/paths.dart';
import '../../preferences/global.dart';
import '../../preferences/startup.dart';
import '../widgets/screen.dart';
import '../widgets/title_with_subtitle.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final etEmailKey = GlobalKey<AndrossyFieldState>();
  final etPhoneKey = GlobalKey<AndrossyFieldState>();
  final etPasswordKey = GlobalKey<AndrossyFieldState>();
  final btnSubmit = GlobalKey<InAppFilledButtonState>();

  final etEmail = TextEditingController();
  final etPhone = TextEditingController();
  final etPassword = TextEditingController();

  final codeNotifier = ValueNotifier(
    Country.fromCode(Startup.i.isoCode ?? Global.i.countryIsoCode.use),
  );

  PhoneNumber? get phoneNumber {
    final code = codeNotifier.value.code;
    final nsn = etPhone.text.trim();
    if (nsn.isEmpty) return null;
    final number = parsePhoneNumber(code, nsn);
    return number;
  }

  void _changePhoneCode(Country country) {
    codeNotifier.value = country;
    etPhoneKey.currentState?.update();
    Global.put({
      GlobalKeys.currencyCode: country.currencyCode,
      GlobalKeys.currencyName: country.currencyName,
      GlobalKeys.currencySymbol: country.currencySymbol,
      GlobalKeys.countryIsoCode: country.code,
      GlobalKeys.countryIso3Code: country.codeInIso3,
      GlobalKeys.countryLocale: country.locale,
      GlobalKeys.countryLanguageCode: country.languageCode,
      GlobalKeys.countryLanguageName: country.languageName,
      GlobalKeys.countryName: country.name,
      GlobalKeys.countryPhoneCode: country.phoneCode,
    });
  }

  Future<AndrossyFieldError> _check(String value) async {
    if (phoneNumber == null) return AndrossyFieldError.invalid;
    btnSubmit.currentState?.setEnabled(false);
    final response = await CheckPhoneUseCase.i(phoneNumber!.international);
    if (response.status == Status.networkError) {
      return AndrossyFieldError.networkError;
    }
    final remote = response.result.firstOrNull;
    if (remote?.value == null || remote?.value == Startup.i.phone) {
      if (!(remote?.verified ?? false)) return AndrossyFieldError.none;
    }
    return AndrossyFieldError.alreadyFound;
  }

  Future<bool> _isCheckedPhone(String number) async {
    final status = await _check(number);
    return status == AndrossyFieldError.none;
  }

  void _submit(BuildContext context) async {
    final country = codeNotifier.value;

    final number = phoneNumber;
    if (number == null ||
        !(await _isCheckedPhone(number.international)) ||
        !isValidPhoneNumber(number)) {
      if (!context.mounted) return;
      context.showWarningSnackBar("Phone number hasn't valid!");
      return;
    }

    if (!context.mounted) return;
    final email = etEmail.text.trim();
    if (!isValidEmail(email)) {
      context.showWarningSnackBar("Email hasn't valid!");
      return;
    }

    final password = etPassword.text.trim();

    if (!isValidPassword(password)) {
      context.showWarningSnackBar("Password hasn't valid!");
      return;
    }

    _verify(context, number.international, password, country);
  }

  void _verify(
    BuildContext context,
    String phone,
    String password,
    Country country,
  ) {
    context.signInByPhone<UserModel>(
      PhoneAuthenticator(phone: phone),
      id: Routes.password,
      onCodeSent: (token, _) async {
        if (Startup.puts({
          StartupKeys.idToken: token,
          StartupKeys.phone: phone,
          StartupKeys.provider: Provider.phone.id,
        })) {
          final value = await context.open(Routes.otp);
          if (!context.mounted) return;
          if (value is! bool || !value) {
            context.showErrorSnackBar("Verification failed!");
            return;
          }
          _login(context, phone, password, country);
        }
      },
      onFailed: (error) {
        context.showErrorSnackBar(error.msg);
      },
    );
  }

  Future<void> _login(
    BuildContext context,
    String phone,
    String password,
    Country country,
  ) async {
    if (Startup.puts({
      StartupKeys.isoCode: country.code,
      StartupKeys.languageCode: country.languageCode,
      StartupKeys.phone: phone,
      StartupKeys.password: UserParser.encryptPassword(password),
    })) {
      await context.signOut<UserModel>(id: Routes.password);
      await Future.delayed(const Duration(seconds: 1));
      if (!context.mounted) return;
      final email = Startup.i.email.use;
      if (email.isEmpty || password.isEmpty) return;
      context.signUpByEmail<UserModel>(
        EmailAuthenticator(email: email, password: password),
        id: Routes.password,
      );
    }
  }

  Future<void> _finally(
    BuildContext context,
    AuthChanges<UserModel> changes,
  ) async {
    final user = changes.user;
    if (!changes.status.isAuthenticated || user == null) return;

    final phone = Startup.i.phone;
    if (phone != null) await CreateUserPhoneUseCase.i(phone);

    final username = Startup.i.shortname;
    if (username != null) await UpdateUserNameUseCase.i(username);

    final prefix = UserParser.asPrefix(Startup.i.email);
    if (prefix != null) await UpdateUserPrefixUseCase.i(prefix);

    Startup.clear();
    log("_finally_done");

    if (!context.mounted) return;
    context.clear(
      Routes.editUserProfilePhoto,
      args: {kRouteOnboardingMode: true},
    );
  }

  @override
  void initState() {
    super.initState();
    etEmail.text = Startup.i.email.use;
    final isoCode = Startup.i.isoCode;
    final phone = Startup.i.phone;
    if (isoCode != null &&
        phone != null &&
        isoCode.isNotEmpty &&
        phone.isNotEmpty) {
      etPhone.text = parsePhoneNumber(isoCode, phone)?.nsn ?? "";
    }
    LocationHelper.get()
        .then((e) => Country.fromCode(e.countryCode.use))
        .then((value) => codeNotifier.value = value);
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final primary = context.primary;
    return AuthObserver<UserModel>(
      ids: const [Routes.password],
      onError: (context, value) => context.showErrorSnackBar(value),
      onLoading: (context, value) => btnSubmit.currentState?.setLoading(value),
      onMessage: (context, value) => context.showSnackBar(value),
      onChanges: _finally,
      child: StartupScreen(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const InAppAppbar(
            titleText: "Password",
            actions: [InAppLogoTrailing()],
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: dimen.dp(32),
              vertical: dimen.dp(24),
            ),
            children: [
              AuthTitleWithSubtitle(
                dimen: dimen,
                title: "Create a new account",
                subtitle: "Secure your account with a strong password.",
              ),
              dimen.dp(32).h,
              AndrossyForm(
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
                  enabled: context.iconColor.primary,
                  error: context.iconColor.error,
                  focused: primary,
                ),
                drawableStartTint: AndrossyFieldProperty(
                  enabled: context.iconColor.primary,
                  error: context.iconColor.error,
                  focused: primary,
                ),
                drawableStartPadding: AndrossyFieldProperty(
                  enabled: dimen.dp(12),
                ),
                drawableEndPadding: AndrossyFieldProperty(enabled: dimen.dp(4)),
                floatingPadding: EdgeInsets.symmetric(
                  horizontal: dimen.dp(12),
                  vertical: dimen.dp(4),
                ),
                floatingVisibility: FloatingVisibility.always,
                onValid: (v) => btnSubmit.currentState?.setEnabled(v),
                children: [
                  AndrossyField(
                    key: etPhoneKey,
                    controller: etPhone,
                    characters: "0123456789",
                    floatingText: "Phone Number",
                    hintText: "Phone Number",
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.phone,
                    drawableStart: AndrossyFieldProperty(
                      enabled: InAppIcons.phone.regular,
                      focused: InAppIcons.phone.solid,
                    ),
                    contentPadding: EdgeInsets.only(right: dimen.dp(16)),
                    drawableStartBuilder: (context, state) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InAppGesture(
                            onTap:
                                () => CountryPicker.phone(context)?.then((v) {
                                  if (v is Country) _changePhoneCode(v);
                                }),
                            child: Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.only(
                                left: dimen.dp(16),
                                top: dimen.dp(16),
                                bottom: dimen.dp(16),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ValueListenableBuilder(
                                    valueListenable: codeNotifier,
                                    builder: (context, value, child) {
                                      return InAppText(
                                        value.phoneCode ?? "Code",
                                        style: state.style.copyWith(
                                          fontWeight: context.mediumFontWeight,
                                        ),
                                      );
                                    },
                                  ),
                                  InAppIcon(
                                    Icons.arrow_drop_down,
                                    color: context.iconColor.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: dimen.dp(2),
                            height: dimen.dp(24),
                            color: context.dark.t10,
                            margin: EdgeInsets.only(right: dimen.dp(8)),
                          ),
                        ],
                      );
                    },
                    onCheck: _check,
                    onError: AuthErrors.phone,
                    onValidator:
                        (value) => isValidPhone(codeNotifier.value.code, value),
                  ),
                  dimen.dp(24).h,
                  AndrossyField(
                    key: etEmailKey,
                    enabled: false,
                    controller: etEmail,
                    hintText: "Email",
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.emailAddress,
                    drawableStart: AndrossyFieldProperty(
                      enabled: InAppIcons.email.regular,
                      focused: InAppIcons.email.solid,
                    ),
                  ),
                  dimen.dp(24).h,
                  AndrossyField(
                    key: etPasswordKey,
                    controller: etPassword,
                    hintText: "Password",
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.visiblePassword,
                    obscureText: true,
                    drawableStart: AndrossyFieldProperty(
                      enabled: InAppIcons.lock.regular,
                      focused: InAppIcons.lock.solid,
                    ),
                    drawableEye: const AndrossyFieldTweenProperty(
                      inactive: Icons.visibility_off_outlined,
                      active: Icons.visibility_outlined,
                    ),
                    maxCharacters: Limitations.maxPassword,
                    minCharacters: Limitations.minPassword,
                    counterVisibility: FloatingVisibility.always,
                    onError: AuthErrors.password,
                    onValidator: isValidPassword,
                  ),
                ],
              ),
              dimen.dp(24).h,
              InAppFilledButton(
                enabled: false,
                key: btnSubmit,
                text: "Next",
                onTap: () => _submit(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
