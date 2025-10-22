import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/spacing.dart';
import 'package:flutter_andomie/extensions/string.dart';
import 'package:flutter_androssy_kits/widgets.dart';
import 'package:in_app_navigator/in_app_navigator.dart';
import 'package:object_finder/object_finder.dart';

import '../../../../app/res/icons.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/filled_button.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../roots/widgets/texted_action.dart';
import '../../../../roots/widgets/user_builder.dart';
import '../../../../routes/keys.dart';
import '../../../../routes/paths.dart';

class EditUserAddressPage extends StatefulWidget {
  final bool primary;
  final Object? args;

  const EditUserAddressPage({super.key, this.primary = false, this.args});

  @override
  State<EditUserAddressPage> createState() {
    return _EditUserAddressPageState();
  }
}

class _EditUserAddressPageState extends State<EditUserAddressPage> {
  late bool isOnboardingMode = widget.args.find(
    key: kRouteOnboardingMode,
    defaultValue: false,
  );

  final etHouse = TextEditingController();
  final etRoad = TextEditingController();
  final etArea = TextEditingController();
  final etSection = TextEditingController();
  final etPostCode = TextEditingController();
  final etPoliceStation = TextEditingController();
  final etCity = TextEditingController();

  void _submit(BuildContext context) {
    if (isOnboardingMode) return _next(context);
    context.close();
  }

  void _next(BuildContext context) {
    InAppNavigator.setVisitor(
      widget.primary
          ? Routes.editUserPrimaryAddress
          : Routes.editUserSecondaryAddress,
    );
    if (!isOnboardingMode) {
      context.close();
      return;
    }
    final target =
        widget.primary ? Routes.editUserSecondaryAddress : Routes.chooseCountry;
    if (InAppNavigator.isNotVisited(target)) {
      context.clear(
        target,
        arguments: {kRouteOnboardingMode: isOnboardingMode},
      );
      return;
    }
    context.clear(Routes.main);
  }

  void _skip(BuildContext context) => _next(context);

  @override
  Widget build(BuildContext context) {
    final primary = context.primary;
    final dark = context.dark;
    final dimen = context.dimens;
    final flagSize = dimen.dp(120);
    return Scaffold(
      appBar: InAppAppbar(
        titleText: "Update address",
        actions: [
          InAppTextedAction(
            isOnboardingMode ? "Skip" : "Cancel",
            onTap: () => _skip(context),
          ),
        ],
      ),
      backgroundColor: context.light,
      body: ListView(
        children: [
          SizedBox(height: dimen.dp(40)),
          SizedBox.square(
            dimension: flagSize,
            child: CircleAvatar(
              backgroundColor: primary.t10,
              child: Padding(
                padding: EdgeInsets.all(flagSize * 0.25),
                child: InAppImage(
                  InAppIcons.location.regular,
                  tint: primary,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(dimen.dp(24)),
            child: Column(
              children: [
                InAppText(
                  widget.primary
                      ? "Complete your permanent address"
                      : "Complete your current address",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: dimen.dp(20), color: dark),
                ),
                SizedBox(height: dimen.dp(8)),
                InAppText(
                  "Please your current address to find personal information in your area.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: dimen.dp(14), color: dark.t50),
                ),
                SizedBox(height: dimen.dp(24)),
                InAppUserBuilder(
                  builder: (context, user) {
                    final isPrimary = widget.primary;
                    final primary = user.primaryInfo.address;
                    final secondary = user.secondaryInfo.address;
                    etHouse.text =
                        isPrimary
                            ? primary.house.use
                            : secondary.house ?? primary.house.use;
                    etRoad.text =
                        isPrimary
                            ? primary.road.use
                            : secondary.road ?? primary.road.use;
                    etArea.text =
                        isPrimary
                            ? primary.area.use
                            : secondary.area ?? primary.area.use;
                    etSection.text =
                        isPrimary
                            ? primary.section.use
                            : secondary.section ?? primary.section.use;
                    etPostCode.text =
                        isPrimary
                            ? primary.postCode.use
                            : secondary.postCode ?? primary.postCode.use;
                    etPoliceStation.text =
                        isPrimary
                            ? primary.policeStation.use
                            : secondary.policeStation ??
                                primary.policeStation.use;
                    etCity.text =
                        isPrimary
                            ? primary.city.use
                            : secondary.city ?? primary.city.use;
                    return AndrossyForm(
                      primaryColor: context.primary,
                      secondaryColor: context.dark.t30,
                      errorColor: context.error,
                      animationDuration: const Duration(milliseconds: 300),
                      borderColor: const AndrossyFieldProperty.auto(),
                      borderRadius: AndrossyFieldProperty.all(
                        BorderRadius.circular(dimen.dp(25)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: dimen.dp(16),
                        vertical: dimen.dp(12),
                      ),
                      floatingPadding: EdgeInsets.symmetric(
                        horizontal: dimen.dp(12),
                        vertical: dimen.dp(4),
                      ),
                      floatingAlignment: Alignment.topRight,
                      floatingVisibility: FloatingVisibility.always,
                      children: [
                        if (!widget.primary) ...[
                          AndrossyField(
                            controller: etHouse,
                            hintText: "House (Optional)",
                            inputAction: TextInputAction.next,
                            inputType: TextInputType.streetAddress,
                          ),
                          dimen.dp(16).h,
                          AndrossyField(
                            controller: etRoad,
                            hintText: "Road (Optional)",
                            inputAction: TextInputAction.next,
                            inputType: TextInputType.streetAddress,
                          ),
                          dimen.dp(16).h,
                        ],
                        AndrossyField(
                          controller: etArea,
                          hintText: "Area",
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.streetAddress,
                        ),
                        dimen.dp(16).h,
                        AndrossyField(
                          controller: etSection,
                          hintText: "Section",
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.streetAddress,
                        ),
                        dimen.dp(16).h,
                        AndrossyField(
                          controller: etPostCode,
                          hintText: "Postal code",
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.streetAddress,
                        ),
                        dimen.dp(16).h,
                        AndrossyField(
                          controller: etPoliceStation,
                          hintText: "Police station",
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.streetAddress,
                        ),
                        dimen.dp(16).h,
                        AndrossyField(
                          controller: etCity,
                          hintText: "City",
                          inputAction: TextInputAction.done,
                          inputType: TextInputType.streetAddress,
                        ),
                        dimen.dp(32).h,
                        InAppFilledButton(
                          text: "Next",
                          onTap: () => _submit(context),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
