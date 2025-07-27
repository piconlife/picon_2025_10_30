part of 'view.dart';

class ViewCornerRadius {
  final double topLeft;
  final double topRight;
  final double bottomLeft;
  final double bottomRight;

  const ViewCornerRadius({
    this.topLeft = 0,
    this.topRight = 0,
    this.bottomLeft = 0,
    this.bottomRight = 0,
  });

  const ViewCornerRadius.all(double value)
      : topLeft = value,
        topRight = value,
        bottomLeft = value,
        bottomRight = value;

  const ViewCornerRadius.topAll(double value)
      : topLeft = value,
        topRight = value,
        bottomLeft = 0,
        bottomRight = 0;

  const ViewCornerRadius.bottomAll(double value)
      : topLeft = 0,
        topRight = 0,
        bottomLeft = value,
        bottomRight = value;

  const ViewCornerRadius.leftAll(double value)
      : topLeft = value,
        topRight = 0,
        bottomLeft = value,
        bottomRight = 0;

  const ViewCornerRadius.rightAll(double value)
      : topLeft = 0,
        topRight = value,
        bottomLeft = 0,
        bottomRight = value;

  double get all {
    var radius = topLeft;
    if (radius < topRight) {
      radius = topRight;
    }
    if (radius < bottomLeft) {
      radius = bottomLeft;
    }
    if (radius < bottomRight) {
      radius = bottomRight;
    }
    return radius;
  }

  double get average => (topLeft + topRight + bottomLeft + bottomRight) / 4;
}
