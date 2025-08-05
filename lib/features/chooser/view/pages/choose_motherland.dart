import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions.dart';
import 'package:flutter_andomie/models/country.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/res/icons.dart';
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

class ChooseMotherlandPage extends StatefulWidget {
  final Object? args;
  final bool multiSelection;

  const ChooseMotherlandPage({
    super.key,
    this.args,
    this.multiSelection = false,
  });

  @override
  State<ChooseMotherlandPage> createState() => _ChooseMotherlandPageState();
}

class _ChooseMotherlandPageState extends State<ChooseMotherlandPage> {
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
  late final _roots = kCountries.toList();
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
    InAppNavigator.setVisitor(Routes.editUserPrimaryAddress);
    if (!isOnboardingMode) {
      context.close();
      return;
    }
    final target = Routes.chooseCountry;
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
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(dimen.dp(16)),
      borderSide: BorderSide(color: primary),
    );
    final flagSize = dimen.dp(120);
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
                          InAppIcons.nationality.regular,
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
                          "Which is your motherland?",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: dimen.dp(20), color: dark),
                        ),
                        SizedBox(height: dimen.dp(8)),
                        InAppText(
                          "Select your motherland",
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
                  filterMode: true,
                  items: _roots,
                  tagBuilder: (item) => item.code,
                  searchBuilder: (query, item) {
                    return item.nationality.use.toLowerCase().contains(
                      query.trim().toLowerCase(),
                    );
                  },
                  builder: (context, instance) {
                    final item = instance.data;
                    final selected = instance.selected;
                    return InAppGesture(
                      onTap: instance.call,
                      backgroundColor: selected ? primary : primary.t10,
                      splashBorderRadius: BorderRadius.circular((15)),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: dimen.dp(16),
                          vertical: dimen.dp(8),
                        ),
                        decoration: BoxDecoration(),
                        child: InAppText(
                          item.nationality,
                          style: TextStyle(
                            color: selected ? Colors.white : primary,
                          ),
                        ),
                      ),
                    );
                  },
                  listBuilder: (context, children) {
                    if (children.isEmpty) {
                      return InAppException("No motherland matched!");
                    }
                    return Wrap(
                      runSpacing: dimen.dp(8),
                      spacing: dimen.dp(8),
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
                        : "Selected ${value.length} ${value.length > 1 ? "motherlands" : "motherland"}",
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
