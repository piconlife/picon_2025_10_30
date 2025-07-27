part of 'view.dart';

class LinearLayoutController extends ViewController {
  LayoutGravity layoutGravity = LayoutGravity.start;

  void setLayoutGravity(LayoutGravity value) {
    onNotifyWithCallback(() => layoutGravity = value);
  }

  CrossAxisAlignment? _crossGravity;

  set crossGravity(CrossAxisAlignment? value) => _crossGravity = value;

  void setCrossGravity(CrossAxisAlignment value) {
    onNotifyWithCallback(() => crossGravity = value);
  }

  MainAxisAlignment? _mainGravity;

  set mainGravity(MainAxisAlignment? value) => _mainGravity = value;

  void setMainGravity(MainAxisAlignment value) {
    onNotifyWithCallback(() => mainGravity = value);
  }

  MainAxisSize mainAxisSize = MainAxisSize.min;

  void setMainAxisSize(MainAxisSize value) {
    onNotifyWithCallback(() => mainAxisSize = value);
  }

  TextBaseline? textBaseline;

  void setTextBaseLine(TextBaseline? value) {
    onNotifyWithCallback(() => textBaseline = value);
  }

  TextDirection? textDirection;

  void setTextDirection(TextDirection? value) {
    onNotifyWithCallback(() => textDirection = value);
  }

  VerticalDirection verticalDirection = VerticalDirection.down;

  void setVerticalDirection(VerticalDirection value) {
    onNotifyWithCallback(() => verticalDirection = value);
  }

  List<Widget> children = [];

  void setChildren(List<Widget> value) {
    onNotifyWithCallback(() => children = value);
  }

  OnViewChangeListener? _onPaging;

  OnViewChangeListener? get onPaging => enabled ? _onPaging : null;

  set onPaging(OnViewChangeListener? listener) => _onPaging ??= listener;

  void setOnPagingListener(OnViewChangeListener listener) {
    onPaging = listener;
  }

  LinearLayoutController fromLinearLayout(LinearLayout view) {
    super.fromView(view);
    scrollController = view.scrollController ?? ScrollController();
    orientation = view.orientation ?? Axis.vertical;
    layoutGravity = view.layoutGravity ?? LayoutGravity.start;
    mainGravity = view.mainGravity;
    mainAxisSize = view.mainAxisSize;
    crossGravity = view.crossGravity;
    scrollable = view.scrollable ?? false;
    scrollingType = view.scrollingType ?? ViewScrollingType.none;
    textBaseline = view.textBaseline;
    textDirection = view.textDirection;
    verticalDirection = view.verticalDirection;
    children = view.children ?? [];
    onPaging = view.onPaging;
    return this;
  }

  MainAxisAlignment get mainGravity => _mainGravity ?? layoutGravity.main;

  CrossAxisAlignment get crossGravity => _crossGravity ?? layoutGravity.cross;

  @override
  ScrollController? get scrollController {
    if (onPaging != null) {
      return super.scrollController?.paging(onListen: onPaging ?? (v) {});
    } else {
      return super.scrollController;
    }
  }
}
