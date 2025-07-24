import 'package:hive_flutter/hive_flutter.dart';

import 'config.dart';
import 'model.dart';
import 'paths.dart';

typedef HiveBuilder<E> = TypeAdapter<E> Function();

class HiveInitializer {
  const HiveInitializer._();

  static Future<void> init([HiveConfigure? configure]) async {
    await Hive.initFlutter();
    await _register();
    await _build();
    if (configure != null) await configure();
  }

  static Future<void> _register() async {
    Hive.registerAdapter(HivePreferencesModelAdapter());
  }

  static Future<void> _build() async {
    await Hive.openBox<HivePreferencesModel>(HivePaths.preferences);
    await Hive.openBox<List<String>?>(HivePaths.strings);
    await Hive.openBox<List<int>?>(HivePaths.ints);
  }
}
