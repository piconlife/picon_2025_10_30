part of 'view.dart';

enum FlexPosition {
  centerX(left: 0, right: 0),
  centerY(top: 0, bottom: 0),
  start(left: 0, top: 0, bottom: 0),
  end(right: 0, top: 0, bottom: 0),
  above(top: 0, left: 0, right: 0),
  down(bottom: 0, left: 0, right: 0);

  final double? top, bottom, left, right;

  const FlexPosition({
    this.top,
    this.bottom,
    this.left,
    this.right,
  });
}
