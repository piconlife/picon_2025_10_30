import 'package:flutter_entity/entity.dart';

class FoodKeys extends EntityKey {
  const FoodKeys._() : super(id: "id");

  static FoodKeys? _i;

  static FoodKeys get i => _i ??= FoodKeys._();

  final name = "name";
  final description = "short_description";
  final longDescription = "long_description";
  final serving = "serving";
  final nutrients = "nutrients";
  final recipes = "recipes";
  final image = "image";
  final type = "meal_type";
}
