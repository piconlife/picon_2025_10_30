part of 'view.dart';

class TabLayoutController extends ViewController {
  /// BASE PROPERTIES
  int currentIndex = 0;
  List<TabItem> tabs = [];

  void setIndex(int value) {
    if (value != currentIndex) {
      onNotifyWithCallback(() {
        currentIndex = value;
        if (onTabChange != null) onTabChange?.call(currentIndex);
      });
    }
  }

  void setPage(double value, [bool notify = false]) {
    int page = value.round();
    if (page != currentIndex) {
      currentIndex = page;
      if (onTabChange != null) onTabChange?.call(currentIndex);
      if (notify) onNotify();
    }
  }

  void setTabs(List<TabItem> value) {
    onNotifyWithCallback(() => tabs = value);
  }

  void _initProperties(TabLayout view) {
    currentIndex = view.initialIndex;
    tabs = view.tabs ?? [];
  }

  /// TAB PROPERTIES
  Color? _tabContentColor;
  ValueState<Color>? tabContentColorState;
  bool tabInlineLabel = false;
  EdgeInsets? tabMargin;
  TabMode? tabMode;
  EdgeInsets? tabPadding;

  Color? get tabContentColor {
    return tabContentColorState?.fromController(this) ?? _tabContentColor;
  }

  set tabContentColor(Color? value) => _tabContentColor = value;

  void setTabContentColor(Color? value) {
    onNotifyWithCallback(() => tabContentColor = value);
  }

  void setTabContentColorState(ValueState<Color>? value) {
    onNotifyWithCallback(() => tabContentColorState = value);
  }

  void setTabInlineLabel(bool value) {
    onNotifyWithCallback(() => tabInlineLabel = value);
  }

  void setTabMargin(EdgeInsets? value) {
    onNotifyWithCallback(() => tabMargin = value);
  }

  void setTabMode(TabMode? value) {
    onNotifyWithCallback(() => tabMode = value);
  }

  void setTabPadding(EdgeInsets? value) {
    onNotifyWithCallback(() => tabPadding = value);
  }

  void _initTabProperties(TabLayout view) {
    tabContentColor = view.tabContentColor;
    tabContentColorState = view.tabContentColorState;
    tabInlineLabel = view.tabInlineLabel ?? false;
    tabMargin = view.tabMargin;
    tabMode = view.tabMode;
    tabPadding = view.tabPadding;
  }

  /// TAB ICON PROPERTIES
  double? _tabIconSize;
  ValueState<double>? tabIconSizeState;
  double? tabIconSpace;
  Color? _tabIconTint;
  ValueState<Color>? _tabIconTintState;

  double? get tabIconSize {
    return tabIconSizeState?.fromController(this) ?? _tabIconSize;
  }

  Color? get tabIconTint {
    return tabIconTintState?.fromController(this) ??
        _tabIconTint ??
        tabContentColor;
  }

  ValueState<Color>? get tabIconTintState {
    return _tabIconTintState ?? tabContentColorState;
  }

  set tabIconSize(double? value) => _tabIconSize = value;

  set tabIconTint(Color? value) => _tabIconTint = value;

  set tabIconTintState(ValueState<Color>? value) => _tabIconTintState = value;

  void setTabIconSize(double? value) {
    onNotifyWithCallback(() => tabIconSize = value);
  }

  void setTabIconSizeState(ValueState<double>? value) {
    onNotifyWithCallback(() => tabIconSizeState = value);
  }

  void setTabIconSpace(double? value) {
    onNotifyWithCallback(() => tabIconSpace = value);
  }

  void setTabIconTint(Color? value) {
    onNotifyWithCallback(() => tabIconTint = value);
  }

  void setTabIconTintState(ValueState<Color>? value) {
    onNotifyWithCallback(() => tabIconTintState = value);
  }

