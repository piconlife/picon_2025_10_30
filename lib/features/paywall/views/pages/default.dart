import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';

import '../../../../app/constants/app.dart';
import '../../../../roots/utils/utils.dart';
import '../../../../roots/widgets/align.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/padding.dart';
import '../../../../roots/widgets/position.dart';
import '../../../../roots/widgets/purchase_button.dart';
import '../../../../roots/widgets/text.dart';

const _features = [
  {
    "icon": "assets/icons/ic_paywall_ep_list.svg",
    "text": "Diets based on the conditions",
  },
  {
    "icon": "assets/icons/ic_paywall_grommet_yoga.svg",
    "text": "100+ Guided Workouts",
  },
  {
    "icon": "assets/icons/ic_magic_voice_regular.svg",
    "text": "Special Ai Assistant",
  },
  {
    "icon": "assets/icons/ic_paywall_graph.svg",
    "text": "Track your progress & streaks",
  },
];

const _offers = [
  {
    "plan": "Limited offer",
    "left":
        "Total {CURRENCY_SIGN}{DISCOUNT_PRICE} / year (<l>{CURRENCY_SIGN}{PRICE}</l>)",
    "right": "{CURRENCY_SIGN}{MONTHLY_PRICE}",
    "discountText": "{DISCOUNT}% OFF",
    "discount": 80,
    "price": 124.95,
    "currencySign": "\$",
  },
  {"left": "1 month", "right": "\$9.99/mo."},
];

class DefaultPaywall extends StatefulWidget {
  final Object? args;
  final VoidCallback? onSkipped;

  const DefaultPaywall({super.key, this.args, this.onSkipped});

  @override
  State<DefaultPaywall> createState() => _DefaultPaywallState();
}

class _DefaultPaywallState extends State<DefaultPaywall> with ColorMixin {
  final selectedIndex = ValueNotifier(0);

  final lightColor = Color(0xffFBF9F8);

