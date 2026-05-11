import 'dart:convert' show jsonDecode, jsonEncode;

import '../../app/imports/data_management.dart' show DataCacheDelegate;
import '../../roots/preferences/preferences.dart' show Preferences;

class CacheDelegate extends DataCacheDelegate {
  static const _separator = '::';
  static const _indexSuffix = '__index__';

  String _entryKey(String key, String entryId) => '$key$_separator$entryId';

  String _indexKey(String key) => '$key$_separator$_indexSuffix';

  Future<List<String>> _readIndex(String key) async {
    final raw = Preferences.getStringOrNull(_indexKey(key));
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.whereType<String>().toList();
      }
    } catch (_) {}
    return [];
  }

  Future<void> _writeIndex(String key, List<String> ids) async {
    if (ids.isEmpty) {
      await Preferences.setStringAsync(_indexKey(key), '');
      return;
    }
    await Preferences.setStringAsync(_indexKey(key), jsonEncode(ids));
  }

  @override
  Future<void> clear(String key) async {
    final ids = await _readIndex(key);
    for (final id in ids) {
      await Preferences.setStringAsync(_entryKey(key, id), '');
    }
    await Preferences.setStringAsync(_indexKey(key), '');
  }

  @override
  Future<bool> exists(String key, String entryId) async {
    final raw = await Preferences.getStringOrNull(_entryKey(key, entryId));
    return raw != null && raw.isNotEmpty;
  }

  @override
  Future<void> push(
    String key,
    String entryId,
    Map<String, dynamic> entry,
  ) async {
    await Preferences.setString(_entryKey(key, entryId), jsonEncode(entry));
    final ids = await _readIndex(key);
    if (!ids.contains(entryId)) {
      ids.add(entryId);
      await _writeIndex(key, ids);
    }
  }

  @override
  Future<List<MapEntry<String, Map<String, dynamic>>>> readAll(
    String key,
  ) async {
    final ids = await _readIndex(key);
    if (ids.isEmpty) return [];
    final out = <MapEntry<String, Map<String, dynamic>>>[];
    final stale = <String>[];
    for (final id in ids) {
      final raw = Preferences.getStringOrNull(_entryKey(key, id));
      if (raw == null || raw.isEmpty) {
        stale.add(id);
        continue;
      }
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          out.add(MapEntry(id, decoded.cast<String, dynamic>()));
        } else {
          stale.add(id);
        }
      } catch (_) {
        stale.add(id);
      }
    }
    if (stale.isNotEmpty) {
      final cleaned = ids.where((e) => !stale.contains(e)).toList();
      await _writeIndex(key, cleaned);
    }
    return out;
  }

  @override
  Future<void> remove(String key, String entryId) async {
    await Preferences.setStringAsync(_entryKey(key, entryId), '');
    final ids = await _readIndex(key);
    if (ids.remove(entryId)) {
      await _writeIndex(key, ids);
    }
  }
}
