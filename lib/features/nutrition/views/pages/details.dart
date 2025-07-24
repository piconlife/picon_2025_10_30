import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/list.dart';
import 'package:flutter_andomie/extensions/num.dart';
import 'package:flutter_andomie/extensions/object.dart';
import 'package:flutter_andomie/extensions/string.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/res/defaults.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/screen.dart';
import '../../../../roots/widgets/system_overlay.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/paths.dart';
import '../../data/entities/food.dart';
import '../../data/entities/recipe.dart';
import '../widgets/leading.dart';

class NutritionDetailsPage extends StatefulWidget {
  final Object? args;

  const NutritionDetailsPage({super.key, this.args});

  @override
  State<NutritionDetailsPage> createState() => _NutritionDetailsPageState();
}

class _NutritionDetailsPageState extends State<NutritionDetailsPage>
    with ColorMixin, TranslationMixin {
  late final food = widget.args.find(defaultValue: Food());

  void _select(Recipe data) {
    context.open(Routes.recipeDetails, arguments: data);
  }

  @override
  Widget build(BuildContext context) {
    return InAppSystemOverlay(
      child: InAppScreen(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: InAppAppbar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: EdgeInsets.all(8),
              child: NutritionLeading(),
            ),
          ),
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: InAppLayout(
            alignment: Alignment.topCenter,
            layout: LayoutType.stack,
            children: [
              _buildImage(),
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  AspectRatio(aspectRatio: 1.05),
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: light,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [dark.t05, Colors.transparent],
                          stops: [0, 0.2],
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: InAppLayout(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle(),
                          const SizedBox(height: 24),
                          _buildDescription(),
                          const SizedBox(height: 24),
                          _buildRecipes(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Align(
      alignment: Alignment.topCenter,
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: InAppImage(food.image, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return InAppLayout(
      textDirection: textDirection,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InAppText(
          food.name,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        InAppLayout(
          layout: LayoutType.row,
          textDirection: textDirection,
          children: [
            InAppIcon(
              "assets/icons/ic_nutrition_meal.svg",
              size: 18,
              color: dark.t50,
            ),
            const SizedBox(width: 5),
            InAppText(
              food.serving.use.trWithOption(
                applyRtl: true,
                applyNumber: true,
                applyTranslator: true,
              ),
              style: TextStyle(fontSize: 16, color: dark.t75),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return InAppLayout(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InAppText(
          localize("importance", defaultValue: "Why It's Important:"),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        InAppText(
          food.longDescription,
          style: TextStyle(fontSize: 16, color: dark.t50, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildRecipes() {
    return InAppLayout(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InAppText(
          localize("recipes", defaultValue: 'Recipes'),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        ...food.recipes.use.map(_buildCard),
      ],
    );
  }

  Widget _buildCard(Recipe recipe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      height: 125,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: InAppDefaults.shadowPrimary,
      ),
      child: InAppLayout(
        layout: LayoutType.row,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                top: 16,
                bottom: 12,
                right: 8,
              ),
              child: InAppLayout(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InAppText(
                    recipe.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  InAppLayout(
                    layout: LayoutType.row,
                    children: [
                      InAppIcon(
                        "assets/icons/ic_nutrition_recipe_duration.svg",
                        size: 14,
                        color: dark.t50,
                      ),
                      const SizedBox(width: 4),
                      InAppText(
                        localize(
                          "duration",
                          defaultValue: "{DURATION} min",
                        ).replaceAll(
                          "{DURATION}",
                          recipe.duration.use.trNumWithOption(applyRtl: true),
                        ),
                        style: TextStyle(fontSize: 14, color: dark.t75),
                      ),
                      const SizedBox(width: 12),
                      InAppIcon(
                        "assets/icons/ic_nutrition_meal.svg",
                        size: 14,
                        color: dark.t50,
                      ),
                      const SizedBox(width: 4),
                      InAppText(
                        localizes(
                          "meal_types",
                          defaultValue: ["Breakfast", "Lunch", "Dinner"],
                        ).elementAtOrNull(recipe.mealType?.index ?? 0),
                        style: TextStyle(fontSize: 12, color: dark.t75),
                      ),
                    ],
                  ),
                  Spacer(),
                  InAppGesture(
                    onTap: () => _select(recipe),
                    child: Container(
                      decoration: BoxDecoration(
                        color: dark,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      child: InAppLayout(
                        layout: LayoutType.row,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InAppText(
                            localize("cook", defaultValue: "Cook"),
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          SizedBox(width: 4),
                          InAppIcon(
                            Icons.arrow_forward,
                            size: 14,
                            color: lightAsFixed,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: AspectRatio(
                aspectRatio: 1,
                child: InAppImage(recipe.image, fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  String get name => "nutrition:details";
}
