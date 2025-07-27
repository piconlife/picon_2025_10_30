part of 'view.dart';

enum FloatingVisibility {
  auto,
  hide,
  always;

  bool get isAuto => this == auto;

  bool get isInvisible => this == hide;

  bool get isVisible => this == always;
}
