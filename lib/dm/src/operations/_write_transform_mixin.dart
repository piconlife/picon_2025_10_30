part of 'operation.dart';

mixin _WriteTransformMixin {
  static const _refPrefix = '@';
  static const _countPrefix = '#';

  static bool _isPrefixedKey(String k) =>
      k.isNotEmpty && (k.startsWith(_refPrefix) || k.startsWith(_countPrefix));

  Map<String, dynamic> transformWrite(
    DataWriteBatch batch,
    Map data,
    bool merge,
  ) {
    final out = <String, dynamic>{};
    for (final entry in data.entries) {
      final k = entry.key;
      if (k is! String || k.isEmpty) continue;
      final v = entry.value;
      final shouldHandle = v is DataFieldValueWriter || _isPrefixedKey(k);
      final processed = shouldHandle ? _handle(batch, v, merge) : v;
      if (processed == null) continue;
      out[k] = processed;
    }
    return out;
  }

  dynamic _handle(DataWriteBatch batch, dynamic value, bool merge) {
    if (value is DataFieldValueWriter) {
      return _handleFieldValueWriter(batch, value, merge);
    }
    if (value is Map) {
      return _handleMap(batch, value, merge);
    }
    if (value is List) {
      if (value.isEmpty) return value;
      final mapped = <dynamic>[];
      for (final e in value) {
        final r = _handle(batch, e, merge);
        if (r != null) mapped.add(r);
      }
      return mapped;
    }
    return value;
  }

  dynamic _handleFieldValueWriter(
    DataWriteBatch batch,
    DataFieldValueWriter value,
    bool merge,
  ) {
    switch (value.type) {
      case DataFieldValueWriterType.set:
        final doc = value.value;
        if (doc == null || doc.isEmpty) return null;
        final options = value.options as DataSetOptions;
        batch.set(value.path, transformWrite(batch, doc, merge), options.merge);
        return value.path;
      case DataFieldValueWriterType.update:
        final doc = value.value;
        if (doc == null || doc.isEmpty) return null;
        batch.update(value.path, transformWrite(batch, doc, merge));
        return value.path;
      case DataFieldValueWriterType.delete:
        batch.delete(value.path);
        return null;
    }
  }

  dynamic _handleMap(DataWriteBatch batch, Map value, bool merge) {
    final path = value['path'];
    if (path is! String || path.isEmpty) {
      return transformWrite(batch, value, merge);
    }
    final create = value['create'];
    if (create is Map && create.isNotEmpty) {
      batch.set(path, transformWrite(batch, create, merge), merge);
      return path;
    }
    final update = value['update'];
    if (update is Map && update.isNotEmpty) {
      batch.update(path, transformWrite(batch, update, merge));
      return path;
    }
    final delete = value['delete'];
    if (delete is bool && delete) {
      batch.delete(path);
      return null;
    }
    return path;
  }
}
