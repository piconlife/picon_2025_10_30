import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/models/selection.dart';
import 'package:flutter_androssy_kits/widgets/field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_navigator/in_app_navigator.dart';
import 'package:object_finder/object_finder.dart';

import '../../../../app/res/icons.dart';
import '../../../../data/models/user.dart';
import '../../../../roots/widgets/button.dart';
import '../../../../roots/widgets/coordinator.dart';
import '../../../../roots/widgets/exception.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/selection.dart';
import '../../../../roots/widgets/stack_button.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/keys.dart';
import '../../../../routes/paths.dart';
import '../cubits/suggested_user_cubit.dart';
import '../templates/item_suggested_user.dart';

class ChooseFollowingPage extends StatefulWidget {
  final Object? args;

  const ChooseFollowingPage({super.key, this.args});

  @override
  State<ChooseFollowingPage> createState() => _ChooseFollowingPageState();
}

class _ChooseFollowingPageState extends State<ChooseFollowingPage> {
  late bool isOnboardingMode = widget.args.find(
    key: kRouteOnboardingMode,
    defaultValue: false,
  );
  final int initialSize = 25;
  final int fetchingSize = 50;

  final _controller = TextEditingController();
  final _notifier = ValueNotifier(<String>[]);

  void _changed(Iterable<String> tags) {
    _notifier.value = tags.toList();
  }

  void _loadMore(BuildContext context) {
    context.read<SuggestedUsersCubit>().fetch(
      initialSize: initialSize,
      fetchingSize: fetchingSize,
    );
  }

  void _submit(BuildContext context) {
    if (isOnboardingMode) return _next(context);
    List<String> data = List.from(_notifier.value);
    context.close(result: data);
  }

  void _next(BuildContext context) {
    InAppNavigator.setVisitor(Routes.chooseFollowing);
    if (!isOnboardingMode) {
      context.close();
      return;
    }
    final target = Routes.chooseChannel;
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
                          InAppIcons.following.regular,
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
                          "Suggested for you",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: dimen.dp(20), color: dark),
                        ),
                        SizedBox(height: dimen.dp(8)),
                        InAppText(
                          "Select three or more item that you are follow in.",
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
              toolbar: Container(
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.85, 1],
                    colors: [light, light.withAlpha(0)],
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: dimen.dp(16)),
                child: AndrossyField(
                  controller: _controller,
                  primaryColor: primary,
                  secondaryColor: context.dark.t30,
                  errorColor: context.error,
                  height: kToolbarHeight * 0.95,
                  animationDuration: const Duration(milliseconds: 300),
                  borderColor: AndrossyFieldProperty(enabled: primary.t25),
                  hintColor: dark.t60,
                  borderRadius: AndrossyFieldProperty.all(
                    BorderRadius.circular(dimen.dp(16)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: dimen.dp(16),
                  ),
                  drawableEndTint: AndrossyFieldProperty(
                    enabled: context.mid,
                    validFocused: primary,
                  ),
                  drawableStartPadding: AndrossyFieldProperty(
                    enabled: dimen.dp(12),
                  ),
                  drawableEndPadding: AndrossyFieldProperty(
                    enabled: dimen.dp(4),
                  ),
                  hintText: "Search here",
                  inputAction: TextInputAction.search,
                  inputType: TextInputType.text,
                ),
              ),
              child:
                  BlocBuilder<SuggestedUsersCubit, Response<Selection<User>>>(
                    builder: (context, response) {
                      if (response.isLoading && response.result.isEmpty) {
                        return ListView.builder(
                          padding: EdgeInsets.only(
                            left: dimen.dp(12),
                            right: dimen.dp(12),
                            bottom: dimen.dp(100),
                          ),
                          itemCount: initialSize,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                top: response.result.isEmpty ? 0 : dimen.dp(24),
                                bottom: dimen.dp(24),
                              ),
                              child: PlaceholderSuggestedUser(),
                            );
                          },
                        );
                      }
                      if (response.result.isEmpty) {
                        return Align(
                          alignment: Alignment(0, -0.2),
                          child: InAppException(
                            "No suggested user found!",
                            icon: InAppIcons.followers.regular,
                            spaceBetween: dimen.dp(24),
                          ),
                        );
                      }
                      final items = response.result;
                      if (response.isLoading) {
                        items.addAll(
                          List.generate(fetchingSize, (i) {
                            return Selection(id: "", data: User());
                          }),
                        );
                      } else if (response.isLoaded) {
                        items.removeWhere((e) {
                          return e.id.isEmpty;
                        });
                      }

                      return InAppSelection(
                        controller: _controller,
                        initialTags: _notifier.value,
                        onSelectedTags: _changed,
                        items: items,
                        tagBuilder: (item) => item.id,
                        searchBuilder: (query, item) {
                          return item.data.name
                              .toString()
                              .toLowerCase()
                              .contains(query.trim().toLowerCase());
                        },
                        builder: (context, instance) {
                          final item = instance.data;
                          if (item.id.isEmpty) {
                            return PlaceholderSuggestedUser();
                          }
                          return ItemSuggestedUser(
                            selection: item.copy(selected: instance.selected),
                            onTap:
                                () => context.open(
                                  Routes.userProfile,
                                  arguments: {"$User": item.data},
                                ),
                            onFollow: instance.call,
                          );
                        },
                        listBuilder: (context, children) {
                          if (children.isEmpty) {
                            return InAppException("No suggested user matched!");
                          }
                          return ListView.separated(
                            padding: EdgeInsets.only(
                              left: dimen.dp(12),
                              right: dimen.dp(12),
                              bottom: dimen.dp(100),
                            ),
                            itemCount: children.length + 1,
                            itemBuilder: (context, index) {
                              if (index == children.length) {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(dimen.dp(12)),
                                    child: InAppButton(
                                      text: "MORE",
                                      textStyle: TextStyle(color: primary),
                                      backgroundColor: primary.t10,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: dimen.dp(24),
                                        vertical: dimen.dp(4),
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        dimen.dp(25),
                                      ),
                                      onTap: () => _loadMore(context),
                                    ),
                                  ),
                                );
                              }
                              return children[index];
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: dimen.dp(12));
                            },
                          );
                        },
                      );
                    },
                  ),
            ),
            ValueListenableBuilder(
              valueListenable: _notifier,
              builder: (context, value, child) {
                return InAppStackButton(
                  value.isEmpty
                      ? isOnboardingMode
                          ? "Skip"
                          : "Cancel"
                      : "Selected ${value.length} ${value.length > 1 ? "channels" : "channel"}",
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
