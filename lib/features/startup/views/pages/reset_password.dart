import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:auth_management/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:flutter_androssy_kits/widgets.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_navigator/route.dart';
import 'package:object_finder/object_finder.dart';

import '../../../../app/res/icons.dart';
import '../../../../data/models/user.dart';
import '../../../../data/parsers/validations.dart';
import '../../../../data/use_cases/unifier/update_user_password.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/filled_button.dart';
import '../../../../roots/widgets/logo_trailing.dart';
import '../../../../routes/paths.dart';
import '../widgets/screen.dart';
import '../widgets/title_with_subtitle.dart';

class ResetPasswordPage extends StatefulWidget {
  final Object? args;

  const ResetPasswordPage({super.key, this.args});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final etPassword = TextEditingController();
  final etRetypePassword = TextEditingController();
  final etPasswordKey = GlobalKey<AndrossyFieldState>();
  final etRetypePasswordKey = GlobalKey<AndrossyFieldState>();
  final btnSubmitKey = GlobalKey<InAppFilledButtonState>();

  bool _isValidRetypePassword(String value) {
    final password = etPassword.text.trim();
    if (password.isEmpty || value.isEmpty) return false;
    return isValidPassword(password) && password == value;
  }

  void _submit(BuildContext context) async {
    UserModel? user = widget.args.findOrNull();
    if (user == null) {
      context.showErrorSnackBar("User hasn't valid!");
      return;
    }

    final password = etPassword.text.trim();

    if (!_isValidRetypePassword(password)) {
      context.showWarningSnackBar("Password hasn't valid!");
      return;
    }

    btnSubmitKey.currentState?.showLoading();
    final response = await UpdateUserPasswordUseCase.i(
      uid: user.id,
      password: password,
    );
    if (!context.mounted) return btnSubmitKey.currentState?.hideLoading();
    if (!response.status.isSuccessful || response.error.isNotEmpty) {
      btnSubmitKey.currentState?.hideLoading();
      context.showErrorSnackBar(response.error);
      return;
    }
    await context.signOut<UserModel>();
    btnSubmitKey.currentState?.hideLoading();
    if (context.mounted) context.clear(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final primary = context.primary;
    return StartupScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const InAppAppbar(
          titleText: "Reset Password",
          actions: [InAppLogoTrailing()],
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(dimen.dp(24)),
            children: [
              AuthTitleWithSubtitle(
                title: 'Reset Password',
                subtitle:
                    "Set the new password for your account. So you can login and access all the features.",
                dimen: dimen,
              ),
              dimen.dp(32).h,
              AndrossyForm(
                primaryColor: primary,
                secondaryColor: context.dark.t30,
                errorColor: ColorThemeHelper(context).error,
                animationDuration: const Duration(milliseconds: 300),
                borderColor: const AndrossyFieldProperty.auto(),
                borderRadius: AndrossyFieldProperty.all(
                  BorderRadius.circular(dimen.dp(16)),
                ),
                contentPadding: EdgeInsets.all(dimen.dp(16)),
                drawableEndTint: AndrossyFieldProperty(
                  enabled: context.iconColor.primary,
                  disabled: context.iconColor.disable,
                  error: context.iconColor.error,
                ),
                drawableStartTint: AndrossyFieldProperty(
                  enabled: context.iconColor.primary,
                  error: context.iconColor.error,
                  disabled: context.iconColor.disable,
                ),
                drawableStartPadding: AndrossyFieldProperty(
                  enabled: dimen.dp(12),
                ),
                drawableEndPadding: AndrossyFieldProperty(enabled: dimen.dp(4)),
                floatingPadding: EdgeInsets.symmetric(
                  horizontal: dimen.dp(12),
                  vertical: dimen.dp(4),
                ),
                onValid: (v) => btnSubmitKey.currentState?.setEnabled(v),
                children: [
                  AndrossyField(
                    key: etPasswordKey,
                    controller: etPassword,
                    hintText: "New Password",
                    inputType: TextInputType.visiblePassword,
                    inputAction: TextInputAction.next,
                    drawableStart: AndrossyFieldProperty(
                      enabled: InAppIcons.lock.regular,
                      focused: InAppIcons.lock.solid,
                    ),
                    drawableEye: const AndrossyFieldTweenProperty(
                      inactive: Icons.visibility_outlined,
                      active: Icons.visibility_off_outlined,
                    ),
                    onValidator: isValidPassword,
                  ),
                  dimen.dp(24).h,
                  AndrossyField(
                    key: etRetypePasswordKey,
                    controller: etRetypePassword,
                    hintText: "Confirm Password",
                    inputType: TextInputType.visiblePassword,
                    inputAction: TextInputAction.done,
                    drawableStart: AndrossyFieldProperty(
                      enabled: InAppIcons.lock.regular,
                      focused: InAppIcons.lock.solid,
                    ),
                    drawableEye: const AndrossyFieldTweenProperty(
                      inactive: Icons.visibility_outlined,
                      active: Icons.visibility_off_outlined,
                    ),
                    onValidator: _isValidRetypePassword,
                    onSubmitted: (_) => _submit(context),
                  ),
                ],
              ),
              dimen.dp(24).h,
              InAppFilledButton(
                key: btnSubmitKey,
                enabled: false,
                text: "Update",
                onTap: () => _submit(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
