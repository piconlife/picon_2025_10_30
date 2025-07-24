import 'package:flutter_entity/entity.dart';

import '../enums/meal_type.dart';
import '../keys/food.dart';
import 'recipe.dart';

class Food extends Entity<FoodKeys> {
  final String? name;
  final String? description;
  final String? longDescription;
  final String? serving;
  final List<String>? nutrients;
  final List<Recipe>? recipes;
  final String? image;
  final MealType type;

  Food({
    super.id,
    super.timeMills,
    this.name,
    this.description,
    this.longDescription,
    this.serving,
    this.nutrients,
    this.recipes,
    this.image,
    this.type = MealType.breakfast,
  });

  factory Food.from(Object? source) {
    final key = FoodKeys.i;
    return Food(
      id: source.entityValue(key.id),
      timeMills: source.entityValue(key.timeMills),
      name: source.entityValue(key.name),
      description: source.entityValue(key.description),
      longDescription: source.entityValue(key.longDescription),
      serving: source.entityValue(key.serving),
      nutrients: source.entityValues(key.nutrients),
      recipes: source.entityValues(key.recipes, Recipe.from),
      image: source.entityValue(key.image),
      type: MealType.parse(source.entityValue(key.type)),
    );
  }

  Food copyWith({
    String? id,
    int? timeMills,
    String? name,
    String? description,
    String? longDescription,
    String? serving,
    List<String>? nutrients,
    List<Recipe>? recipes,
    String? image,
    MealType? type,
  }) {
    return Food(
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      name: name ?? this.name,
      description: description ?? this.description,
      longDescription: longDescription ?? this.longDescription,
      serving: serving ?? this.serving,
      nutrients: nutrients ?? this.nutrients,
      recipes: recipes ?? this.recipes,
      image: image ?? this.image,
      type: type ?? this.type,
    );
  }

  @override
  FoodKeys makeKey() => FoodKeys.i;

  @override
  Map<String, dynamic> get source {
    final entries = {
      key.id: id,
      key.timeMills: timeMills,
      key.name: name,
      key.description: description,
      key.longDescription: longDescription,
      key.serving: serving,
      key.nutrients: nutrients,
      key.image: image,
    }.entries.where((e) => isInsertable(e.key, e.value)).toList();
    if (entries.isEmpty) return {};
    return Map.fromEntries(entries);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        timeMills.hashCode ^
        name.hashCode ^
        description.hashCode ^
        longDescription.hashCode ^
        serving.hashCode ^
        nutrients.hashCode ^
        image.hashCode ^
        type.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return other is Food &&
        other.id == id &&
        other.timeMills == timeMills &&
        other.name == name &&
        other.description == description &&
        other.longDescription == longDescription &&
        other.serving == serving &&
        other.nutrients == nutrients &&
        other.image == image &&
        other.type == type;
  }

  @override
  String toString() {
    return '$Food{id: $id, timeMills: $timeMills, name: $name, description: $description, longDescription: $longDescription, serving: $serving, nutrients: $nutrients, image: $image, type: $type}';
  }
}
