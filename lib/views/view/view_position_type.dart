part of 'view.dart';

enum ViewPositionType {
  /// Left positions
  left(ViewPosition(left: 0)),
  leftTop(ViewPosition(left: 0, top: 0)),
  leftBottom(ViewPosition(left: 0, bottom: 0)),
  leftFlex(ViewPosition(left: 0, top: 0, bottom: 0)),

  /// Right positions
  right(ViewPosition(right: 0)),
  rightTop(ViewPosition(right: 0, top: 0)),
  rightBottom(ViewPosition(right: 0, bottom: 0)),
  rightFlex(ViewPosition(right: 0, top: 0, bottom: 0)),

  /// Top positions
  top(ViewPosition(top: 0)),
  topLeft(ViewPosition(top: 0, left: 0)),
  topRight(ViewPosition(top: 0, right: 0)),
  topFlex(ViewPosition(top: 0, left: 0, right: 0)),

  /// Bottom positions
  bottom(ViewPosition(bottom: 0)),
  bottomLeft(ViewPosition(bottom: 0, left: 0)),
  bottomRight(ViewPosition(bottom: 0, right: 0)),
  bottomFlex(ViewPosition(bottom: 0, left: 0, right: 0)),

  /// Center positions
  center,
  centerFlexX(ViewPosition(left: 0, right: 0)),
  centerFlexY(ViewPosition(top: 0, bottom: 0)),
  centerFill(ViewPosition(left: 0, right: 0, top: 0, bottom: 0));

  final ViewPosition position;

  const ViewPositionType([
    this.position = const ViewPosition(),
  ]);
}

extension ViewPositionExtension on ViewPositionType? {
  ViewPositionType get use => this ?? ViewPositionType.center;

  /// Left positions
  bool get isLeft => use == ViewPositionType.left;

  bool get isLeftTop => use == ViewPositionType.leftTop;

  bool get isLeftBottom => use == ViewPositionType.leftBottom;

  bool get isLeftFlex => use == ViewPositionType.leftFlex;

  bool get isLeftMode {
    return isLeft || isLeftTop || isLeftBottom || isLeftFlex;
  }

  /// Right positions
  bool get isRight => use == ViewPositionType.right;

  bool get isRightTop => use == ViewPositionType.rightTop;

  bool get isRightBottom => use == ViewPositionType.rightBottom;

  bool get isRightFlex => use == ViewPositionType.rightFlex;

  bool get isRightMode {
    return isRight || isRightTop || isRightBottom || isRightFlex;
  }

  bool get isXMode => isLeftMode || isRightMode;

  /// Top positions
  bool get isTop => use == ViewPositionType.top;

  bool get isTopLeft => use == ViewPositionType.topLeft;

  bool get isTopRight => use == ViewPositionType.topRight;

  bool get isTopFlex => use == ViewPositionType.topFlex;

  bool get isTopMode {
    return isTop || isTopLeft || isTopRight || isTopFlex;
  }

  /// Bottom positions
  bool get isBottom => use == ViewPositionType.bottom;

  bool get isBottomLeft => use == ViewPositionType.bottomLeft;

  bool get isBottomRight => use == ViewPositionType.bottomRight;

  bool get isBottomFlex => use == ViewPositionType.bottomFlex;

  bool get isBottomMode {
    return isBottom || isBottomLeft || isBottomRight || isBottomFlex;
  }

  bool get isYMode => isTopMode || isBottomMode;

  /// Center positions
  bool get isCenter => use == ViewPositionType.center;

  bool get isCenterFlexX => use == ViewPositionType.centerFlexX;

  bool get isCenterFlexY => use == ViewPositionType.centerFlexY;

  bool get isCenterFill => use == ViewPositionType.centerFill;

  bool get isCenterMode {
    return isCenter || isCenterFlexX || isCenterFlexY || isCenterFill;
  }
}
