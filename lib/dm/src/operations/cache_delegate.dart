abstract class CacheDelegate {
  Future<void> push(String key, String entryId, Map<String, dynamic> entry);

  Future<List<MapEntry<String, Map<String, dynamic>>>> readAll(String key);

  Future<bool> exists(String key, String entryId);

  Future<void> remove(String key, String entryId);

  Future<void> clear(String key);
}
