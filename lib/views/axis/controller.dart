part of 'view.dart';

class AxisViewController extends ViewController {
  double x = 0, y = 0;

  void setX(double value) {
    onNotifyWithCallback(() => x = value);
  }

  void setY(double value) {
    onNotifyWithCallback(() => y = value);
  }

  AxisViewController fromAxisView(AxisView view) {
    super.fromView(view);
    x = view.x;
    y = view.y;
    return this;
  }
}
