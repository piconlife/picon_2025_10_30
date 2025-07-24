import 'package:flutter_andomie/extensions/enum.dart';

enum MealType {
  breakfast("Breakfast"),
  lunch("Lunch"),
  dinner("Dinner");

  final String label;

  factory MealType.parse(Object? source) {
    return values.find(source);
  }

  const MealType(this.label);
}
