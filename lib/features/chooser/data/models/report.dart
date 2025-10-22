import 'package:in_app_configs/configs.dart';

const kReports = "reports";

class InAppReport {
  final String? id;
  final String? label;

  const InAppReport({this.id, this.label});

  factory InAppReport.parse(Object? source, {String? id}) {
    if (source is String) return InAppReport(id: source, label: source);
    if (source is MapEntry) {
      id ??= source.key;
      source = source.value;
    }
    if (source is! Map) return InAppReport();
    id ??= source['id'] ?? source["key"];
    final label = source['name'] ?? source["label"];
    return InAppReport(
      id: id is String && id.isNotEmpty ? id : null,
      label: label is String && label.isNotEmpty ? label : null,
    );
  }

  static List<InAppReport>? _cache;

  static List<InAppReport> get cache {
    if (_cache != null) return _cache!;
    _cache = items;
    return _cache!;
  }

  static List<InAppReport> get items {
    final data = Configs.getByName(kReports);
    if (data is List && data.isNotEmpty) {
      return data.map(InAppReport.parse).toList();
    }
    if (data is Map && data.isNotEmpty) {
      return data.entries.map(InAppReport.parse).toList();
    }
    return [];
  }

  static List<String> get labels {
    final data = items.map((e) => e.label).whereType<String>();
    if (data.isEmpty) return [];
    return data.toList();
  }

  static InAppReport? of(Object? source) {
    return cache.where((e) {
      if (e.id == source) return true;
      if (e.label == source) return true;
      return false;
    }).firstOrNull;
  }

  @override
  String toString() => '$InAppReport(id: $id, label: $label)';
}
