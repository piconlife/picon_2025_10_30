import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';

typedef TextSpanParserTagTap = void Function(String sign, String tag);
typedef TextSpanParserTagStyle = TextStyle? Function(String sign);

class TextSpanParser {
  /// Default text style
  final TextStyle? defaultStyle;

  /// List of tag signs to recognize (e.g., ['#', '@', '$'])
  final List<String> tagSigns;

  /// Callback to get text style for a specific tag sign
  final TextStyle Function(String sign)? tagStyle;

  /// Callback triggered when a tag is tapped
  final TextSpanParserTagTap? onTagTap;

  const TextSpanParser({
    this.defaultStyle,
    this.tagSigns = const ['#', '@'],
    this.tagStyle,
    this.onTagTap,
  });

  /// Parse text and return list of TextSpans with styled tags
  List<TextSpan> parse(
    String? text, {
    TextSpanParserTagTap? onTagTap,
    TextSpanParserTagStyle? tagStyle,
  }) {
    if (text == null || text.isEmpty) return [];

    final List<TextSpan> spans = [];

    // Build regex pattern from tag signs (e.g., [#@]\w+)
    final String pattern =
        '[${tagSigns.map((s) => RegExp.escape(s)).join()}]\\w+';
    final RegExp tagRegex = RegExp(pattern);

    int currentIndex = 0;

    for (final match in tagRegex.allMatches(text)) {
      if (match.start > currentIndex) {
        spans.add(
          TextSpan(
            text: text.substring(currentIndex, match.start),
            style: defaultStyle,
          ),
        );
      }

      final String fullTag = match.group(0)!;
      final String sign = fullTag[0];

      tagStyle ??= this.tagStyle;
      onTagTap ??= this.onTagTap;

      spans.add(
        TextSpan(
          text: fullTag,
          style: tagStyle?.call(sign) ?? defaultStyle,
          recognizer:
              onTagTap != null
                  ? (TapGestureRecognizer()
                    ..onTap = () => onTagTap!(sign, fullTag))
                  : null,
        ),
      );

      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      spans.add(
        TextSpan(text: text.substring(currentIndex), style: defaultStyle),
      );
    }

    return spans.isEmpty ? [TextSpan(text: text, style: defaultStyle)] : spans;
  }

  TextSpan parseAsTextSpan(
    String? text, {
    TextSpanParserTagTap? onTagTap,
    TextSpanParserTagStyle? tagStyle,
  }) {
    return TextSpan(
      children: parse(text, tagStyle: tagStyle, onTagTap: onTagTap),
    );
  }
}
