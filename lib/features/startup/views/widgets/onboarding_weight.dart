import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/spacing.dart';
import 'package:flutter_andomie/utils/measurement.dart';
import 'package:flutter_andomie/utils/settings.dart';
import 'package:flutter_andomie/utils/translation.dart';

import '../../../../app/styles/fonts.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/text.dart';
import 'ruler_picker.dart';
import 'tabs.dart';

const kWeightUnitIndex = "weight_unit_index";

class OnboardingWeight extends StatefulWidget {
  final double value;
  final List<String> units;
  final ValueChanged<double>? onChanged;

  const OnboardingWeight({
    super.key,
    required this.value,
    required this.units,
    this.onChanged,
  });

  @override
  State<OnboardingWeight> createState() => _OnboardingWeightState();
}

class _OnboardingWeightState extends State<OnboardingWeight>
    with SingleTickerProviderStateMixin {
  late final controller = TabController(
    length: widget.units.length,
    vsync: this,
    initialIndex: Settings.get(kWeightUnitIndex, 0),
  );

  late final value = ValueNotifier(
    controller.index == 1 ? widget.value.toLb : widget.value,
  );

  void _changedUnit(int index) => Settings.set(kWeightUnitIndex, index);

  void _changed(double value) {
    this.value.value = value;
    widget.onChanged!(controller.index == 1 ? value.toKg : value);
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
      aspectRatio: 1,
      child: InAppLayout(
        mainAxisSize: MainAxisSize.min,
        children: [
          OnboardingTabs(
            controller: controller,
            tabs: widget.units,
            onChanged: _changedUnit,
          ),
          Spacer(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListenableBuilder(
                listenable: controller,
                builder: (context, child) {
                  return ValueListenableBuilder(
                    valueListenable: value,
                    builder: (context, value, child) {
                      return InAppText(
                        value.toInt().trNumber,
                        maxLines: 1,
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
            ),
          ),
          Spacer(),
          Directionality(
            textDirection: Translation.textDirection,
            child: RulerPicker(
              value: controller.index == 1 ? widget.value.toLb : widget.value,
              textBuilder: (index, value) {
                return Container(
                  alignment: Alignment.center,
                  child: InAppText(
                    value.toInt().trNumber,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
              ranges: [RulerRange(begin: 20, end: 500, scale: 1)],
              scaleLineStyleList: const [
                ScaleLineStyle(
                  color: Color(0xffD7D8D9),
                  width: 2,
                  height: 24,
                  scale: 5,
                ),
                ScaleLineStyle(
                  color: Color(0xffBABBBE),
                  width: 4,
                  height: 56,
                  scale: 0,
                ),
              ],
              onChanged: _changed,
              width: context.w,
              height: 120,
              marker: InAppIcon(
                'assets/icons/marker.svg',
                size: 140,
                color: color.base.secondary,
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
