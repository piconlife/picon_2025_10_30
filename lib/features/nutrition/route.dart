import 'package:flutter/material.dart';

import '../../routes/builder.dart';
import '../../routes/paths.dart';
import 'views/pages/details.dart';
import 'views/pages/nutrition.dart';
import 'views/pages/recipe_details.dart';

Map<String, RouteBuilder> get kNutritionRoutes {
  return {
    Routes.nutrition: _nutrition,
    Routes.nutritionDetails: _details,
    Routes.recipeDetails: _recipeDetails,
  };
}

Widget _nutrition(BuildContext context, Object? args) {
  return NutritionPage(args: args);
}

Widget _details(BuildContext context, Object? args) {
  return NutritionDetailsPage(args: args);
}

Widget _recipeDetails(BuildContext context, Object? args) {
  return RecipeDetailsPage(args: args);
}
