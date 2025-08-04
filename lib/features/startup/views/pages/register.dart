import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:in_app_navigator/in_app_navigator.dart';
import 'package:picon/roots/widgets/appbar.dart';

import '../../../../app/constants/app.dart';
import '../../../../roots/widgets/bottom.dart';
import '../../../../roots/widgets/column.dart';
import '../../../../roots/widgets/filled_button.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/screen.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/paths.dart';

class RegisterPage extends StatefulWidget {
  final Object? args;

  const RegisterPage({super.key, this.args});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TranslationMixin, ColorMixin {
  void _signIn() => context.close();

  void _next() => context.next(Routes.register, arguments: true);

  @override
  Widget build(BuildContext context) {
    return InAppScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: InAppAppbar.hide(),
        body: SizedBox.expand(
          child: InAppColumn(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: InAppColumn(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 24,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: InAppColumn(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InAppText(
                              "Join with ${AppConstants.name}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InAppText(
                              "We'll help you create a new account in a few easy steps.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      InAppFilledButton(text: "Next", onTap: _next),
                    ],
                  ),
                ),
              ),
              InAppBottom(
                child: InAppGesture(
                  onTap: _signIn,
                  child: ColoredBox(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: InAppColumn(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 4,
                          children: [
                            InAppText(
                              "Already have an account?",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: grey, fontSize: 14),
                            ),
                            InAppText(
                              "Continue with Email",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: primary, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  String get name => "startup:register";
}
