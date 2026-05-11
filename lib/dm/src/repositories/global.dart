import 'dart:async' show StreamSubscription;

import '../operations/cache_delegate.dart' show CacheDelegate;
import '../operations/connectivity_delegate.dart' show ConnectivityDelegate;

typedef DataRepoDrainCallback = Future<void> Function();

class DataRepoGlobal {
  DataRepoGlobal._();

  static final DataRepoGlobal i = DataRepoGlobal._();

  ConnectivityDelegate? _connectivity;
  CacheDelegate? _cache;
  StreamSubscription<bool>? _sub;
  bool _draining = false;
  final Map<String, DataRepoDrainCallback> _drains = {};

  ConnectivityDelegate? get connectivity => _connectivity;

  CacheDelegate? get cache => _cache;

  bool get hasCache => _cache != null;

  void configure({ConnectivityDelegate? connectivity, CacheDelegate? cache}) {
    _connectivity = connectivity;
    _cache = cache;
    _sub?.cancel();
    _sub = null;
    if (connectivity != null) {
      _sub = connectivity.onChanged.listen((connected) {
        if (connected) drainAll();
      });
    }
  }

  Future<bool> get isConnected async {
    final c = _connectivity;
    if (c == null) return false;
    return c.isConnected;
  }

  void register(String key, DataRepoDrainCallback drain) {
    _drains[key] = drain;
  }

  void unregister(String key) {
    _drains.remove(key);
  }

  Future<void> drainAll() async {
    if (_draining) return;
    _draining = true;
    try {
      final list = List<DataRepoDrainCallback>.of(_drains.values);
      for (final d in list) {
        try {
          await d();
        } catch (_) {}
      }
    } finally {
      _draining = false;
    }
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    _sub = null;
    _drains.clear();
    _connectivity = null;
    _cache = null;
  }
}
