import 'package:in_app_database/in_app_database.dart';

import '../../roots/hive/database.dart';
import '../configs/local.dart';

class LocalDatabaseDelegate extends InAppDatabaseDelegate {
  @override
  Future<bool> init(String name) {
    return HiveDatabase.init(name);
  }

  @override
  Future<Iterable<String>> paths(String name) async {
    return HiveDatabase.keys(name);
  }

  @override
  Future<bool> drop(String name) {
    return HiveDatabase.close(name);
  }

  @override
  Future<bool> delete(String name, String key) {
    return HiveDatabase.delete(name, key);
  }

  @override
  Future<Object?> read(String name, String key) async {
    return HiveDatabase.read(
      name,
      key,
      LocalConfigs.inAppDatabaseType == InAppDatabaseType.map,
    );
  }

  @override
  Future<bool> write(String name, String key, Object? value) {
    return HiveDatabase.write(name, key, value);
  }

  @override
  Future<InAppWriteLimitation?> limitation(
    String name,
    PathDetails details,
  ) async {
    return {}[details.format];
  }
}
