import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/list.dart';
import 'package:flutter_andomie/extensions/num.dart';
import 'package:flutter_andomie/extensions/object.dart';
import 'package:flutter_andomie/extensions/spacing.dart';
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
import '../../data/entities/recipe.dart';
import '../widgets/leading.dart';

class RecipeDetailsPage extends StatefulWidget {
  final Object? args;

  const RecipeDetailsPage({super.key, this.args});

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage>
    with ColorMixin, TranslationMixin {
  late final data = widget.args.find(defaultValue: Recipe());
  final quantity = ValueNotifier(1);
  final completedSteps = ValueNotifier(<bool>[]);

  void _increment() {
    quantity.value++;
  }

  void _decrement() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void _toggleStepCompletion(int index) {
    completedSteps.value[index] = !completedSteps.value[index];
    completedSteps.value = [...completedSteps.value];
  }

  void _finish() => context.close();

  @override
  void initState() {
    super.initState();
    completedSteps.value = List.generate(data.directions.use.length, (_) {
      return false;
    });
  }

  @override
  void dispose() {
    quantity.dispose();
    completedSteps.dispose();
    super.dispose();
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
            layout: LayoutType.stack,
            alignment: Alignment.topCenter,
            children: [
              _buildImage(),
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  AspectRatio(aspectRatio: 1.1),
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
                      color: dark.t05,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      child: InAppLayout(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle(),
                          const SizedBox(height: 24),
                          _buildIngredients(),
                          const SizedBox(height: 25),
                          _buildDirections(),
                          const SizedBox(height: 25),
                          _buildFinishButton(),
                          const SizedBox(height: 24),
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
        child: InAppImage(data.image, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildTitle() {
    return InAppLayout(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InAppText(
          data.name,
          style: TextStyle(
            fontSize: 20,
            color: dark,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        InAppLayout(
          layout: LayoutType.row,
          children: [
            InAppIcon(
              "assets/icons/ic_nutrition_recipe_duration.svg",
              size: 16,
              color: dark.t60,
            ),
            const SizedBox(width: 5),
            InAppText(
              localize("duration", defaultValue: "{DURATION} min").replaceAll(
                "{DURATION}",
                data.duration.use.trNumWithOption(applyRtl: true),
              ),
              style: TextStyle(fontSize: 14, color: dark.t60),
            ),
            const SizedBox(width: 16),
            InAppIcon(
              "assets/icons/ic_nutrition_meal.svg",
              size: 16,
              color: dark.t60,
            ),
            const SizedBox(width: 5),
            InAppText(
              localizes(
                "meal_types",
                defaultValue: ["Breakfast", "Lunch", "Dinner"],
              ).elementAtOrNull(data.mealType?.index ?? 0),
              style: TextStyle(fontSize: 14, color: dark.t60),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategory({required String title, required Widget child}) {
    return InAppLayout(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InAppText(
          title,
          style: TextStyle(
            fontSize: 20,
            color: dark,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildShadow({required Widget child}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: light,
        borderRadius: BorderRadius.circular(12),
        boxShadow: InAppDefaults.shadowSecondary,
      ),
      child: child,
    );
  }

  Widget _buildQuantity() {
    return _buildShadow(
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 16, top: 12, bottom: 12),
        child: InAppLayout(
          layout: LayoutType.row,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: InAppText(
                localize("quantity", defaultValue: 'Quantity'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: dark,
                ),
              ),
            ),
            _buildIncrementButton(false),
            Container(
              width: 40,
              alignment: Alignment.center,
              child: ValueListenableBuilder(
                valueListenable: quantity,
                builder: (context, quantity, child) {
                  return InAppText(
                    quantity.trNumWithOption(applyRtl: true),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),
            _buildIncrementButton(true),
          ],
        ),
      ),
    );
  }

  Widget _buildIncrementButton(bool increment) {
    return InAppGesture(
      onTap: increment ? _increment : _decrement,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: increment ? dark : dark.tx(8),
          shape: BoxShape.circle,
        ),
        child: InAppIcon(
          increment ? Icons.add : Icons.remove,
          size: 16,
          color: increment ? light : dark,
        ),
      ),
    );
  }

  Widget _buildIngredients() {
    return _buildCategory(
      title: localize("ingredients", defaultValue: "Ingredients"),
      child: InAppLayout(
        children: [
          _buildQuantity(),
          const SizedBox(height: 12),
          _buildShadow(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: ValueListenableBuilder(
                valueListenable: quantity,
                builder: (context, quantity, child) {
                  return InAppLayout(
                    children: List.generate(
                      data.ingredients.use.length,
                      _buildIngredient,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredient(int index) {
    final ingredient = data.ingredients.use[index];
    final value = ingredient.quantity! * quantity.value;
    Widget child = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: InAppLayout(
        layout: LayoutType.row,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InAppText(
            ingredient.name ?? '',
            style: TextStyle(fontSize: 16, color: dark.t85),
          ),
          InAppText(
            '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)} ${ingredient.unit}'
                .trWithOption(
                  applyRtl: true,
                  applyTranslator: true,
                  applyNumber: true,
                ),
            style: TextStyle(fontSize: 16, color: dark.t85),
          ),
        ],
      ),
    );
    if (index == data.ingredients.use.length - 1) {
      return child;
    }
    return InAppLayout(
      children: [
        child,
        Divider(color: dark.t10),
      ],
    );
  }

  Widget _buildDirections() {
    return _buildCategory(
      title: localize("direction", defaultValue: "Direction"),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: InAppLayout(
          children: List.generate(data.directions.use.length, _buildDirection),
        ),
      ),
    );
  }

  Widget _buildDirection(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InAppLayout(
        layout: LayoutType.row,
        children: [
          InAppGesture(
            onTap: () => _toggleStepCompletion(index),
            child: ValueListenableBuilder(
              valueListenable: completedSteps,
              builder: (context, completedSteps, child) {
                final completed = completedSteps[index];
                return AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: completed ? secondary : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: completed
                        ? null
                        : Border.all(color: grey.t50, width: 1.5),
                  ),
                  child: completed
                      ? InAppIcon(Icons.check_rounded, color: light, size: 20)
                      : null,
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: _buildShadow(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: InAppText(
                  data.directions.use[index].trWithOption(
                    applyRtl: true,
                    applyTranslator: true,
                    applyNumber: true,
                  ),
                  style: TextStyle(fontSize: 16, color: dark.t85),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishButton() {
    return Center(
      child: ValueListenableBuilder(
        valueListenable: completedSteps,
        builder: (context, value, child) {
          final completed = value.every((e) => e);
          return InAppGesture(
            onTap: completed ? _finish : null,
            child: Container(
              width: context.w * 0.75,
              height: 54,
              decoration: BoxDecoration(
                color: completed ? primary : primary.t05,
                borderRadius: BorderRadius.circular(50),
              ),
              alignment: Alignment.center,
              child: InAppText(
                localize("button", defaultValue: 'Finish'),
                style: TextStyle(
                  fontSize: 18,
                  color: completed ? lightAsFixed : primary.t50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  String get name => "nutrition:recipe_details";
}
