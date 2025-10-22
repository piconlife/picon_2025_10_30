import 'dart:convert';

import 'package:in_app_translation/extensions.dart';

enum OnboardQuizType {
  option,
  preview,
  height,
  weight,
  none;

  factory OnboardQuizType.from(Object? source) {
    final x =
        values.where((e) {
          if (e.toString().toLowerCase() == source.toString().toLowerCase()) {
            return true;
          }
          if (e.name.toLowerCase() == source.toString().toLowerCase()) {
            return true;
          }
          if (e.index == source) return true;
          return false;
        }).firstOrNull;
    if (x != null) return x;
    return option;
  }
}

class OnboardQuiz {
  final String? name;
  final OnboardQuizType? type;
  final String? title;
  final String? body;
  final String? image;
  final List<String> tabs;
  final List<String> options;
  final OnboardTips? tips;

  bool get isEnabled => type != OnboardQuizType.option;

  const OnboardQuiz({
    this.name,
    this.type,
    this.title,
    this.body,
    this.image,
    this.tabs = const [],
    this.options = const [],
    this.tips,
  });

  factory OnboardQuiz.from(Object? source) {
    if (source is String) source = jsonDecode(source);
    if (source is! Map) return OnboardQuiz();
    final name = source['name'];
    final type = source['type'];
    final title = source['title'] ?? source['header'];
    final body = source['body'] ?? source['description'];
    final image = source['image'] ?? source['photo'];
    final tabs = source['tabs'];
    final tips = source['tips'];
    final options = source['options'];
    return OnboardQuiz(
      name:
          name is String
              ? name.trWithOption(
                applyRtl: true,
                applyTranslator: true,
                applyNumber: true,
              )
              : null,
      type: OnboardQuizType.from(type),
      title:
          title is String
              ? title.trWithOption(
                applyRtl: true,
                applyTranslator: true,
                applyNumber: true,
              )
              : null,
      body:
          body is String
              ? body.trWithOption(
                applyRtl: true,
                applyTranslator: true,
                applyNumber: true,
              )
              : null,
      tips: OnboardTips.from(tips),
      image: image is String ? image : null,
      tabs:
          tabs is List
              ? tabs
                  .map(
                    (e) => e.toString().trWithOption(
                      applyRtl: true,
                      applyTranslator: true,
                      applyNumber: true,
                    ),
                  )
                  .toList()
              : [],
      options:
          options is List
              ? options
                  .map(
                    (e) => e.toString().trWithOption(
                      applyRtl: true,
                      applyTranslator: true,
                      applyNumber: true,
                    ),
                  )
                  .toList()
              : [],
    );
  }
}

class OnboardTips {
  final int? index;
  final String? title;
  final String? body;

  bool get isValid {
    return (title?.isNotEmpty ?? false) && (body?.isNotEmpty ?? false);
  }

  bool get isNotEmpty => (title ?? body ?? '').isNotEmpty;

  const OnboardTips({this.index, this.title, this.body});

  factory OnboardTips.from(Object? source) {
    if (source is String) source = jsonDecode(source);
    if (source is! Map) return OnboardTips();
    final index = source['index'];
    final title = source['title'] ?? source['header'];
    final body = source['body'] ?? source['description'];
    return OnboardTips(
      index: index is num ? index.toInt() : null,
      title:
          title is String
              ? title.trWithOption(
                applyRtl: true,
                applyTranslator: true,
                applyNumber: true,
              )
              : null,
      body:
          body is String
              ? body.trWithOption(
                applyRtl: true,
                applyTranslator: true,
                applyNumber: true,
              )
              : null,
    );
  }
}
