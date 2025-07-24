import 'dart:math';

import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/spacing.dart';
import 'package:flutter_andomie/utils/measurement.dart';
import 'package:flutter_andomie/utils/settings.dart';
import 'package:flutter_andomie/utils/translation.dart';

import '../../../../app/styles/fonts.dart';
import '../../../../roots/utils/platform.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/text.dart';
import 'height_picker.dart';
import 'tabs.dart';

const kHeightUnitIndex = "height_unit_index";

class OnboardingHeight extends StatefulWidget {
  final double value;
  final List<String> units;
  final ValueChanged<double>? onChanged;

  const OnboardingHeight({
    super.key,
    required this.value,
    required this.units,
    this.onChanged,
  });

  @override
  State<OnboardingHeight> createState() => _OnboardingHeightState();
}

class _OnboardingHeightState extends State<OnboardingHeight>
    with SingleTickerProviderStateMixin {
  late final controller = TabController(
    length: widget.units.length,
    vsync: this,
    initialIndex: Settings.get(kHeightUnitIndex, 0),
  );

  late final value = ValueNotifier(
    controller.index == 1 ? widget.value.toFt : widget.value,
  );

  void _changedUnit(int index) => Settings.set(kHeightUnitIndex, index);

  void _changed(double value) {
    this.value.value = value;
    widget.onChanged!(controller.index == 1 ? value.toFt : value);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final dimen = context.dimens;
    return AspectRatio(
      aspectRatio: 1 / 1.2,
      child: InAppLayout(
        children: [
          OnboardingTabs(
            controller: controller,
            tabs: widget.units,
            onChanged: _changedUnit,
          ),
          Expanded(
            child: HeightPicker(
              onChanged: (a) => value.value = a,
              scaleLabel: (index, value) {
                return InAppText(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                );
              },
              ranges: const [RulerRange(begin: 100, end: 250, scale: 0.5)],
              scaleLineStyleList: const [
                ScaleLineStyle(
                  color: Color(0xffD7D8D9),
                  width: 2,
                  height: 24,
                  scale: 5,
                ),
                ScaleLineStyle(
                  color: Color(0xffBABBBE),
                  width: 3,
                  height: 45,
                  scale: 0,
                ),
              ],
              marker: InAppLayout(
                layout: LayoutType.row,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 6,
                    width: context.w / 3,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(50),
                      ),
                    ),
                  ),
                  Spacer(),
                  ListenableBuilder(
                    listenable: controller,
                    builder: (context, child) {
                      return ValueListenableBuilder(
                        valueListenable: value,
                        builder: (context, value, child) {
                          return InAppText(
                            Translation.localize(
                              value.toInt().toString(),
                              applyNumber: true,
                            ),
                            suffix: widget.units[controller.index],
                            style: TextStyle(
                              fontSize: dimen.largest * 2,
                              fontWeight: dimen.blackFontWeight,
                              fontFamily: InAppFonts.secondary,
                            ),
                            suffixStyle: TextStyle(
                              fontWeight: dimen.normalFontWeight,
                              fontSize: dimen.largest,
                              color: color.text.mid,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListMask extends StatelessWidget {
  final Widget child;
  final double firstStop;
  final double secondStop;
  final double thirdStop;
  final double fourthStop;

  const ListMask({
    super.key,
    required this.child,
    this.firstStop = 78,
    this.secondStop = 2,
    this.thirdStop = 40,
    this.fourthStop = 20,
  });

  @override
  Widget build(BuildContext context) {
    final a = MediaQuery.of(context);
    return ShaderMask(
      shaderCallback: (Rect rect) {
        double h = a.size.height;
        double top = a.padding.top;
        double bottom = max(0, a.padding.bottom - (isIos ? 15 : 0));
        double first = top + firstStop;
        double second = first + secondStop;
        double fourth = h - bottom - fourthStop;
        double third = fourth - thirdStop;
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            Colors.white,
            Colors.transparent,
            Colors.transparent,
            Colors.white,
          ],
          stops: [
            first / h,
            second / h,
            third / h,
            fourth / h,
          ], // 10% purple, 80% transparent, 10% purple
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: child,
    );
  }
}

String cmOrFtText(double value) {
  return cmOrFt == 'cm' ? value.toStringAsFixed(0) : inchToReadableFt(value);
}

String inchToReadableFt(double inch) {
  int foot = (inch / 12).floor();
  int inchLeft = (inch - (foot * 12)).toInt();
  return '$foot.$inchLeft';
}

String get cmOrFt => 1 == 0 ? 'cm' : 'ft';
