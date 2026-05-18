part of 'controller.dart';

class _LruCache<K, V> {
  _LruCache(this.maxSize);

  final int maxSize;
  final _map = <K, V>{};

  bool containsKey(K key) => _map.containsKey(key);

  V? operator [](K key) {
    if (!_map.containsKey(key)) return null;
    final value = _map.remove(key) as V;
    return _map[key] = value;
  }

  void operator []=(K key, V value) {
    _map.remove(key);
    _map[key] = value;
    if (_map.length > maxSize) _map.remove(_map.keys.first);
  }

  void clear() => _map.clear();
}
