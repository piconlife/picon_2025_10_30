import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:in_app_navigator/route.dart';
import 'package:in_app_translation/in_app_translation.dart';

import '../../app/res/icons.dart';
import '../../roots/widgets/auto_scroll.dart';
import '../../roots/widgets/fade.dart';
import '../../roots/widgets/gesture.dart';
import '../../roots/widgets/icon.dart';
import '../../roots/widgets/layout.dart';
import '../../roots/widgets/text.dart';

class LocaleBsd extends StatefulWidget {
  const LocaleBsd({super.key});

  static Future<Locale?> show(BuildContext context, [Iterable? locales]) {
    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: context.scaffoldColor.primary,
      builder: (context) => LocaleBsd(),
    );
  }

  @override
  State<LocaleBsd> createState() => _LocaleBsdState();
}

class _LocaleBsdState extends State<LocaleBsd>
    with TranslationMixin, ColorMixin {
  late final controller = ScrollController();

  void _change(Locale? value) => context.close(result: value);

  late double itemHeight = 65.0.dpOf(context);

  late List<Locale> locales =
      supportedLocales
        ..remove(Translation.i.defaultLocale)
        ..insert(0, Translation.i.defaultLocale);

  late List<Locale> downloadableLocales =
      kFilteredLocales.where((e) => !locales.contains(e)).toList();

  @override
  Widget build(BuildContext context) {
    final locale = this.locale;
    final dimen = context.dimens;
    return InAppAutoScroll(
      controller: controller,
      targetIndex: locales.indexOf(locale),
      adjustmentHeight: dimen.dy(15),
      itemHeight: itemHeight,
      child: InAppLayout(
        children: [
          _header(dimen),
          Divider(color: color.divider.soft),
          Expanded(
            child: InAppFade(
              fadeWidthFraction: 0.08,
              child: _items(dimen, controller),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(DimenData dimen) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 12,
        top: 24,
        bottom: 8,
      ).apply(dimen),
      child: InAppLayout(
        layout: LayoutType.row,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: InAppText(
              localize("select_language", defaultValue: "Select Language"),
              style: TextStyle(
                color: context.dark,
                fontWeight: context.semiBoldFontWeight,
                fontSize: 24,
              ).applyDimen(dimen),
            ),
          ),
          InAppGesture(
            onTap: context.close,
            child: Container(
              padding: EdgeInsets.all(8).apply(dimen),
              child: InAppIcon(
                InAppIcons.close.regular,
                size: 28.0.dp(dimen),
                color: context.dark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _items(DimenData dimen, [ScrollController? controller]) {
    final locales = this.locales;
    if (Translation.i.autoTranslateEnable) {
      locales.addAll(downloadableLocales);
    }
    if (locales.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(dimen.dp(32)),
        child: _label(
          dimen,
          localize("not_match", defaultValue: "Not match any locale!"),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: controller == null,
      physics:
          controller != null
              ? BouncingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
      controller: controller,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 50),
      itemCount: locales.length,
      itemBuilder: (context, index) {
        final e = locales.elementAt(index);
        return _item(dimen, e, index == 0, downloadableLocales.contains(e));
      },
      separatorBuilder: (context, index) => _divider(dimen),
    );
  }

  Widget _item(
    DimenData dimen,
    Locale item,
    bool defaultLocale, [
    bool isDownloadable = false,
  ]) {
    final name = item.nativeName ?? item.name ?? item.toString();
    return InAppGesture(
      onTap: () => _change(item),
      child: SizedBox(
        height: itemHeight,
        child: InAppLayout(
          layout: LayoutType.row,
          children: [
            _leading(dimen, kCountryFlags[item.countryCode]),
            const SizedBox(width: 24).apply(dimen),
            Expanded(
              child: _title(dimen, defaultLocale ? "Default ($name)" : name),
            ),
            if (item == locale || isDownloadable)
              item != locale ? _downloadIcon(dimen) : _trailing(dimen),
          ],
        ),
      ),
    );
  }

  Widget _label(DimenData dimen, String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dimen.dp(24)),
      child: Text(label, style: TextStyle(color: context.dark.t50)),
    );
  }

  Widget _title(DimenData dimen, String? text) {
    return InAppText(
      text ?? '',
      style: TextStyle(
        color: context.dark,
        fontWeight: context.semiBoldFontWeight,
        fontSize: 18,
      ),
    );
  }

  Widget _leading(DimenData dimen, String? text) {
    return Text(text ?? '', style: TextStyle(fontSize: dimen.dp(24)));
  }

  Widget _trailing(DimenData dimen) {
    return Container(
      decoration: BoxDecoration(
        color: color.base.secondary,
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(4).apply(dimen),
      child: InAppIcon(
        InAppIcons.check.regular,
        color: context.lightAsFixed,
        size: 18.0.dp(dimen),
      ),
    );
  }

  Widget _downloadIcon(DimenData dimen) {
    return Container(
      decoration: BoxDecoration(
        color: secondary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(4).apply(dimen),
      child: InAppIcon(Icons.download, color: secondary, size: 18.0.dp(dimen)),
    );
  }

  Widget _divider(DimenData dimen) {
    return Divider(height: 0, color: color.divider.soft);
  }

  @override
  String get name => "bsd_language";
}
