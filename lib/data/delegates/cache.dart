import '../../packages/data_management.dart' show DataCacheDelegate;
import '../../roots/preferences/preferences.dart' show Preferences;

class CacheDelegate extends DataCacheDelegate {
  @override
  Future<String?> read(String storageKey) async {
    return Preferences.getStringOrNull(storageKey);
  }

  @override
  Future<void> write(String storageKey, String? value) async {
    await Preferences.setStringAsync(storageKey, value);
  }
}
