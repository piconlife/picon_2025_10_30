import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions.dart';
import 'package:flutter_andomie/utils/validator.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/res/icons.dart';
import '../../../../app/styles/fonts.dart';
import '../../../../roots/widgets/coordinator.dart';
import '../../../../roots/widgets/exception.dart';
import '../../../../roots/widgets/fade.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/selection.dart';
import '../../../../roots/widgets/stack_button.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/keys.dart';
import '../../../../routes/paths.dart';
import '../../data/keys/keys.dart';
import '../../data/models/religion.dart';

const kReligions = "religions";

class ChooseReligionPage extends StatefulWidget {
  final Object? args;
  final bool multiSelection;

  const ChooseReligionPage({super.key, this.args, this.multiSelection = false});

  @override
  State<ChooseReligionPage> createState() => _ChooseReligionPageState();
}

class _ChooseReligionPageState extends State<ChooseReligionPage> {
  late bool isOnboardingMode = widget.args.find(
    key: kRouteOnboardingMode,
    defaultValue: false,
  );
  late final bool isSubmitMode = widget.args.find(
    key: ChoosingRouteKeys.submitMode,
    defaultValue: false,
  );
  late List<String> initials = widget.args.finds(
    key: ChoosingRouteKeys.data,
    defaultValue: [],
  );
  late final bool _single = !widget.multiSelection;
  late final _notifier = ValueNotifier(initials);
  late final _roots = InAppReligion.cache;
  late final _controller = TextEditingController();

  void _changed(List<String> tags) {
    _notifier.value = tags;
    if (isSubmitMode) _submit(context);
  }

  void _submit(BuildContext context) {
    if (isOnboardingMode) return _next(context);
    List<String> data = List.from(_notifier.value);
    if (_single) {
      context.close(result: data.firstOrNull);
      return;
    }
    context.close(result: data);
  }

  void _next(BuildContext context) {
    InAppNavigator.setVisitor(Routes.chooseReligion);
    if (!isOnboardingMode) {
      context.close();
      return;
    }
    final target = Routes.chooseFollowing;
    if (InAppNavigator.isNotVisited(target)) {
      context.clear(
        target,
        arguments: {kRouteOnboardingMode: isOnboardingMode},
      );
      return;
    }
    context.clear(Routes.main);
  }

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final light = context.light;
    final dark = context.dark;
    final primary = context.primary;
    final flagSize = dimen.dp(120);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(dimen.dp(16)),
      borderSide: BorderSide(color: primary),
    );
    return Scaffold(
      backgroundColor: light,
      body: SafeArea(
        bottom: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            InAppCoordinator(
              header: Column(
                children: [
                  SizedBox(height: dimen.dp(40)),
                  SizedBox.square(
                    dimension: flagSize,
                    child: CircleAvatar(
                      backgroundColor: primary.t10,
                      child: Padding(
                        padding: EdgeInsets.all(flagSize * 0.25),
                        child: InAppImage(
                          InAppIcons.religion.regular,
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
                          "Which religion are you follow?",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: dimen.dp(20), color: dark),
                        ),
                        SizedBox(height: dimen.dp(8)),
                        InAppText(
                          "Please confirm your religion. Because, it will be not changed any time.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: dimen.dp(14),
                            color: dark.t50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              toolbarHeight: kToolbarHeight + dimen.dp(16),
              toolbar: InAppFade(
                child: Container(
                  width: double.infinity,
                  height: kToolbarHeight,
                  alignment: Alignment.center,
                  color: light,
                  padding: EdgeInsets.symmetric(horizontal: dimen.dp(16)),
                  child: TextField(
                    controller: _controller,
                    cursorColor: primary,
                    style: TextStyle(fontSize: dimen.dp(18)),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: dimen.dp(24),
                        vertical: dimen.dp(12),
                      ),
                      filled: true,
                      fillColor: primary.t10,
                      hintText: "Search here",
                      border: border,
                      enabledBorder: border,
                      focusedBorder: border,
                    ),
                  ),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: dimen.dp(16),
                  right: dimen.dp(16),
                  bottom: dimen.dp(100),
                ),
                child: InAppSelection(
                  controller: _controller,
                  initialTags: _notifier.value,
                  onSelectedTags: _changed,
                  singleMode: _single,
                  items: _roots,
                  tagBuilder: (item) => item.label ?? item.id ?? '',
                  searchBuilder: (query, item) {
                    return item.label.use.toLowerCase().contains(
                      query.trim().toLowerCase(),
                    );
                  },
                  builder: (context, instance) {
                    final item = instance.data;
                    final selected = instance.selected;
                    final isValidPhoto = item.photo.isValidWebUrl;
                    return InAppGesture(
                      onTap: instance.call,
                      backgroundColor: selected ? primary : primary.t10,
                      splashBorderRadius: BorderRadius.circular((15)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (isValidPhoto)
                            InAppImage(
                              item.photo,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          Container(
                            color: isValidPhoto
                                ? selected
                                      ? Colors.white.withValues(alpha: 0.9)
                                      : Colors.black26
                                : null,
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: dimen.dp(16),
                                vertical: dimen.dp(8),
                              ),
                              child: InAppText(
                                item.label,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isValidPhoto
                                      ? selected
                                            ? Colors.black
                                            : Colors.white
                                      : selected
                                      ? Colors.white
                                      : primary,
                                  fontWeight: dimen.boldFontWeight,
                                  fontSize: dimen.dp(18),
                                  fontFamily: InAppFonts.secondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  listBuilder: (context, children) {
                    if (children.isEmpty) {
                      return InAppException("No region matched!");
                    }
                    final isImageMode = _roots.any((e) {
                      return e.photo.use.isNotEmpty;
                    });

                    return GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: isImageMode ? 2 / 1.5 : 2 / 1.25,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      children: children,
                    );
                  },
                ),
              ),
            ),
            if (!isSubmitMode)
              ValueListenableBuilder(
                valueListenable: _notifier,
                builder: (context, value, child) {
                  return InAppStackButton(
                    value.isEmpty || value.isSame(initials)
                        ? isOnboardingMode
                              ? "Skip"
                              : "Cancel"
                        : _single
                        ? "Update"
                        : "Selected ${value.length} ${value.length > 1 ? "religions" : "religion"}",
                    onTap: () => _submit(context),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