  void _initTabIconProperties(TabLayout view) {
    tabIconSize = view.tabIconSize;
    tabIconSizeState = view.tabIconSizeState;
    tabIconSpace = view.tabIconSpace;
    tabIconTint = view.tabIconTint;
    tabIconTintState = view.tabIconTintState;
  }

  /// TAB TITLE PROPERTIES

  double _tabTitleSize = 12;
  ValueState<double>? tabTitleSizeState;
  FontWeight? _tabTitleWeight;
  ValueState<FontWeight>? tabTitleWeightState;

  double get tabTitleSize {
    return tabTitleSizeState?.fromController(this) ?? _tabTitleSize;
  }

  FontWeight? get tabTitleWeight {
    return tabTitleWeightState?.fromController(this) ?? _tabTitleWeight;
  }

  set tabTitleSize(double value) => _tabTitleSize = value;

  set tabTitleWeight(FontWeight? value) => _tabTitleWeight = value;

  void setTabTitleSize(double value) {
    onNotifyWithCallback(() => tabTitleSize = value);
  }

  void setTabTitleSizeState(ValueState<double>? value) {
    onNotifyWithCallback(() => tabTitleSizeState = value);
  }

  void setTabTitleWeight(FontWeight? value) {
    onNotifyWithCallback(() => tabTitleWeight = value);
  }

  void setTabTitleWeightState(ValueState<FontWeight>? value) {
    onNotifyWithCallback(() => tabTitleWeightState = value);
  }

  void _initTabTitleProperties(TabLayout view) {
    tabTitleSize = view.tabTitleSize;
    tabTitleSizeState = view.tabTitleSizeState;
    tabTitleWeight = view.tabTitleWeight;
    tabTitleWeightState = view.tabTitleWeightState;
  }

  /// TAB INDICATOR PROPERTIES
  Decoration? tabIndicator;
  Color? tabIndicatorColor;
  bool tabIndicatorFullWidth = false;
  double tabIndicatorHeight = 2;

  void setTabIndicator(Decoration? value) {
    onNotifyWithCallback(() => tabIndicator = value);
  }

  void setTabIndicatorColor(Color? value) {
    onNotifyWithCallback(() => tabIndicatorColor = value);
  }

  void setTabIndicatorFullWidth(bool value) {
    onNotifyWithCallback(() => tabIndicatorFullWidth = value);
  }

  void setTabIndicatorHeight(double value) {
    onNotifyWithCallback(() => tabIndicatorHeight = value);
  }

  void _initTabIndicatorProperties(TabLayout view) {
    tabIndicator = view.tabIndicator;
    tabIndicatorColor = view.tabIndicatorColor;
    tabIndicatorFullWidth = view.tabIndicatorFullWidth;
    tabIndicatorHeight = view.tabIndicatorHeight;
  }

  /// TAB LISTENER PROPERTIES
  OnTabChangeListener? onTabChange;
  OnTabContentVisibilityChecker? onTabIconVisibleWhenSelected;
  OnTabContentVisibilityChecker? onTabTitleVisibleWhenSelected;

  void setOnTabChangeListener(OnTabChangeListener? value) {
    onTabChange = value;
  }

  void setOnTabIconVisibleWhenSelected(OnTabContentVisibilityChecker? value) {
    onTabIconVisibleWhenSelected = value;
  }

  void setOnTabTitleVisibleWhenSelected(OnTabContentVisibilityChecker? value) {
    onTabTitleVisibleWhenSelected = value;
  }

  void _initTabListenerProperties(TabLayout view) {
    onTabChange = view.onTabChange;
    onTabIconVisibleWhenSelected = view.onTabIconVisibleWhenSelected;
    onTabTitleVisibleWhenSelected = view.onTabTitleVisibleWhenSelected;
  }

  TabLayoutController fromTabLayout(TabLayout view) {
    super.fromView(view);
    _initProperties(view);
    _initTabProperties(view);
    _initTabIconProperties(view);
    _initTabTitleProperties(view);
    _initTabIndicatorProperties(view);
    _initTabListenerProperties(view);
    return this;
  }
}
