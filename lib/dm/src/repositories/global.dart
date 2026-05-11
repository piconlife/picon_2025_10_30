import 'dart:async' show StreamSubscription;

import '../operations/cache_delegate.dart' show DataCacheDelegate;
import '../operations/connectivity_delegate.dart' show DataConnectivityDelegate;

typedef DataRepoDrainCallback = Future<void> Function();

class DM {
  DM._();

  static final DM i = DM._();

  DataConnectivityDelegate? _connectivity;
  DataCacheDelegate? _cache;
  StreamSubscription<bool>? _sub;
  bool _draining = false;
  final Map<String, DataRepoDrainCallback> _drains = {};

  DataConnectivityDelegate? get connectivity => _connectivity;

  DataCacheDelegate? get cache => _cache;

  bool get hasCache => _cache != null;

  void configure({DataConnectivityDelegate? connectivity, DataCacheDelegate? cache}) {
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
