import 'dart:convert';

import 'package:in_app_configs/configs.dart';

const kLanguages = "languages";

class InAppLanguage {
  final String? id;
  final String? label;
  final String? ios;

  const InAppLanguage({this.id, this.label, this.ios});

  factory InAppLanguage.parse(Object? source, {String? id}) {
    if (source is String) source = jsonDecode(source);
    if (source is MapEntry) {
      id ??= source.key;
      source = source.value;
    }
    if (source is! Map) return InAppLanguage();
    id ??= source['key'] ?? source["id"] ?? source["code"];
    final label = source['name'] ?? source["label"];
    final ios = source['iso'];
    return InAppLanguage(
      id: id is String && id.isNotEmpty ? id : null,
      label: label is String && label.isNotEmpty ? label : null,
      ios: ios is String && ios.isNotEmpty ? ios : null,
    );
  }

  static List<InAppLanguage>? _cache;

  static List<InAppLanguage> get cache {
    if (_cache != null) return _cache!;
    _cache = items;
    return _cache!;
  }

  static List<InAppLanguage> get items {
    final data = Configs.getByName("languages");
    if (data is List && data.isNotEmpty) {
      return data.map(InAppLanguage.parse).toList();
    }
    if (data is Map && data.isNotEmpty) {
      return data.entries.map(InAppLanguage.parse).toList();
    }
    return [];
  }

  static List<String> get labels {
    final data = items.map((e) => e.label).whereType<String>();
    if (data.isEmpty) return [];
    return data.toList();
  }

  static InAppLanguage? of(Object? source) {
    return cache.where((e) {
      if (e.id == source) return true;
      if (e.ios == source) return true;
      if (e.label == source) return true;
      return false;
    }).firstOrNull;
  }

  @override
  String toString() {
    return '$InAppLanguage(id: $id, label: $label, ios: $ios)';
  }
}
