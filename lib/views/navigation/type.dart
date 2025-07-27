part of 'view.dart';

enum NavigationType {
  fixed,
  scrollable;

  bool get isFixed => this == fixed;

  bool get isScrollable => this == scrollable;
}
