part of 'view.dart';

class NavigationViewController extends ViewController {
  int currentIndex = 0;

  void setNavigationIndex(int value) {
    onNotifyWithCallback(() => currentIndex = value);
  }

  double? iconSize;

  void setIconSize(double? value) {
    onNotifyWithCallback(() => iconSize = value);
  }

  ValueState<double>? iconSizeState;

  void setIconSizeState(ValueState<double>? value) {
    onNotifyWithCallback(() => iconSizeState = value);
  }

  Color? iconTint;

  void setIconTint(Color? value) {
    onNotifyWithCallback(() => iconTint = value);
  }

  ValueState<Color>? iconTintState;

  void setIconTintState(ValueState<Color>? value) {
    onNotifyWithCallback(() => iconTintState = value);
  }

  IconThemeData? iconTheme;

  void setIconTheme(IconThemeData? value) {
    onNotifyWithCallback(() => iconTheme = value);
  }

  ValueState<IconThemeData>? iconThemeState;

  void setIconThemeState(ValueState<IconThemeData>? value) {
    onNotifyWithCallback(() => iconThemeState = value);
  }

  Color? titleColor;

  void setTitleColor(Color? value) {
    onNotifyWithCallback(() => titleColor = value);
  }

  ValueState<Color>? titleColorState;

  void setTitleColorState(ValueState<Color>? value) {
    onNotifyWithCallback(() => titleColorState = value);
  }

  double? titleSize;

  void setTitleSize(double? value) {
    onNotifyWithCallback(() => titleSize = value);
  }

  ValueState<double>? titleSizeState;

  void setTitleSizeState(ValueState<double>? value) {
    onNotifyWithCallback(() => titleSizeState = value);
  }

  TextStyle? titleStyle;

  void setTitleStyle(TextStyle? value) {
    onNotifyWithCallback(() => titleStyle = value);
  }

  ValueState<TextStyle>? titleStyleState;

  void setTitleStyleState(ValueState<TextStyle>? value) {
    onNotifyWithCallback(() => titleStyleState = value);
  }

  List<NavigationItem> items = [];

  void setItems(List<NavigationItem> value) {
    onNotifyWithCallback(() => items = value);
  }

  double spaceBetween = 2;

  void setSpaceBetween(double value) {
    onNotifyWithCallback(() => spaceBetween = value);
  }

  ValueState<double>? spaceBetweenState;

  void setSpaceBetweenState(ValueState<double>? value) {
    onNotifyWithCallback(() => spaceBetweenState = value);
  }

  Color? itemBackground;

  void setItemBackground(Color? value) {
    onNotifyWithCallback(() => itemBackground = value);
  }

  ValueState<Color>? itemBackgroundState;

  void setItemBackgroundState(ValueState<Color>? value) {
    onNotifyWithCallback(() => itemBackgroundState = value);
  }

  double? itemMaxWidth;

  void setItemMaxWidth(double? value) {
    onNotifyWithCallback(() => itemMaxWidth = value);
  }

  double? itemMaxHeight;

  void setItemMaxHeight(double? value) {
    onNotifyWithCallback(() => itemMaxHeight = value);
  }

  double itemMinWidth = 80;

  void setItemMinWidth(double value) {
    onNotifyWithCallback(() => itemMinWidth = value);
  }

  double? itemMinHeight;

  void setItemMinHeight(double? value) {
    onNotifyWithCallback(() => itemMinHeight = value);
  }

  double? itemMargin;

  void setItemMargin(double? value) {
    onNotifyWithCallback(() => itemMargin = value);
  }

  double? itemMarginX;

  void setItemMarginX(double? value) {
    onNotifyWithCallback(() => itemMarginX = value);
  }

  double? itemMarginY;

  void setItemMarginY(double? value) {
    onNotifyWithCallback(() => itemMarginY = value);
  }

  double? itemPadding;

  void setItemPadding(double? value) {
    onNotifyWithCallback(() => itemPadding = value);
  }

  double? itemPaddingX;

  void setItemPaddingX(double? value) {
    onNotifyWithCallback(() => itemPaddingX = value);
  }

  double? itemPaddingY;

  void setItemPaddingY(double? value) {
    onNotifyWithCallback(() => itemPaddingY = value);
  }

  OnNavigationIndexChangeListener? _onIndexChanged;

  set onIndexChanged(OnNavigationIndexChangeListener? value) {
    _onIndexChanged = value;
  }

  void setOnNavigationIndexChangeListener(
    OnNavigationIndexChangeListener value,
  ) {
    onNotifyWithCallback(() => onIndexChanged = value);
  }

  OnNavigationIndexChangeListener? get onIndexChanged {
    return enabled ? _onIndexChanged : null;
  }

  int get length => items.length;

