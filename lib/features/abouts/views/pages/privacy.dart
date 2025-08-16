import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/string.dart';
import 'package:flutter_andomie/utils/configs.dart';
import 'package:flutter_andomie/utils/settings.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:flutter_terms_viewer/flutter_terms_viewer.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/constants/app.dart';
import '../../../../roots/contents/legals.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/column.dart';
import '../../../../roots/widgets/filled_button.dart';
import '../../../../roots/widgets/logo_trailing.dart';
import '../../../../roots/widgets/stack.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/paths.dart';
import '../widgets/screen.dart';

const kSeenPrivacy = "seen_privacy";

bool get isSeenPrivacy => Settings.get(kSeenPrivacy, false);

class PrivacyPage extends StatefulWidget {
  final Object? args;
  final bool isStartupMode;

  const PrivacyPage({super.key, this.args, this.isStartupMode = false});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage>
    with TranslationMixin, ColorMixin {
  Legal? _legal;

  Legal get legal {
    if (_legal == null || _legal!.isEmpty) {
      _legal = Legals.get.privacy;
    }
    return _legal!;
  }

  final selections = <String>{};

  bool get isApproved =>
      isSeenPrivacy ||
      legal.contents.every((i) => selections.contains(i.headline));

  void _accept() async {
    if (Settings.set(kSeenPrivacy, true)) {
      if (widget.isStartupMode) {
        context.next(Routes.privacy, arguments: true);
      } else {
        context.close();
      }
    } else {
      final value = await context.showAlert(
        title: "Something went wrong, please try again?",
        positiveButtonText: "Try Again",
        negativeButtonText: "Cancel",
      );
      if (value) {
        _accept();
      } else {
        if (!mounted) return;
        context.close();
      }
    }
  }

  void _checked(String id) {
    if (selections.contains(id)) {
      selections.remove(id);
    } else {
      selections.add(id);
    }
    setState(() {});
  }

  void _learnDetails(BuildContext context, Terms terms) {
    context.open(Routes.terms, arguments: terms);
  }

  void _listener() {
    setState(() => _legal = Legals.get.terms);
  }

  @override
  void initState() {
    super.initState();
    Configs.i.addListener(_listener);
  }

  @override
  void dispose() {
    Configs.i.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = context.dark;
    final primary = context.primary;
    return InfoScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: InAppAppbar(
          titleText: "Privacy Policy",
          centerTitle: true,
          actions: [InAppLogoTrailing()],
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SizedBox.expand(
            child: InAppStack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 100),
                  child: InAppColumn(
                    spacing: 2,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: dark.t02,
                          border: Border(
                            bottom: BorderSide(color: dark.t05, width: 1),
                          ),
                        ),
                        child: InAppColumn(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            InAppText(
                              legal.title,
                              style: TextStyle(fontSize: 24),
                            ),
                            InAppText(
                              legal.body?.replaceAll(
                                "{APP_NAME}",
                                AppConstants.name,
                              ),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (legal.contents.isNotEmpty)
                        InAppColumn(
                          children: List.generate(legal.contents.length, (i) {
                            final item = legal.contents[i];
                            return CheckboxListTile(
                              enabled: !isSeenPrivacy,
                              value:
                                  selections.contains(item.headline) ||
                                  isSeenPrivacy ||
                                  isApproved,
                              activeColor: primary,
                              contentPadding: EdgeInsets.only(
                                left: 24,
                                right: 16,
                                top: 8,
                                bottom: 8,
                              ),
                              title: InAppText(
                                item.headline?.replaceAll(
                                  "{APP_NAME}",
                                  AppConstants.name,
                                ),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: context.mediumFontWeight,
                                ),
                              ),
                              subtitle: item.body.use.isEmpty
                                  ? null
                                  : Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: InAppText(
                                        item.body?.replaceAll(
                                          "{APP_NAME}",
                                          AppConstants.name,
                                        ),
                                        suffix: " more",
                                        onSuffixClick: (context) =>
                                            _learnDetails(context, item),
                                        suffixStyle: TextStyle(color: primary),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: dark.t50,
                                        ),
                                      ),
                                    ),
                              onChanged: (value) =>
                                  _checked(item.headline ?? ''),
                            );
                          }),
                        ),
                    ],
                  ),
                ),
                if (!isSeenPrivacy || widget.isStartupMode)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 500),
                      padding: EdgeInsets.only(left: 50, right: 50, bottom: 24),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15,
                            spreadRadius: 25,
                            color: scaffoldColor.primary ?? light,
                            offset: Offset.zero,
                          ),
                        ],
                      ),
                      child: InAppFilledButton(
                        enabled: isApproved,
                        text: widget.isStartupMode ? "Next" : "Accept",
                        onTap: _accept,
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
  String get name => "about:privacy";
}
