import 'package:hive_flutter/adapters.dart';

part 'model.g.dart';

@HiveType(typeId: 69)
class HivePreferencesModel {
  @HiveField(0)
  bool? anyBool;

  @HiveField(1)
  int? anyInt;

  @HiveField(2)
  double? anyDouble;

  @HiveField(3)
  String? anyString;
}
