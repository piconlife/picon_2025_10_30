import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/string.dart';
import 'package:flutter_andomie/utils/ordered_list_style.dart';
import 'package:flutter_terms_viewer/flutter_terms_viewer.dart';
import 'package:object_finder/object_finder.dart';

import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/body.dart';
import '../../../../roots/widgets/logo_trailing.dart';
import '../widgets/screen.dart';

class TermsReaderPage extends StatelessWidget {
  final Object? args;
  final bool isViewMode;

  const TermsReaderPage({
    super.key,
    required this.args,
    this.isViewMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    Terms terms = args.find(defaultValue: const Terms());
    final child = TermsViewer(
      data: terms,
      textStyleBuilder: (data, style, index) {
        return style.copyWith(color: context.dark);
      },
      orderTextBuilder: (data, index) {
        final position = data.position;
        if (position == 1) {
          return OrderedListStyle.lowerAlpha.sequence(index).join(".");
        }
        if (position == 2) {
          return OrderedListStyle.lowerRoman.sequence(index).join(".");
        }
        return null;
      },
      orderStyleBuilder: (data, style, index) {
        final position = data.position;
        final isTitle = data.title.isNotEmpty;
        if (position == 1) {
          return style.copyWith(color: context.dark);
        }
        if (position == 2) {
          return style.copyWith(
            color: context.dark,
            fontWeight: isTitle ? null : FontWeight.normal,
          );
        }
        return null;
      },
      titleStyleBuilder: (data, style, index) {
        return style.copyWith(color: context.dark);
      },
    );
    if (isViewMode) return child;
    return StartupScreen(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: InAppAppbar(
          titleText: terms.headline,
          actions: const [InAppLogoTrailing()],
        ),
        body: InAppBody(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: dimen.dp(24),
                right: dimen.dp(24),
                top: dimen.dp(16),
                bottom: dimen.dp(120),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
