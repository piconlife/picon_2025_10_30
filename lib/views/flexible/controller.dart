part of 'view.dart';

class FlexibleViewController extends ViewController {
  Widget flexible = const SizedBox();
  FlexPosition flexPosition = FlexPosition.start;
  FlexVisibleType visibleType = FlexVisibleType.front;

  @override
  Widget get child => super.child ?? const SizedBox();

  bool get isBack => visibleType == FlexVisibleType.back;

  bool get isFront => visibleType == FlexVisibleType.front;

  @override
  FlexibleViewController fromView(
    YMRView<ViewController> view, {
    Widget? flexible,
    FlexPosition? flexPosition,
    FlexVisibleType? visibleType,
  }) {
    super.fromView(view);
    this.flexible = flexible ?? const SizedBox();
    this.flexPosition = flexPosition ?? FlexPosition.start;
    this.visibleType = visibleType ?? FlexVisibleType.front;
    return this;
  }
}
