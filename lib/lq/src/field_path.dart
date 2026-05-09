import 'package:meta/meta.dart';

@immutable
class FieldPath {
  final List<String> segments;

  const FieldPath._(this.segments);

  factory FieldPath(String path) {
    if (path.isEmpty) {
      throw ArgumentError('FieldPath cannot be empty');
    }
    if (!path.contains('.')) {
      return FieldPath._(List.unmodifiable([path]));
    }
    final parts = path.split('.');
    for (final p in parts) {
      if (p.isEmpty) {
        throw ArgumentError('FieldPath segment cannot be empty: "$path"');
      }
    }
    return FieldPath._(List.unmodifiable(parts));
  }

  static Object? resolve(Map<String, dynamic> doc, Object field) {
    if (field is String) {
      if (!field.contains('.')) return doc[field];
      return _resolveDotted(doc, field.split('.'));
    }
    if (field is FieldPath) {
      if (field.segments.length == 1) return doc[field.segments.first];
      return _resolveDotted(doc, field.segments);
    }
    return doc[field];
  }

  static Object? _resolveDotted(Map<String, dynamic> doc, List<String> parts) {
    Object? current = doc;
    for (final part in parts) {
      if (current is Map) {
        current = current[part];
      } else {
        return null;
      }
      if (current == null) return null;
    }
    return current;
  }

  String get path => segments.join('.');

  @override
  int get hashCode => Object.hashAll(segments);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FieldPath) return false;
    if (other.segments.length != segments.length) return false;
    for (int i = 0; i < segments.length; i++) {
      if (segments[i] != other.segments[i]) return false;
    }
    return true;
  }

  @override
  String toString() => path;
}
