part of 'view.dart';

class ChooserViewController<T> extends ViewController {
  ChooserViewController<T> fromChooserView(ChooserView<T> view) {
    super.fromView(view);
    currentIndex = view.currentIndex;
    items = view.items;
    itemAlignment = view.itemAlignment;
    itemClipBehavior = view.itemClipBehavior;
    itemCrossAlignment = view.itemCrossAlignment;
    itemDirection = view.itemDirection;
    itemFlowAlignment = view.itemFlowAlignment;
    itemTextDirection = view.itemTextDirection;
    itemVerticalDirection = view.itemVerticalDirection;
    itemRunSpace = view.itemRunSpace;
    itemSpace = view.itemSpace;
    return this;
  }

  /// CUSTOMIZATIONS

  int get size => items.length;

  int get _i {
    if (currentIndex < 0) {
      return 0;
    }
    if (currentIndex > size) {
      return size - 1;
    }
    return currentIndex;
  }

  T get currentItem => items[_i];

  /// BASE PROPERTIES
  int currentIndex = 0;
  List<T> items = [];
  WrapAlignment itemAlignment = WrapAlignment.start;
  Clip itemClipBehavior = Clip.none;
  WrapCrossAlignment itemCrossAlignment = WrapCrossAlignment.start;
  Axis itemDirection = Axis.horizontal;
  WrapAlignment itemFlowAlignment = WrapAlignment.start;
  TextDirection? itemTextDirection;
  VerticalDirection itemVerticalDirection = VerticalDirection.down;
  double itemRunSpace = 12;
  double itemSpace = 8;

  /// SUPER PROPERTIES
  @override
  Axis get orientation {
    return itemDirection == Axis.vertical ? Axis.horizontal : Axis.vertical;
  }

  @override
  void onNotify([int index = 0]) {
    if (currentIndex != index) {
      currentIndex = index;
      super.onNotify();
    }
  }

  @override
  void onNotifyWithCallback(VoidCallback callback, [int index = 0]) {
    if (currentIndex != index) {
      currentIndex = index;
      super.onNotifyWithCallback(callback);
    }
  }
}
