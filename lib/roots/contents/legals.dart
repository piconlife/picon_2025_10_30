import 'package:flutter_terms_viewer/flutter_terms_viewer.dart';
import 'package:in_app_configs/configs.dart';

const _kLegals = "legals";
const _kPrivacy = "privacy";
const _kTerms = "terms";
const _kTitle = "title";
const _kBody = "body";
const _kContents = "contents";

class Legals {
  final Legal privacy;
  final Legal terms;

  bool get isEmpty => privacy.isEmpty && terms.isEmpty;

  bool get isNotEmpty => !isEmpty;

  const Legals({this.privacy = const Legal(), this.terms = const Legal()});

  static Legals get get {
    final x = Configs.getByName(_kLegals, parser: Legals.parse);
    return x ?? Legals();
  }

  factory Legals.parse(Object? source, {Legals? defaultValue}) {
    if (source is! Map) return defaultValue ?? Legals();
    return Legals(
      privacy: Legal.parse(
        source[_kPrivacy],
        defaultValue: defaultValue?.privacy,
      ),
      terms: Legal.parse(source[_kTerms], defaultValue: defaultValue?.terms),
    );
  }

  Legals copy({Legal? privacy, Legal? terms}) {
    return Legals(privacy: privacy ?? this.privacy, terms: terms ?? this.terms);
  }

  @override
  String toString() => "$Legal($_kPrivacy: $privacy, $_kTerms: $terms)";
}

class Legal {
  final String? title;
  final String? body;
  final List<Terms> contents;

  bool get isEmpty {
    return (title ?? '').isEmpty && (body ?? '').isEmpty && contents.isEmpty;
  }

  bool get isNotEmpty => !isEmpty;

  const Legal({this.title, this.body, this.contents = const []});

  factory Legal.parse(Object? source, {Legal? defaultValue}) {
    if (source is! Map) return defaultValue ?? Legal();
    final title = source[_kTitle];
    final body = source[_kBody];
    final contents = source[_kContents];
    return Legal(
      title: title is String && title.isNotEmpty ? title : defaultValue?.title,
      body: body is String && body.isNotEmpty ? body : defaultValue?.body,
      contents:
          contents is List && contents.isNotEmpty
              ? contents.map(Terms.from).toList()
              : defaultValue?.contents ?? [],
    );
  }

  Legal copy({String? title, String? body, List<Terms>? contents}) {
    return Legal(
      title: title ?? this.title,
      body: body ?? this.body,
      contents: contents ?? this.contents,
    );
  }

  Map<String, dynamic> get json {
    return {
      _kTitle: title,
      _kBody: body,
      _kContents: contents.map((e) => e.json).toList(),
    };
  }

  @override
  String toString() {
    return "$Legal($_kTitle: $title, $_kBody: $body, $_kContents: $contents)";
  }
}
