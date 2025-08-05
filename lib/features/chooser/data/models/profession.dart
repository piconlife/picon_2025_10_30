import 'dart:convert';

import 'package:flutter_andomie/utils/configs.dart';

class InAppProfession {
  final String? id;
  final String? label;

  const InAppProfession({this.id, this.label});

  factory InAppProfession.parse(Object? source, {String? id}) {
    if (source is String) source = jsonDecode(source);
    if (source is MapEntry) {
      id ??= source.key;
      source = source.value;
    }
    if (source is! Map) return InAppProfession();
    id ??= source['key'] ?? source["id"];
    final label = source['name'] ?? source["label"];
    return InAppProfession(
      id: id is String && id.isNotEmpty ? id : null,
      label: label is String && label.isNotEmpty ? label : null,
    );
  }

  static List<InAppProfession>? _cache;

  static List<InAppProfession> get cache {
    if (_cache != null) return _cache!;
    _cache = items;
    return _cache!;
  }

  static List<InAppProfession> get items {
    final data = Configs.load(name: "professions");
    if (data is List && data.isNotEmpty) {
      return data.map(InAppProfession.parse).toList();
    }
    if (data is Map && data.isNotEmpty) {
      return data.entries.map(InAppProfession.parse).toList();
    }
    return [];
  }

  static List<String> get labels {
    final data = items.map((e) => e.label).whereType<String>();
    if (data.isEmpty) return [];
    return data.toList();
  }

  static InAppProfession? of(Object? source) {
    return cache.where((e) {
      if (e.id == source) return true;
      if (e.label == source) return true;
      return false;
    }).firstOrNull;
  }

  @override
  String toString() {
    return '$InAppProfession(id: $id, label: $label)';
  }
}
