import 'dart:convert';

import 'package:flutter_andomie/utils/configs.dart';

class InAppHobby {
  final String? id;
  final String? label;
  final String? category;

  const InAppHobby({this.id, this.label, this.category});

  factory InAppHobby.parse(Object? source, {String? id}) {
    if (source is String) source = jsonDecode(source);
    if (source is MapEntry) {
      id ??= source.key;
      source = source.value;
    }
    if (source is! Map) return InAppHobby();
    id ??= source['key'] ?? source["id"];
    final label = source['name'] ?? source["label"];
    final category = source['category'];
    return InAppHobby(
      id: id is String && id.isNotEmpty ? id : null,
      label: label is String && label.isNotEmpty ? label : null,
      category: category is String && category.isNotEmpty ? category : null,
    );
  }

  static List<InAppHobby>? _cache;

  static List<InAppHobby> get cache {
    if (_cache != null) return _cache!;
    _cache = items;
    return _cache!;
  }

  static List<InAppHobby> get items {
    final data = Configs.load(name: "hobbies");
    if (data is List && data.isNotEmpty) {
      return data.map(InAppHobby.parse).toList();
    }
    if (data is Map && data.isNotEmpty) {
      return data.entries.map(InAppHobby.parse).toList();
    }
    return [];
  }

  static List<String> get labels {
    final data = items.map((e) => e.label).whereType<String>();
    if (data.isEmpty) return [];
    return data.toList();
  }

  static InAppHobby? of(Object? source) {
    return cache.where((e) {
      if (e.id == source) return true;
      if (e.label == source) return true;
      return false;
    }).firstOrNull;
  }

  @override
  String toString() {
    return '$InAppHobby(id: $id, label: $label, category: $category)';
  }
}
