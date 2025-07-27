part of 'view.dart';

class SlideLayoutController<T> extends ViewController {
  late PageController pager;
  late TextViewController tvCounter;
  final index = 0.obx;

  List<T> items = [];
  double frameRatio = 1;
  bool counterVisible = true;
  ViewPositionType counterPosition = ViewPositionType.topRight;

  OnSlideLayoutCounterBuilder<T>? counterBuilder;
  OnSlideLayoutCounterHandler? counterHandler;

  void setIndex(int value) {
    onNotifyWithCallback(() => index.set(value));
  }

  void setFrameRatio(double value) {
    onNotifyWithCallback(() => frameRatio = value);
  }

  void setCounterPosition(ViewPositionType value) {
    onNotifyWithCallback(() => counterPosition = value);
  }

  void setCounterVisible(bool value) {
    onNotifyWithCallback(() => counterVisible = value);
  }

  void setItems(List<T> value) {
    onNotifyWithCallback(() => items = value);
  }

  SlideLayoutController<T> fromSlideImageView(SlideLayout<T> view) {
    super.fromView(view);
    this.counterBuilder = view.counterBuilder;
    this.counterHandler = view.counterHandler;
    this.counterPosition = view.counterPosition ?? ViewPositionType.topRight;
    this.counterVisible = view.counterVisible ?? true;
    this.index.value = view.index;
    this.items = view.items;
    this.frameRatio = view.frameRatio;
    this.pager = PageController(initialPage: index.value);
    this.tvCounter = TextViewController();
    return this;
  }

  T get item => items[index.value];

  int get size => items.length;

  void _changeIndex(int value) {
    index.value = value;
    if (counterHandler != null) {
      counterHandler!(value, size);
    }
  }

  String countingText(
    int current,
    int total, [
    String separator = "/",
  ]) {
    return "$current$separator$total";
  }

  void _dispose() {
    pager.dispose();
  }
}
