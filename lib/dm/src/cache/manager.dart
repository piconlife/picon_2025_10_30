import 'dart:async' show unawaited;
import 'dart:collection' show LinkedHashMap, UnmodifiableListView;
import 'dart:convert' show json;

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_entity/entity.dart' show Response, Status;
import 'package:meta/meta.dart' show visibleForTesting;

import 'config.dart' show CacheConfig;
import 'entry.dart' show CacheEntry;
import 'stats.dart' show CacheStats;
import 'storage.dart' show CacheStorageAdapter, defaultCacheStorage;

typedef ToJson<T> = dynamic Function(T value);
typedef FromJson<T> = T Function(dynamic json);

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

  final CacheStorageAdapter _storage;

  bool _storageReady = false;

  DateTime? _lastEviction;

  CacheManager({
    this.config = const CacheConfig(),
    CacheStorageAdapter? storage,
  }) : _storage = storage ?? defaultCacheStorage();

  Future<void> init() async {
    if (_storageReady) return;
    await _storage.init();
    _storageReady = true;
  }

  Future<void> _ensureStorage() async {
    if (!_storageReady) await init();
  }

  Future<void> _safeDelete(String key) async {
    await _ensureStorage();
    await _storage.delete(key);
  }

  Future<void> _safeClear() async {
    await _ensureStorage();
    await _storage.clear();
  }

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
    ToJson<T>? toJson,
    FromJson<T>? fromJson,
    required Future<Response<T>> Function() callback,
  }) async {
    if (!enabled) {
      try {
        return await callback();
      } catch (e, st) {
        return Response(error: '$e\n$st', status: Status.failure);
      }
    }

    final key = buildKey(T, name, keyProps);

    final cached = _readValid<T>(key);
    if (cached != null) {
      _stats.hits++;
      return cached;
    }

    if (fromJson != null) {
      final persisted = await _readFromStorage<T>(key, fromJson);
      if (persisted != null) {
        _stats.hits++;
        return persisted;
      }
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
      if (result.isValid) {
        _write(key, result, ttl);
        if (toJson != null) await _writeToStorage(key, result, ttl, toJson);
      }
      return result;
    } catch (e, st) {
      return Response(error: '$e\n$st', status: Status.failure);
    } finally {
      if (identical(_inFlight[key], typedFlight)) {
        _inFlight.remove(key);
      }
    }
  }

  Response<T>? pick<T extends Object>(
    String name, {
    Iterable<Object?> keyProps = const [],
  }) => _readValid<T>(buildKey(T, name, keyProps));

  Response<T>? pickByKey<T extends Object>(String key) => _readValid<T>(key);

  void put<T extends Object>(
    String name,
    Response<T> response, {
    Iterable<Object?> keyProps = const [],
    Duration? ttl,
    ToJson<T>? toJson,
  }) {
    if (!response.isValid) return;
    final key = buildKey(T, name, keyProps);
    _write(key, response, ttl);
    if (toJson != null) {
      unawaited(_writeToStorage(key, response, ttl, toJson));
    }
  }

  void remove<T extends Object>(
    String name, {
    Iterable<Object?> keyProps = const [],
  }) {
    final key = buildKey(T, name, keyProps);
    _db.remove(key);
    unawaited(_safeDelete(key));
  }

  void removeByKey(String key) {
    _db.remove(key);
    unawaited(_safeDelete(key));
  }

  void clear() {
    _db.clear();
    _inFlight.clear();
    _stats.reset();
    _lastEviction = null;
    unawaited(_safeClear());
  }

  int evictExpired() {
    final expiredKeys = <String>[];
    for (final entry in _db.entries) {
      if (entry.value.isExpired) expiredKeys.add(entry.key);
    }
    for (final k in expiredKeys) {
      _db.remove(k);
      unawaited(_safeDelete(k));
      _stats.expirations++;
    }
    return expiredKeys.length;
  }

  Response<T>? _readValid<T extends Object>(String key) {
    final entry = _db[key];
    if (entry == null) return null;

    if (entry.isExpired) {
      _db.remove(key);
      unawaited(_safeDelete(key));
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

  Future<void> _writeToStorage<T extends Object>(
    String key,
    Response<T> response,
    Duration? ttl,
    ToJson<T> toJson,
  ) async {
    await _ensureStorage();
    try {
      final effectiveTtl = ttl ?? config.defaultTtl;
      final expiresAt =
          effectiveTtl == null
              ? null
              : DateTime.now().add(effectiveTtl).toIso8601String();
      final payload = json.encode({
        'data': toJson(response.data as T),
        'expiresAt': expiresAt,
      });
      await _storage.write(key, payload);
    } catch (e) {
      assert(() {
        debugPrint('CacheManager _writeToStorage error: $e');
        return true;
      }());
    }
  }

  Future<Response<T>?> _readFromStorage<T extends Object>(
    String key,
    FromJson<T> fromJson,
  ) async {
    await _ensureStorage();
    try {
      final raw = await _storage.read(key);
      if (raw == null) return null;

      final map = json.decode(raw) as Map<String, dynamic>;
      final expiresAtRaw = map['expiresAt'] as String?;

      if (expiresAtRaw != null) {
        final expiresAt = DateTime.parse(expiresAtRaw);
        if (DateTime.now().isAfter(expiresAt)) {
          await _storage.delete(key);
          _stats.expirations++;
          return null;
        }
      }

      final data = fromJson(map['data']);
      final response = Response<T>(data: data, status: Status.ok);
      final expiresAt =
          expiresAtRaw != null ? DateTime.parse(expiresAtRaw) : null;

      _db[key] = CacheEntry(response, expiresAt);
      while (_db.length > config.maxSize) {
        _db.remove(_db.keys.first);
        _stats.evictions++;
      }

      return response;
    } catch (e) {
      assert(() {
        debugPrint('CacheManager _readFromStorage error: $e');
        return true;
      }());
      return null;
    }
  }
}

class _TypedFlight<T extends Object> {
  final Future<Response<T>> future;
  _TypedFlight(this.future);
}