  @override
  void dispose() {
    selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: lightColor,
      child: SafeArea(
        child: InAppLayout(
          layout: LayoutType.stack,
          fit: StackFit.expand,
          children: [
            _buildHeader(),
            _buildFeatures(),
            _buildFooter(),
            _buildCloseButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    if (widget.onSkipped == null) return SizedBox();
    return InAppAlign(
      alignment: Alignment(-0.9, -0.91),
      child: InAppGesture(
        onTap: widget.onSkipped,
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(8),
          child: InAppIcon(
            "assets/icons/ic_paywall_cross.svg",
            color: Colors.black.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return InAppAlign(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: double.infinity,
        height: 280,
        child: InAppLayout(
          layout: LayoutType.stack,
          alignment: Alignment.center,
          children: [
            InAppPositioned(
              top: -30,
              bottom: 0,
              right: 0,
              child: InAppImage(
                'assets/images/img_paywall_default.png',
                fit: BoxFit.fitHeight,
              ),
            ),
            InAppAlign(
              alignment: Alignment.centerLeft,
              child: InAppPadding(
                padding: EdgeInsets.only(left: 24, bottom: 12),
                child: InAppText(
                  'Unlock\n',
                  style: TextStyle(fontSize: 32, color: context.primary),
                  spans: [
                    TextSpan(
                      text: 'Kegel ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'X',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: context.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatures() {
    return InAppAlign(
      alignment: Alignment(0, -0.1),
      child: InAppPadding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: InAppLayout(
          layout: LayoutType.column,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_features.length, (index) {
            final data = _features[index];
            return InAppPadding(
              padding: EdgeInsets.only(bottom: 24),
              child: InAppLayout(
                layout: LayoutType.row,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InAppIcon(data['icon'], size: 26, color: Colors.black),
                  SizedBox(width: 16),
                  Expanded(
                    child: InAppText(
                      data["text"],
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [light.withValues(alpha: 0), lightColor],
          stops: [0.55, 0.6],
        ),
      ),
      child: InAppLayout(
        layout: LayoutType.column,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildPackages(),
          const SizedBox(height: 30),
          _buildPurchaseButton(),
          const SizedBox(height: 16),
          _buildTextButtons(),
        ],
      ),
    );
  }

  Widget _buildPackages() {
    return ValueListenableBuilder(
      valueListenable: selectedIndex,
      builder: (context, _, child) {
        return ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 18),
          shrinkWrap: true,
          itemCount: _offers.length,
          itemBuilder: (context, index) {
            return _buildPackage(index);
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 14);
          },
        );
      },
    );
  }

  void _choosePackage(int index) {
    selectedIndex.value = index;
  }

  Widget _buildPackage(int index) {
    final package = _offers[index];
    return InAppGesture(
      scalerLowerBound: 1,
      onTap: () => _choosePackage(index),
      child: index == 0 ? _buildPackage1(package) : _buildPackage2(package),
    );
  }

  Widget _buildPackage1(Map? package) {
    final selected = selectedIndex.value == 0;
    final title = package.findByKey("plan", defaultValue: "Limited offer");
    final left = package.findByKey(
      "left",
      defaultValue:
          "Total {CURRENCY_SIGN}{DISCOUNT_PRICE} / year (<l>{CURRENCY_SIGN}{PRICE}</l>)",
    );
    final right = package.findByKey(
      "right",
      defaultValue: "{CURRENCY_SIGN}{MONTHLY_PRICE}",
    );
    final discount = package.findByKey("discount", defaultValue: 0);
    final discountText = package.findByKey(
      "discountText",
      defaultValue: "{DISCOUNT}% OFF",
    );

    final price = package.findByKey("price", defaultValue: 0);
    final currencySign = package.findByKey("currencySign", defaultValue: "\$");
    final discountPrice = price - (price * discount / 100);
    final monthlyPrice = discountPrice / 12;
    final formattedLeft = TextParser.parse(
      left
          .replaceAll("{CURRENCY_SIGN}", currencySign)
          .replaceAll("{DISCOUNT_PRICE}", discountPrice.toStringAsFixed(2))
          .replaceAll("{PRICE}", price.toStringAsFixed(2)),
    );

    final formattedRight = right
        .replaceAll("{MONTHLY_PRICE}", monthlyPrice.toStringAsFixed(2))
        .replaceAll("{CURRENCY_SIGN}", currencySign);

    final formattedDiscount = discountText.replaceAll(
      "{DISCOUNT}",
      discount.toString(),
    );

    return InAppLayout(
      layout: LayoutType.stack,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: double.infinity,
          height: 100 - 3.5,
          decoration: BoxDecoration(
            color: light,
            border: Border.all(
              color: selected ? secondary : mid,
              width: selected ? 3.5 : 1,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: InAppLayout(
            layout: LayoutType.column,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InAppText(
                title,
                style: TextStyle(
                  color: dark,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              InAppLayout(
                layout: LayoutType.row,
                children: [
                  Expanded(
                    child: formattedLeft.length > 1
                        ? InAppText(
                            formattedLeft[0].text,
                            style: TextStyle(
                              color: dark,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                            spans: List.generate(formattedLeft.length - 1, (
                              index,
                            ) {
                              final text = formattedLeft[index + 1];
                              final isLineThrough =
                                  text is SpannedText &&
                                  text.types.any((e) => e == "l");
                              final isItalic =
                                  text is SpannedText &&
                                  text.types.any((e) => e == "i");
                              final isBold =
                                  text is SpannedText &&
                                  text.types.any((e) => e == "b");
                              return TextSpan(
                                text: text.text,
                                style: TextStyle(
                                  decoration: isLineThrough
                                      ? TextDecoration.lineThrough
                                      : null,
                                  fontWeight: isBold
                                      ? FontWeight.bold
                                      : isLineThrough
                                      ? FontWeight.w400
                                      : null,
                                  fontStyle: isItalic ? FontStyle.italic : null,
                                ),
                              );
                            }),
                          )
                        : SizedBox(),
                  ),
                  InAppText(
                    formattedRight,
                    style: TextStyle(
                      color: dark,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (discount > 0 && discountText.isNotEmpty)
          InAppPositioned(
            top: 0,
            right: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: selected ? secondary : mid,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: InAppText(
                formattedDiscount,
                style: TextStyle(
                  color: light,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPackage2(Map? package) {
    final isSelected = selectedIndex.value == 1;
    final price = package.findByKey("price", defaultValue: 0);
    final currencySign = package.findByKey("currencySign", defaultValue: "\$");
    final divider = package.findByKey("divider", defaultValue: 12);
    final duration = package.findByKey("duration", defaultValue: 1);
    final durationUnit = package.findByKey(
      "durationUnit",
      defaultValue: "month",
    );
    final left = package.findByKey(
      "left",
      defaultValue: "{DURATION} {DURATION_UNIT}",
    );
    final right = package.findByKey(
      "right",
      defaultValue: "{CURRENCY_SIGN}{MONTHLY_PRICE}/mo.",
    );
    final monthlyPrice = price / divider;
    final monthlyPrices = monthlyPrice * duration;

    final formatedLeft = left
        .replaceAll("{DURATION}", duration.toString())
        .replaceAll("{DURATION_UNIT}", durationUnit);

    final formatedRight = right
        .replaceAll("{CURRENCY_SIGN}", currencySign)
        .replaceAll("{MONTHLY_PRICE}", monthlyPrices.toString());

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: double.infinity,
      height: 70 - 3.5,
      decoration: BoxDecoration(
        color: light,
        border: Border.all(
          color: isSelected ? secondary : mid,
          width: isSelected ? 3.5 : 1,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: InAppLayout(
        layout: LayoutType.row,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InAppText(
            formatedLeft,
            style: TextStyle(
              color: dark.withValues(alpha: 0.60),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          InAppText(
            formatedRight,
            style: TextStyle(color: dark.withValues(alpha: 0.65), fontSize: 18),
          ),
        ],
      ),
    );
  }

  void _purchase() {}

  Widget _buildPurchaseButton() {
    return InAppPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: InAppPurchaseButton(
        text: "Claim your limited offer now",
        onTap: _purchase,
      ),
    );
  }

  void _terms() => Utils.launchLink(link: AppConstants.termsLink);

  void _restore() {}

  Widget _buildTextButtons() {
    return InAppPadding(
      padding: EdgeInsets.only(bottom: 16, left: 32, right: 32),
      child: InAppLayout(
        layout: LayoutType.row,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: {
          "Terms of Use and Privacy Policy": _terms,
          "Restore purchase": _restore,
        }.entries.map(_buildTextButton).toList(),
      ),
    );
  }

  Widget _buildTextButton(MapEntry<String, VoidCallback> data) {
    return Expanded(
      child: InAppGesture(
        onTap: data.value,
        child: InAppPadding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: InAppText(
            data.key,
            textAlign: TextAlign.center,
            style: TextStyle(
              decoration: TextDecoration.underline,
              decorationColor: mid,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
