import 'package:flutter_entity/entity.dart';

class IngredientKeys extends EntityKey {
  const IngredientKeys._();

  static IngredientKeys? _i;

  static IngredientKeys get i => _i ??= IngredientKeys._();

  final name = 'name';
  final quantity = 'quantity';
  final unit = 'unit';
}
