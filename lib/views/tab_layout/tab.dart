part of 'view.dart';

class TabItem {
  final String? title;
  final ValueState<String>? titleState;
  final dynamic icon;
  final ValueState<dynamic>? iconState;

  const TabItem({
    this.icon,
    this.iconState,
    this.title,
    this.titleState,
  });
}
