import 'dart:convert';

import 'package:in_app_configs/configs.dart';

const kReligions = "religions";

class InAppReligion {
  final String? id;
  final String? label;
  final String? photo;
  final int? priority;

  const InAppReligion({this.id, this.label, this.photo, this.priority});

  factory InAppReligion.parse(Object? source, {String? id}) {
    if (source is String) source = jsonDecode(source);
    if (source is MapEntry) {
      id ??= source.key;
      source = source.value;
    }
    if (source is! Map) return InAppReligion();
    id ??= source['key'] ?? source["id"];
    final label = source['name'] ?? source["label"];
    final photo = source['photo'];
    final priority = source['priority'];
    return InAppReligion(
      id: id is String && id.isNotEmpty ? id : null,
      label: label is String && label.isNotEmpty ? label : null,
      photo: photo is String && photo.isNotEmpty ? photo : null,
      priority: priority is num ? priority.toInt() : null,
    );
  }

  static List<InAppReligion>? _cache;

  static List<InAppReligion> get cache {
    if (_cache != null) return _cache!;
    _cache = items;
    return _cache!;
  }

  static List<InAppReligion> get items {
    final data = Configs.getByName(kReligions);
    if (data is List && data.isNotEmpty) {
      return data.map(InAppReligion.parse).toList();
    }
    if (data is Map && data.isNotEmpty) {
      return data.entries.map(InAppReligion.parse).toList();
    }
    return [];
  }

  static List<String> get labels {
    final data = items.map((e) => e.label).whereType<String>();
    if (data.isEmpty) return [];
    return data.toList();
  }

  static InAppReligion? of(Object? source) {
    return cache.where((e) {
      if (e.id == source) return true;
      if (e.label == source) return true;
      return false;
    }).firstOrNull;
  }

  @override
  String toString() {
    return '$InAppReligion(id: $id, label: $label, photo: $photo, priority: $priority)';
  }
}
