import 'package:flutter_entity/entity.dart';

class RecipeKeys extends EntityKey {
  const RecipeKeys._() : super(id: "id");

  static RecipeKeys? _i;

  static RecipeKeys get i => _i ??= RecipeKeys._();
  final name = "name";
  final image = "image";
  final duration = "duration_in_min";
  final mealType = "meal_type";
  final directions = "directions";
  final ingredients = "ingredients";
}
