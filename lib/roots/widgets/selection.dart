import 'package:flutter/material.dart';
import 'package:flutter_androssy_kits/widgets.dart';

class InAppSelection<T> extends StatelessWidget {
  final TextEditingController? controller;
  final List<T> items;
  final Iterable<String> initialTags;
  final bool singleMode;
  final bool filterMode;
  final ValueChanged<List<String>> onSelectedTags;
  final AndrossySelectionBuilder<T> builder;
  final AndrossySelectionSearchBuilder<T>? searchBuilder;
  final AndrossySelectionTagBuilder<T> tagBuilder;
  final AndrossySelectionListBuilder<T>? listBuilder;

  final Axis direction;
  final WrapAlignment alignment;
  final double spacing;
  final WrapAlignment runAlignment;
  final double runSpacing;
  final WrapCrossAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final Clip clipBehavior;

  const InAppSelection({
    super.key,
    this.controller,
    this.searchBuilder,
    this.items = const [],
    this.singleMode = false,
    this.filterMode = false,
    this.initialTags = const {},
    required this.onSelectedTags,
    required this.builder,
    required this.tagBuilder,
    this.listBuilder,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.spacing = 8.0,
    this.runAlignment = WrapAlignment.start,
    this.runSpacing = 8.0,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    return AndrossySelection(
      controller: controller,
      searchBuilder: searchBuilder,
      items: items,
      singleMode: singleMode,
      filterMode: filterMode,
      initialTags: initialTags,
      onSelectedTags: onSelectedTags,
      builder: builder,
      tagBuilder: tagBuilder,
      listBuilder: listBuilder,
      direction: direction,
      alignment: alignment,
      spacing: spacing,
      runAlignment: runAlignment,
      runSpacing: runSpacing,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      clipBehavior: clipBehavior,
    );
  }
}
