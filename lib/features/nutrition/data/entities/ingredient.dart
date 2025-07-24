import 'package:flutter_entity/entity.dart';

import '../keys/ingredient.dart';

class Ingredient extends Entity<IngredientKeys> {
  final String? name;
  final double? quantity;
  final String? unit;

  Ingredient({super.id, super.timeMills, this.name, this.quantity, this.unit});

  factory Ingredient.from(Object? source) {
    final key = IngredientKeys.i;
    return Ingredient(
      id: source.entityValue(key.id),
      timeMills: source.entityValue(key.timeMills),
      name: source.entityValue(key.name),
      quantity: source.entityValue(key.quantity),
      unit: source.entityValue(key.unit),
    );
  }

  Ingredient copyWith({
    String? id,
    int? timeMills,
    String? name,
    double? quantity,
    String? unit,
  }) {
    return Ingredient(
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }

  @override
  IngredientKeys makeKey() => IngredientKeys.i;

  @override
  Map<String, dynamic> get source {
    final entries = {
      key.id: id,
      key.timeMills: timeMills,
      key.name: name,
      key.quantity: quantity,
      key.unit: unit,
    }.entries.where((e) => isInsertable(e.key, e.value));
    return Map.fromEntries(entries);
  }
}
