import 'package:flutter_entity/entity.dart';

import '../enums/meal_type.dart';
import '../keys/recipe.dart';
import 'ingredient.dart';

class Recipe extends Entity<RecipeKeys> {
  final String? name;
  final String? image;
  final int? duration;
  final MealType? mealType;
  final List<String>? directions;
  final List<Ingredient>? ingredients;

  Recipe({
    super.id,
    super.timeMills,
    this.name,
    this.image,
    this.duration,
    this.mealType,
    this.directions,
    this.ingredients,
  });

  factory Recipe.from(Object? source) {
    final key = RecipeKeys.i;
    return Recipe(
      id: source.entityValue(key.id),
      timeMills: source.entityValue(key.timeMills),
      name: source.entityValue(key.name),
      image: source.entityValue(key.image),
      duration: source.entityValue(key.duration),
      mealType: MealType.parse(source.entityValue(key.mealType)),
      directions: source.entityValues(key.directions),
      ingredients: source.entityValues(key.ingredients, Ingredient.from),
    );
  }

  Recipe copyWith({
    String? id,
    int? timeMills,
    String? name,
    String? image,
    int? duration,
    MealType? mealType,
    List<String>? directions,
    List<Ingredient>? ingredients,
  }) {
    return Recipe(
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      name: name ?? this.name,
      image: image ?? this.image,
      duration: duration ?? this.duration,
      mealType: mealType ?? this.mealType,
      directions: directions ?? this.directions,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  @override
  RecipeKeys makeKey() => RecipeKeys.i;

  @override
  Map<String, dynamic> get source {
    final entries = {
      key.id: id,
      key.timeMills: timeMills,
      key.name: name,
      key.image: image,
      key.duration: duration,
      key.mealType: mealType,
      key.directions: directions,
      key.ingredients: ingredients,
    }.entries.where((e) => isInsertable(e.key, e.value));
    if (entries.isEmpty) return {};
    return Map.fromEntries(entries);
  }

  @override
  int get hashCode => source.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Recipe) return false;
    return source == other.source;
  }

  @override
  String toString() => "$Recipe($source)";
}
