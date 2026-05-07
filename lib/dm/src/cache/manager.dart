import 'dart:collection' show LinkedHashMap, UnmodifiableListView;

import 'package:flutter_entity/entity.dart' show Response, Status;
import 'package:meta/meta.dart' show visibleForTesting;

import 'config.dart' show CacheConfig;
import 'entry.dart' show CacheEntry;
import 'stats.dart' show CacheStats;

class CacheManager {
  static CacheManager? _instance;

  static CacheManager get i => _instance ??= CacheManager();

  @visibleForTesting
  static void overrideInstance(CacheManager? instance) {
    _instance = instance;
  }

  final CacheConfig config;
  final CacheStats _stats = CacheStats();

  final LinkedHashMap<String, CacheEntry> _db = LinkedHashMap();

  final Map<String, _TypedFlight<dynamic>> _inFlight = {};

  DateTime? _lastEviction;

  CacheManager({this.config = const CacheConfig()});

  CacheStats get stats => _stats.clone();

  Iterable<String> get keys => UnmodifiableListView(_db.keys.toList());

  int get length => _db.length;

  bool get isEmpty => _db.isEmpty;

  bool get isNotEmpty => _db.isNotEmpty;

  String buildKey(
    Type type,
    String name, [
    Iterable<Object?> props = const [],
  ]) {
    final parts = <String>[name, type.toString()];
    for (final p in props) {
      if (p != null) parts.add(Uri.encodeComponent(p.toString()));
    }
    return parts.join('\x00');
  }

  Future<Response<T>> cache<T extends Object>(
    String name, {
    bool enabled = true,
    Iterable<Object?> keyProps = const [],
    Duration? ttl,
    required Future<Response<T>> Function() callback,
  }) async {
    if (!enabled) {
      try {
        return await callback();
      } catch (e, st) {
        return Response(error: "$e\n$st", status: Status.failure);
      }
    }

    final key = buildKey(T, name, keyProps);

    final cached = _readValid<T>(key);
    if (cached != null) {
      _stats.hits++;
      return cached;
    }
    _stats.misses++;

    if (config.deduplicateInFlight) {
      final flight = _inFlight[key];
      if (flight != null && flight is _TypedFlight<T>) {
        _stats.inFlightDedupes++;
        return await flight.future;
      }
    }

    final typedFlight = _TypedFlight<T>(callback());
    if (config.deduplicateInFlight) {
      _inFlight[key] = typedFlight;
    }

    try {
      final result = await typedFlight.future;
      if (result.isValid) _write(key, result, ttl);
      return result;
    } catch (e, st) {
      return Response(error: "$e\n$st", status: Status.failure);
    } finally {
      if (identical(_inFlight[key], typedFlight)) {
        _inFlight.remove(key);
      }
    }
  }

  Response<T>? pick<T extends Object>(
    String name, {
    Iterable<Object?> keyProps = const [],
  }) {
    return _readValid<T>(buildKey(T, name, keyProps));
  }

  Response<T>? pickByKey<T extends Object>(String key) => _readValid<T>(key);

  void put<T extends Object>(
    String name,
    Response<T> response, {
    Iterable<Object?> keyProps = const [],
    Duration? ttl,
  }) {
    if (!response.isValid) return;
    _write(buildKey(T, name, keyProps), response, ttl);
  }

  void remove<T extends Object>(
    String name, {
    Iterable<Object?> keyProps = const [],
  }) {
    _db.remove(buildKey(T, name, keyProps));
  }

  void removeByKey(String key) => _db.remove(key);

  void clear() {
    _db.clear();
    _inFlight.clear();
    _stats.reset();
    _lastEviction = null;
  }

  int evictExpired() {
    final expiredKeys = <String>[];
    for (final entry in _db.entries) {
      if (entry.value.isExpired) expiredKeys.add(entry.key);
    }
    for (final k in expiredKeys) {
      _db.remove(k);
      _stats.expirations++;
    }
    return expiredKeys.length;
  }

  Response<T>? _readValid<T extends Object>(String key) {
    final entry = _db[key];
    if (entry == null) return null;

    if (entry.isExpired) {
      _db.remove(key);
      _stats.expirations++;
      return null;
    }

    final response = entry.response;
    if (response is Response<T> && response.isValid) {
      _db.remove(key);
      _db[key] = entry;
      return response;
    }
    return null;
  }

  void _write(String key, Response response, Duration? ttl) {
    final now = DateTime.now();
    if (_lastEviction == null ||
        now.difference(_lastEviction!) >= config.evictionInterval) {
      evictExpired();
      _lastEviction = now;
    }
    final effectiveTtl = ttl ?? config.defaultTtl;
    final expiresAt = effectiveTtl == null ? null : now.add(effectiveTtl);
    _db.remove(key);
    _db[key] = CacheEntry(response, expiresAt);
    _stats.writes++;
    while (_db.length > config.maxSize) {
      _db.remove(_db.keys.first);
      _stats.evictions++;
    }
  }
}

class _TypedFlight<T extends Object> {
  final Future<Response<T>> future;

  _TypedFlight(this.future);
}