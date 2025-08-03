import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/settings.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../configs/extensions/text_direction.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/column.dart';
import '../../../../roots/widgets/filled_button.dart';
import '../../../../roots/widgets/logo_trailing.dart';
import '../../../../roots/widgets/stack.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/paths.dart';

const kSeenTerms = "seen_terms";

bool get isTermsSeen => Settings.get(kSeenTerms, false);

class TermsInfo {
  final String id;
  final String? title;
  final String? subtitle;

  TermsInfo({required this.id, this.title, this.subtitle});

  static List<TermsInfo> get items {
    return List.generate(5, (index) {
      return TermsInfo(
        id: "$index",
        title: "Help apps find location",
        subtitle:
            "Tap to learn more about each service, such as how to turn it on or off later. Data will be used according to PicON's Privacy Policy",
      );
    });
  }
}

class TermsPage extends StatefulWidget {
  final Object? args;
  final bool isStartupMode;

  const TermsPage({super.key, this.args, this.isStartupMode = false});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage>
    with TranslationMixin, ColorMixin {
  final selections = <String>{};
  final items = TermsInfo.items;

  bool get isApproved => items.every((i) => selections.contains(i.id));

  void _accept() async {
    if (Settings.set(kSeenTerms, true)) {
      if (widget.isStartupMode) {
        context.next(Routes.terms, arguments: true);
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

  @override
  Widget build(BuildContext context) {
    final bg = context.light;
    return Scaffold(
      backgroundColor: bg,
      appBar: InAppAppbar(
        titleText: "Terms and Conditions",
        centerTitle: true,
        actions: [InAppLogoTrailing()],
      ),
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
                    ColoredBox(
                      color: context.dark.t02,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: InAppColumn(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: const [
                            InAppText(
                              "Terms Service and Conditions",
                              style: TextStyle(fontSize: 24),
                            ),
                            InAppText(
                              "Tap to learn more about each service, such as how to turn it on or off later. Data will be used according to PicON's Privacy Policy",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ColoredBox(
                      color: bg,
                      child: InAppColumn(
                        children: List.generate(items.length, (index) {
                          final item = items[index];
                          return CheckboxListTile(
                            enabled: !isTermsSeen,
                            value:
                                selections.contains(item.id) ||
                                isTermsSeen ||
                                isApproved,
                            activeColor: primary,
                            fillColor: WidgetStateProperty.resolveWith((
                              states,
                            ) {
                              if (states.contains(WidgetState.disabled)) {
                                return dark.t20;
                              }
                              return null;
                            }),
                            checkboxScaleFactor: 1.2,
                            side: BorderSide(
                              color: primary,
                              strokeAlign: BorderSide.strokeAlignInside,
                              width: 1.5,
                            ),
                            checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            contentPadding: const EdgeInsets.only(
                              left: 24,
                              right: 16,
                              top: 8,
                              bottom: 8,
                            ).directional,
                            title: Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: InAppText(
                                item.title,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            subtitle: InAppText(
                              item.subtitle,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: grey, fontSize: 14),
                            ),
                            onChanged: (b) => _checked(item.id),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isTermsSeen || widget.isStartupMode)
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
                          color: bg,
                          offset: Offset.zero,
                        ),
                      ],
                    ),
                    child: InAppFilledButton(
                      enabled: isApproved || widget.isStartupMode,
                      text: widget.isStartupMode ? "Next" : "Accept",
                      onTap: _accept,
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
  String get name => "about:terms";
}
