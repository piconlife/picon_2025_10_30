import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:flutter_androssy_kits/widgets.dart';

import '../../app/styles/fonts.dart';

class InAppText extends AndrossyText {
  const InAppText(
    super.data, {
    super.key,
    super.ellipsis,
    super.locale,
    super.maxLines,
    super.selectionColor,
    super.semanticsLabel,
    super.softWrap,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.textHeightBehavior,
    super.overflow,
    super.textScaler,
    super.spans = const [],
    super.style,
    super.textWidthBasis = TextWidthBasis.parent,
    super.onClick,

    ///PREFIX
    super.prefix,
    super.prefixStyle,
    super.onPrefixClick,

    ///SUFFIX
    super.suffix,
    super.suffixStyle,
    super.onSuffixClick,
    super.translate = false,
  });

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    return AndrossyText(
      data,
      ellipsis: ellipsis,
      locale: locale,
      maxLines: maxLines,
      onClick: onClick,
      onPrefixClick: onPrefixClick,
      onSuffixClick: onSuffixClick,
      prefix: prefix,
      prefixStyle: prefixStyle.applyDimen(dimen),
      selectionColor: selectionColor,
      semanticsLabel: semanticsLabel,
      softWrap: softWrap,
      strutStyle: strutStyle,
      suffix: suffix,
      suffixStyle: suffixStyle.applyDimen(dimen),
      textAlign: textAlign,
      textDirection: textDirection ?? Translation.textDirection,
      textHeightBehavior: textHeightBehavior,
      overflow: overflow,
      textScaler: textScaler,
      spans: spans,
      style: (style ?? TextStyle())
          .copyWith(
            color: style?.color ?? context.textColor.primary ?? context.dark,
            fontFamily: style?.fontFamily ?? InAppFonts.primary,
            fontWeight: style?.fontWeight ?? context.normalFontWeight,
          )
          .applyDimen(dimen),
      textWidthBasis: textWidthBasis,
      translate: translate,
    );
  }
}
