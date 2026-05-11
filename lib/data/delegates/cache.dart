import '../../app/imports/data_management.dart' show DataCacheDelegate;

class CacheDelegate extends DataCacheDelegate {
  @override
  Future<void> clear(String key) async {}

  @override
  Future<bool> exists(String key, String entryId) async {
    return false;
  }

  @override
  Future<void> push(
    String key,
    String entryId,
    Map<String, dynamic> entry,
  ) async {}

  @override
  Future<List<MapEntry<String, Map<String, dynamic>>>> readAll(
    String key,
  ) async {
    return [];
  }

  @override
  Future<void> remove(String key, String entryId) async {}
}
