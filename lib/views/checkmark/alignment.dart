part of 'view.dart';

enum CheckboxAlignment {
  leftCenter,
  leftTop,
  leftBottom,
  rightCenter,
  rightTop,
  rightBottom;

  bool get isLeftCenter => this == leftCenter;

  bool get isLeftTop => this == leftTop;

  bool get isLeftBottom => this == leftBottom;

  bool get isRightCenter => this == rightCenter;

  bool get isRightTop => this == rightTop;

  bool get isRightBottom => this == rightBottom;

  bool get isCenterMode => isLeftCenter || isRightCenter;

  bool get isTopMode => isLeftTop || isRightTop;

  bool get isBottomMode => isLeftBottom || isRightBottom;

  bool get isLeftMode => isLeftCenter || isLeftTop || isLeftBottom;
}
