part of 'view.dart';

class StackLayoutController extends ViewController {
  Alignment layoutGravity = Alignment.center;

  void setLayoutGravity(Alignment value) {
    onNotifyWithCallback(() => layoutGravity = value);
  }

  List<Widget> children = [];

  void setChildren(List<Widget> value) {
    onNotifyWithCallback(() => children = value);
  }

  StackLayoutController fromStackLayout(StackLayout view) {
    super.fromView(view);
    layoutGravity = view.layoutGravity;
    children = view.children;
    return this;
  }
}