  Axis get navDirection {
    return positionType.isYMode ? Axis.horizontal : Axis.vertical;
  }

  MainAxisAlignment get navMainDirection {
    switch (positionType) {
      case ViewPositionType.center:
      case ViewPositionType.centerFlexX:
      case ViewPositionType.centerFlexY:
      case ViewPositionType.centerFill:
        return MainAxisAlignment.center;
      case ViewPositionType.left:
      case ViewPositionType.leftFlex:
        return MainAxisAlignment.spaceAround;
      case ViewPositionType.leftTop:
        return MainAxisAlignment.start;
      case ViewPositionType.leftBottom:
        return MainAxisAlignment.end;
      case ViewPositionType.right:
      case ViewPositionType.rightFlex:
        return MainAxisAlignment.spaceAround;
      case ViewPositionType.rightTop:
        return MainAxisAlignment.start;
      case ViewPositionType.rightBottom:
        return MainAxisAlignment.end;
      case ViewPositionType.top:
      case ViewPositionType.topFlex:
        return MainAxisAlignment.spaceAround;
      case ViewPositionType.topLeft:
        return MainAxisAlignment.start;
      case ViewPositionType.topRight:
        return MainAxisAlignment.end;
      case ViewPositionType.bottom:
      case ViewPositionType.bottomFlex:
        return MainAxisAlignment.spaceAround;
      case ViewPositionType.bottomLeft:
        return MainAxisAlignment.start;
      case ViewPositionType.bottomRight:
        return MainAxisAlignment.end;
    }
  }

  CrossAxisAlignment get navCrossDirection {
    switch (positionType) {
      case ViewPositionType.center:
      case ViewPositionType.centerFlexX:
      case ViewPositionType.centerFlexY:
      case ViewPositionType.centerFill:
        return CrossAxisAlignment.center;
      case ViewPositionType.left:
      case ViewPositionType.leftFlex:
        return CrossAxisAlignment.center;
      case ViewPositionType.leftTop:
        return CrossAxisAlignment.start;
      case ViewPositionType.leftBottom:
        return CrossAxisAlignment.end;
      case ViewPositionType.right:
      case ViewPositionType.rightFlex:
        return CrossAxisAlignment.center;
      case ViewPositionType.rightTop:
        return CrossAxisAlignment.start;
      case ViewPositionType.rightBottom:
        return CrossAxisAlignment.end;
      case ViewPositionType.top:
      case ViewPositionType.topFlex:
        return CrossAxisAlignment.center;
      case ViewPositionType.topLeft:
        return CrossAxisAlignment.start;
      case ViewPositionType.topRight:
        return CrossAxisAlignment.end;
      case ViewPositionType.bottom:
      case ViewPositionType.bottomFlex:
        return CrossAxisAlignment.center;
      case ViewPositionType.bottomLeft:
        return CrossAxisAlignment.start;
      case ViewPositionType.bottomRight:
        return CrossAxisAlignment.end;
    }
  }

  NavigationType get navigationType {
    if (length < 5) {
      return NavigationType.fixed;
    } else {
      return NavigationType.scrollable;
    }
  }

  NavigationViewController fromNavigationView(NavigationView view) {
    super.fromView(view);
    currentIndex = view.currentIndex;
    iconSize = view.iconSize;
    iconSizeState = view.iconSizeState;
    iconTint = view.iconTint;
    iconTintState = view.iconTintState;
    iconTheme = view.iconTheme;
    iconThemeState = view.iconThemeState;
    titleColor = view.titleColor;
    titleColorState = view.titleColorState;
    titleSize = view.titleSize;
    titleSizeState = view.titleSizeState;
    titleStyle = view.titleStyle;
    titleStyleState = view.titleStyleState;
    spaceBetween = view.spaceBetween;
    spaceBetweenState = view.spaceBetweenState;
    itemBackground = view.itemBackground;
    itemBackgroundState = view.itemBackgroundState;
    itemMaxWidth = view.itemMaxWidth;
    itemMaxHeight = view.itemMaxHeight;
    itemMinWidth = view.itemMinWidth;
    itemMinHeight = view.itemMinHeight;
    itemMargin = view.itemMargin;
    itemMarginX = view.itemMarginX;
    itemMarginY = view.itemMarginY;
    itemPadding = view.itemPadding;
    itemPaddingX = view.itemPaddingX;
    itemPaddingY = view.itemPaddingY;
    items = view.items;
    onIndexChanged = view.onIndexChanged;
    return this;
  }

  NavigationItem getItem(int index) => items[index];

  @override
  void onNotify([int index = 0]) {
    if (currentIndex != index) {
      super.onNotifyWithCallback(() {
        currentIndex = index;
        if (onIndexChanged != null) onIndexChanged?.call(currentIndex);
      });
    }
  }
}
