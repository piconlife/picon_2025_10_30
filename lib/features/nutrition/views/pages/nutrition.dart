import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/spacing.dart';
import 'package:flutter_andomie/extensions/string.dart';
import 'package:flutter_andomie/utils/configs.dart';
import 'package:flutter_andomie/utils/settings.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../roots/services/notification.dart';
import '../../../../roots/widgets/align.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/fade.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/screen.dart';
import '../../../../roots/widgets/shimmer.dart';
import '../../../../roots/widgets/system_overlay.dart';
import '../../../../roots/widgets/tab.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/paths.dart';
import '../../data/entities/food.dart';
import '../../data/enums/meal_type.dart';

const kNutritionHydrationReminderOn = "nutrition_hydration_reminder_on";
const kNutritionHydrationReminderIndex = "nutrition_hydration_reminder_index";
const kNutritionMealTabIndex = "nutrition_meal_tab_index";

bool get mNutritionHydrationReminderOn {
  return Settings.get(kNutritionHydrationReminderOn, false);
}

int get mNutritionHydrationReminder {
  return Settings.get(kNutritionHydrationReminderIndex, 0) + 1;
}

class NutritionPage extends StatefulWidget {
  final Object? args;

  const NutritionPage({super.key, this.args});

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage>
    with TranslationMixin, ColorMixin, TickerProviderStateMixin {
  final isHydrationReminderOn = ValueNotifier(
    Settings.get(
      kNutritionHydrationReminderOn,
      Configs.get(kNutritionHydrationReminderOn, defaultValue: false),
    ),
  );

  List<Food> items = [];

  bool loading = false;
  Map<int, List<Food>> data = {};

  void _fetch() {
    loading = true;
    setState(() {});
    final x = Translation.gets(path: "nutrients", parser: Food.from);
    final a = x.where((e) => e.type == MealType.breakfast).toList();
    final b = x.where((e) => e.type == MealType.lunch).toList();
    final c = x.where((e) => e.type == MealType.dinner).toList();
    data = {0: a, 1: b, 2: c};
    loading = false;
    items = data[Settings.get<int>(kNutritionMealTabIndex, 0)] ?? [];
    setState(() {});
  }

  void _updateMeal(int index) {
    items = data[index] ?? [];
    setState(() {});
  }

  void _selectFood(Food food) {
    context.open(Routes.nutritionDetails, arguments: food);
  }

  Future<void> _resetNotifications() async {
    if (isHydrationReminderOn.value) {
      await InAppNotifications.initHourlyNotifications(
        perHour: mNutritionHydrationReminder,
      );
    } else {
      await InAppNotifications.cancelHourlyNotifications();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  @override
  void translationChanged() {
    _fetch();
    super.translationChanged();
  }

  @override
  void dispose() {
    isHydrationReminderOn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _fetch();
    return InAppSystemOverlay(
      child: InAppScreen(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: InAppAppbar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            titleText: localize("title", defaultValue: 'Nutrition'),
            titleStyle: TextStyle(
              color: secondary,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          body: InAppFade(
            fadeWidthFraction: 0.025,
            child: ListView(
              padding: EdgeInsets.only(top: 12, bottom: 24),
              children: [
                _buildHydrationReminderCard(),
                const SizedBox(height: 28),
                _buildMealAddInsSection(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHydrationReminderCard() {
    return ValueListenableBuilder(
      valueListenable: isHydrationReminderOn,
      builder: (context, isHydrationReminderOn, child) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.black,
          ),
          height: isHydrationReminderOn ? 135 : 80,
          child: InAppLayout(
            layout: LayoutType.stack,
            children: [
              Positioned(
                top: 36,
                left: 0,
                right: 0,
                child: InAppImage(
                  "assets/images/svg_nutrition_reminder_curve_large.svg",
                  fit: BoxFit.fitWidth,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: InAppLayout(
                  layout: LayoutType.row,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InAppText(
                      localize(
                        "daily_hydration_reminder",
                        defaultValue: 'Daily Hydration reminder',
                      ),
                      style: TextStyle(
                        color: lightAsFixed,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Directionality(
                      textDirection: Translation.textDirection,
                      child: Switch.adaptive(
                        value: isHydrationReminderOn,
                        onChanged: (value) {
                          this.isHydrationReminderOn.value = value;
                          Settings.set(kNutritionHydrationReminderOn, value);
                          _resetNotifications();
                        },
                        activeTrackColor: lightAsFixed,
                        inactiveTrackColor: lightAsFixed,
                        applyCupertinoTheme: true,
                        inactiveThumbColor: primary,
                        trackOutlineWidth: WidgetStatePropertyAll(0),
                        trackOutlineColor: WidgetStatePropertyAll(
                          Colors.transparent,
                        ),
                        activeColor: secondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isHydrationReminderOn)
                InAppAlign(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 40,
                    width: context.w * 0.65,
                    decoration: BoxDecoration(
                      color: Color(0xff00143B),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    margin: EdgeInsets.all(12),
                    child: Padding(
                      padding: EdgeInsets.all(3),
                      child: InAppTabs(
                        name: kNutritionHydrationReminderIndex,
                        primary: secondary,
                        secondary: primary,
                        style: TextStyle(color: dark),
                        unselectedStyle: TextStyle(color: light),
                        borderRadius: BorderRadius.circular(50),
                        onChanged: (value) => _resetNotifications(),
                        tabs: localizes(
                          "daily_hydration_reminder_tabs",
                          defaultValue: ["1 hr", "2 hr", "3 hr"],
                          applyRtl: true,
                          applyNumber: true,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMealAddInsSection() {
    return InAppLayout(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: InAppText(
            localize("header", defaultValue: "Today's Meal Add-ins"),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: InAppText(
            localize(
              "description",
              defaultValue:
                  "Include simple foods in your daily meals to boost Kegel strength.",
            ),
            style: TextStyle(color: dark.t50),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          height: 44,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: dark.t05,
            borderRadius: BorderRadius.circular(25),
          ),
          child: InAppTabs(
            name: kNutritionMealTabIndex,
            onChanged: _updateMeal,
            unselectedStyle: TextStyle(fontWeight: FontWeight.normal),
            tabs: localizes(
              "meal_types",
              defaultValue: ['Breakfast', 'Lunch', 'Dinner'],
            ),
          ),
        ),
        const SizedBox(height: 24),
        if (items.isEmpty && !loading)
          AspectRatio(
            aspectRatio: 1,
            child: Center(
              child: InAppText(
                localize("no_food_found", defaultValue: "No food found!"),
                style: TextStyle(color: dark.t25, fontSize: 18),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length + (loading ? 5 : 0),
            itemBuilder: (context, index) {
              if (loading) return _buildNutrientPlaceholder();
              return _buildNutrientCard(items[index]);
            },
          ),
      ],
    );
  }

  Widget _buildNutrientPlaceholder() {
    return InAppShimmer(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: InAppLayout(
          layout: LayoutType.row,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: InAppLayout(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    width: context.w * 0.35,
                    decoration: BoxDecoration(
                      color: dark.t10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 16,
                    width: context.w * 0.5,
                    decoration: BoxDecoration(
                      color: dark.t05,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 25,
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: dark.t10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: dark.t05,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientCard(Food data) {
    final name = data.name;
    final description = data.description;
    final serving = data.serving;
    final image = data.image;
    return InAppGesture(
      onTap: () => _selectFood(data),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dark.tx(3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: InAppLayout(
          layout: LayoutType.row,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: InAppLayout(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InAppText(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  InAppText(
                    description,
                    style: TextStyle(fontSize: 13, color: dark.t50),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: dark),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InAppText(
                      serving.use.trWithOption(
                        applyRtl: true,
                        applyTranslator: true,
                        applyNumber: true,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: dark),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: InAppImage(image, fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }

  @override
  String get name => "nutrition:main";
}
