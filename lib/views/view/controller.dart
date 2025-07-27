part of 'view.dart';

class ViewController {
  /// BASE PROPERTIES
  BuildContext? context;

  ViewRoots roots = const ViewRoots();

  ThemeData get theme => context != null ? Theme.of(context!) : ThemeData();

  void onNotifyActivator(
    dynamic data, {
    bool recheck = false,
    VoidCallback? callback,
  }) async {
    if (onActivator != null) {
      onNotifyWithCallback(() => indicatorVisible = true);
      bool value = await onActivator!(recheck, data);
      onNotifyWithCallback(() {
        activated = value;
        indicatorVisible = false;
      });
    } else {
      if (callback != null) callback();
    }
  }

  void onNotifyToggleWithActivator([bool recheck = false]) {
    onNotifyActivator(!activated, recheck: recheck, callback: onNotifyToggle);
  }

  /// CALLBACK PROPERTIES
  OnViewActivator? _onActivator;
  OnViewChangeListener? _onChange;
  OnViewErrorListener? _onError;
  OnViewHoverListener? _onHover;
  OnViewValidListener? _onValid;
  OnViewValidatorListener? _onValidator;

  OnViewActivator? get onActivator => enabled ? _onActivator : null;

  set onActivator(OnViewActivator? value) => _onActivator ??= value;

  OnViewChangeListener? get onChange => enabled ? _onChange : null;

  set onChange(OnViewChangeListener? listener) => _onChange ??= listener;

  OnViewErrorListener? get onError => enabled ? _onError : null;

  set onError(OnViewErrorListener? listener) => _onError ??= listener;

  OnViewHoverListener? get onHover => enabled ? _onHover : null;

  set onHover(OnViewHoverListener? listener) => _onHover ??= listener;

  OnViewValidListener? get onValid => enabled ? _onValid : null;

  set onValid(OnViewValidListener? listener) => _onValid ??= listener;

  OnViewValidatorListener? get onValidator => enabled ? _onValidator : null;

  set onValidator(OnViewValidatorListener? listener) =>
      _onValidator ??= listener;

  void setOnActivatorListener(OnViewActivator listener) =>
      _onActivator = listener;

  void setOnChangeListener(OnViewChangeListener listener) =>
      _onChange = listener;

  void setOnHoverListener(OnViewHoverListener listener) => _onHover = listener;

  void setOnErrorListener(OnViewErrorListener listener) => _onError = listener;

  void setOnValidListener(OnViewValidListener listener) => _onValid = listener;

  void setOnValidatorListener(OnViewValidatorListener listener) =>
      _onValidator = listener;

  void _initCallback(YMRView view) {
    onActivator = view.onActivator;
    onChange = view.onChange;
    onError = view.onError;
    onHover = view.onHover;
    onValid = view.onValid;
    onValidator = view.onValidator;
  }

  /// CLICK PROPERTIES
  ViewClickEffect? clickEffect;
  OnViewClickListener? _onClick, _onDoubleClick, _onLongClick;
  OnViewToggleListener? _onToggleClick;
  OnViewNotifyListener? _onClickHandler, _onDoubleClickHandler;
  OnViewNotifyListener? _onLongClickHandler;

  bool get isClickable {
    return onClick != null || onClickHandler != null || isToggleClickable;
  }

  bool get isDoubleClickable {
    return onDoubleClick != null || onDoubleClickHandler != null;
  }

  bool get isLongClickable => onLongClick != null || onLongClickHandler != null;

  bool get isClickMode {
    final isAnyClick = isClickable || isDoubleClickable || isLongClickable;
    return roots.clickable && (isAnyClick || isInkWellMode);
  }

  OnViewClickListener? get onClick => enabled ? _onClick : null;

  set onClick(OnViewClickListener? listener) => _onClick ??= listener;

  OnViewClickListener? get onDoubleClick => enabled ? _onDoubleClick : null;

  set onDoubleClick(OnViewClickListener? listener) =>
      _onDoubleClick ??= listener;

  OnViewClickListener? get onLongClick => enabled ? _onLongClick : null;

  set onLongClick(OnViewClickListener? listener) => _onLongClick ??= listener;

  OnViewToggleListener? get onToggleClick => enabled ? _onToggleClick : null;

  set onToggleClick(OnViewToggleListener? listener) =>
      _onToggleClick ??= listener;

  OnViewNotifyListener? get onClickHandler => enabled ? _onClickHandler : null;

  set onClickHandler(OnViewNotifyListener? listener) =>
      _onClickHandler ??= listener;

  OnViewNotifyListener? get onDoubleClickHandler =>
      enabled ? _onDoubleClickHandler : null;

  set onDoubleClickHandler(OnViewNotifyListener? listener) =>
      _onDoubleClickHandler ??= listener;

  OnViewNotifyListener? get onLongClickHandler =>
      enabled ? _onLongClickHandler : null;

  set onLongClickHandler(OnViewNotifyListener? listener) =>
      _onLongClickHandler ??= listener;

  void setClickEffect(ViewClickEffect value) {
    onNotifyWithCallback(() => clickEffect = value);
  }

  void setOnClickListener(OnViewClickListener listener) => _onClick = listener;

  void setOnDoubleClickListener(OnViewClickListener listener) =>
      _onDoubleClick = listener;

  void setOnLongClickListener(OnViewClickListener listener) =>
      _onLongClick = listener;

  void setOnToggleClickListener(OnViewToggleListener listener) =>
      _onToggleClick = listener;

  void setOnClickHandlerListener(OnViewNotifyListener listener) =>
      _onClickHandler = listener;

  void setOnDoubleClickHandlerListener(OnViewNotifyListener listener) =>
      _onDoubleClickHandler = listener;

  void setOnLongClickHandlerListener(OnViewNotifyListener listener) =>
      _onLongClickHandler = listener;

  void _initClick(YMRView view) {
    clickEffect = view.clickEffect;
    onClick = view.onClick;
    onDoubleClick = view.onDoubleClick;
    onLongClick = view.onLongClick;
    onClickHandler = view.onClickHandler;
    onDoubleClickHandler = view.onDoubleClickHandler;
    onLongClickHandler = view.onLongClickHandler;
    onToggleClick = view.onToggleClick;
  }

  /// BACKDROP PROPERTIES

  bool get isBackdropFilter => backdropFilter != null;

  ImageFilter? backdropFilter;

  BlendMode? backdropMode;

  void setBackdropFilter(ImageFilter? value) {
    onNotifyWithCallback(() => backdropFilter = value);
  }

  void setBackdropMode(BlendMode? value) {
    onNotifyWithCallback(() => backdropMode = value);
  }

  void _initBackdrop(YMRView view) {
    backdropFilter = view.backdropFilter;
    backdropMode = view.backdropMode;
  }

  /// BORDER PROPERTIES

  Color? _borderColor;

  ValueState<Color>? borderColorState;

  double? _borderSize;

  ValueState<double>? borderSizeState;

  double? _borderHorizontal;

  ValueState<double>? borderHorizontalState;

  double? _borderVertical;

  ValueState<double>? borderVerticalState;

  double? _borderTop;

  ValueState<double>? borderTopState;

  double? _borderBottom;

  ValueState<double>? borderBottomState;

  double? _borderStart;

  ValueState<double>? borderStartState;

  double? _borderEnd;

  ValueState<double>? borderEndState;

  double? _borderStrokeAlign;

  Color? get borderColor {
    return borderColorState?.fromController(this) ?? _borderColor;
  }

  double? get borderSize {
    return borderSizeState?.fromController(this) ?? _borderSize;
  }

  double? get borderHorizontal {
    var v = borderHorizontalState?.fromController(this) ?? _borderHorizontal;
    return v ?? borderSize;
  }

  double? get borderVertical {
    var v = borderVerticalState?.fromController(this) ?? _borderVertical;
    return v ?? borderSize;
  }

  double? get borderTop {
    var v = borderTopState?.fromController(this) ?? _borderTop;
    return v ?? borderVertical ?? borderSize;
  }

  double? get borderBottom {
    var v = borderBottomState?.fromController(this) ?? _borderBottom;
    return v ?? borderVertical ?? borderSize;
  }

  double? get borderStart {
    var v = borderStartState?.fromController(this) ?? _borderStart;
    return v ?? borderHorizontal ?? borderSize;
  }

  double? get borderEnd {
    var v = borderEndState?.fromController(this) ?? _borderEnd;
    return v ?? borderHorizontal ?? borderSize;
  }

  double get borderAll {
    return border.left + border.right + border.top + border.bottom;
  }

  EdgeInsets get border {
    return EdgeInsets.only(
      left: borderStart ?? 0,
      right: borderEnd ?? 0,
      top: borderTop ?? 0,
      bottom: borderBottom ?? 0,
    );
  }

  double get borderStrokeAlign {
    return _borderStrokeAlign ?? BorderSide.strokeAlignInside;
  }

  BoxBorder? get boxBorder {
    final primary = theme.primaryColor;
    return Border(
      top: BorderSide(
        color: borderColor ?? primary,
        width: border.top,
        strokeAlign: borderStrokeAlign,
      ),
      bottom: BorderSide(
        color: borderColor ?? primary,
        width: border.bottom,
        strokeAlign: borderStrokeAlign,
      ),
      left: BorderSide(
        color: borderColor ?? primary,
        width: border.left,
        strokeAlign: borderStrokeAlign,
      ),
      right: BorderSide(
        color: borderColor ?? primary,
        width: border.right,
        strokeAlign: borderStrokeAlign,
      ),
    );
  }

  bool get isBorder => roots.border && borderAll > 0;

  bool get isBorderX => roots.border && (border.left + border.right) > 0;

  bool get isBorderY => roots.border && (border.top + border.bottom) > 0;

  set borderColor(Color? value) => _borderColor = value;

  set borderSize(double? value) => _borderSize = value;

  set borderHorizontal(double? value) => _borderHorizontal = value;

  set borderVertical(double? value) => _borderVertical = value;

  set borderTop(double? value) => _borderTop = value;

  set borderBottom(double? value) => _borderBottom = value;

  set borderStart(double? value) => _borderStart = value;

  set borderEnd(double? value) => _borderEnd = value;

  set borderStrokeAlign(double? value) => _borderStrokeAlign = value;

  void setBorderColor(Color? value) {
    onNotifyWithCallback(() => _borderColor = value);
  }

  void setBorderColorState(ValueState<Color>? value) {
    onNotifyWithCallback(() => borderColorState = value);
  }

  void setBorderSize(double value) {
    onNotifyWithCallback(() => _borderSize = value);
  }

  void setBorderSizeState(ValueState<double>? value) {
    onNotifyWithCallback(() => borderSizeState = value);
  }

  void setBorderHorizontal(double? value) {
    onNotifyWithCallback(() => _borderHorizontal = value);
  }

  void setBorderHorizontalState(ValueState<double>? value) {
    onNotifyWithCallback(() => borderHorizontalState = value);
  }

  void setBorderVerticalState(ValueState<double>? value) {
    onNotifyWithCallback(() => borderVerticalState = value);
  }

  void setBorderTop(double? value) {
    onNotifyWithCallback(() => _borderTop = value);
  }

  void setBorderTopState(ValueState<double>? value) {
    onNotifyWithCallback(() => borderTopState = value);
  }

  void setBorderBottom(double? value) {
    onNotifyWithCallback(() => _borderBottom = value);
  }

  void setBorderBottomState(ValueState<double>? value) {
    onNotifyWithCallback(() => borderBottomState = value);
  }

  void setBorderStart(double? value) {
    onNotifyWithCallback(() => _borderStart = value);
  }

  void setBorderStartState(ValueState<double>? value) {
    onNotifyWithCallback(() => borderStartState = value);
  }

  void setBorderEnd(double? value) {
    onNotifyWithCallback(() => _borderEnd = value);
  }

  void setBorderEndState(ValueState<double>? value) {
    onNotifyWithCallback(() => borderEndState = value);
  }

  void setBorderStrokeAlign(double? value) {
    onNotifyWithCallback(() => borderStrokeAlign = value);
  }

  void _initBorder(YMRView view) {
    borderColor = view.borderColor;
    borderSize = view.borderSize;
    borderStart = view.borderStart;
    borderEnd = view.borderEnd;
    borderTop = view.borderTop;
    borderBottom = view.borderBottom;
    borderHorizontal = view.borderHorizontal;
    borderVertical = view.borderVertical;
    borderStrokeAlign = view.borderStrokeAlign;
    borderColorState = view.borderColorState;
    borderSizeState = view.borderSizeState;
    borderStartState = view.borderStartState;
    borderEndState = view.borderEndState;
    borderTopState = view.borderTopState;
    borderBottomState = view.borderBottomState;
    borderHorizontalState = view.borderHorizontalState;
    borderVerticalState = view.borderVerticalState;
  }

  /// BORDER RADIUS PROPERTIES

  double? _borderRadiusAll;

  ValueState<double>? borderRadiusAllState;

  double? _borderRadiusBL;

  ValueState<double>? borderRadiusBLState;

  double? _borderRadiusBR;

  ValueState<double>? borderRadiusBRState;

  double? _borderRadiusTL;

  ValueState<double>? borderRadiusTLState;

  double? _borderRadiusTR;

  ValueState<double>? borderRadiusTRState;

  double? get borderRadiusAll {
    return borderRadiusAllState?.fromController(this) ?? _borderRadiusAll;
  }

  double? get borderRadiusBL {
    var v = borderRadiusBLState?.fromController(this) ?? _borderRadiusBL;
    return v ?? borderRadiusAll;
  }

  double? get borderRadiusBR {
    var v = borderRadiusBRState?.fromController(this) ?? _borderRadiusBR;
    return v ?? borderRadiusAll;
  }

  double? get borderRadiusTL {
    var v = borderRadiusTLState?.fromController(this) ?? _borderRadiusTL;
    return v ?? borderRadiusAll;
  }

  double? get borderRadiusTR {
    var v = borderRadiusTRState?.fromController(this) ?? _borderRadiusTR;
    return v ?? borderRadiusAll;
  }

  BorderRadius get borderRadius {
    return BorderRadius.only(
      topLeft: Radius.circular(borderRadiusTL ?? 0),
      topRight: Radius.circular(borderRadiusTR ?? 0),
      bottomLeft: Radius.circular(borderRadiusBL ?? 0),
      bottomRight: Radius.circular(borderRadiusBR ?? 0),
    );
  }

  bool get isRadius {
    var a = roots.radius;
    var b = !isCircular;
    var c = isBorderRadius;
    return a && b && c;
  }

  bool get isBorderRadius => roots.radius && borderRadius != BorderRadius.zero;

  set borderRadiusAll(double? value) => _borderRadiusAll = value;

  set borderRadiusBL(double? value) => _borderRadiusBL = value;

  set borderRadiusBR(double? value) => _borderRadiusBR = value;

  set borderRadiusTL(double? value) => _borderRadiusTL = value;

  set borderRadiusTR(double? value) => _borderRadiusTR = value;

  void setBorderRadiusAll(double? value) {
    onNotifyWithCallback(() => _borderRadiusAll = value);
  }

  void setBorderRadiusAllState(ValueState<double>? value) {
    onNotifyWithCallback(() => borderRadiusAllState = value);
  }

  void setBorderRadiusBL(double? value) {
    onNotifyWithCallback(() => _borderRadiusBL = value);
  }

  void setBorderRadiusBLState(ValueState<double>? value) {
    onNotifyWithCallback(() => borderRadiusBLState = value);
  }

  void setBorderRadiusBR(double? value) {
    onNotifyWithCallback(() => _borderRadiusBR = value);
  }

  void setBorderRadiusBRState(ValueState<double>? value) {
    onNotifyWithCallback(() => borderRadiusBRState = value);
  }

  void setBorderRadiusTL(double? value) {
    onNotifyWithCallback(() => _borderRadiusTL = value);
  }

  void setBorderRadiusTLState(ValueState<double>? value) {
    onNotifyWithCallback(() => borderRadiusTLState = value);
  }

  void setBorderRadiusTR(double? value) {
    onNotifyWithCallback(() => _borderRadiusTR = value);
  }

  void setBorderRadiusTRState(ValueState<double>? value) {
    onNotifyWithCallback(() => borderRadiusTRState = value);
  }

  void _initBorderRadius(YMRView view) {
    borderRadiusAll = view.borderRadius;
    borderRadiusBL = view.borderRadiusBL;
    borderRadiusBR = view.borderRadiusBR;
    borderRadiusTL = view.borderRadiusTL;
    borderRadiusTR = view.borderRadiusTR;
    borderRadiusAllState = view.borderRadiusState;
    borderRadiusBLState = view.borderRadiusBLState;
    borderRadiusBRState = view.borderRadiusBRState;
    borderRadiusTLState = view.borderRadiusTLState;
    borderRadiusTRState = view.borderRadiusTRState;
  }

  /// INDICATOR PROPERTIES

  bool indicatorVisible = false;

  bool get isIndicatorVisible => onActivator != null && indicatorVisible;

  void setIndicatorVisible(bool value) {
    onNotifyWithCallback(() => indicatorVisible = value);
  }

  void _initIndicator(YMRView view) {
    indicatorVisible = view.indicatorVisible;
  }

  /// MARGIN PROPERTIES
  double? marginValue;

  EdgeInsets? marginCustom;

  EdgeInsets get margin {
    return marginCustom ??
        EdgeInsets.only(
          left: marginStart ?? 0,
          right: marginEnd ?? 0,
          top: marginTop ?? 0,
          bottom: marginBottom ?? 0,
        );
  }

  double get marginAll {
    return margin.left + margin.right + margin.top + margin.bottom;
  }

  double? _marginStart;

  set marginStart(double? value) => _marginStart = value;

  double? get marginStart => _marginStart ?? marginHorizontal ?? marginValue;

  double? _marginEnd;

  set marginEnd(double? value) => _marginEnd = value;

  double? get marginEnd => _marginEnd ?? marginHorizontal ?? marginValue;

  double? _marginTop;

  set marginTop(double? value) => _marginTop = value;

  double? get marginTop => _marginTop ?? marginVertical ?? marginValue;

  double? _marginBottom;

  set marginBottom(double? value) => _marginBottom = value;

  double? get marginBottom => _marginBottom ?? marginVertical ?? marginValue;

  double? marginHorizontal;

  double? marginVertical;

  bool get isMargin => roots.margin && marginAll > 0;

  bool get isMarginX => roots.margin && (margin.left + margin.right) > 0;

  bool get isMarginY => roots.margin && (margin.top + margin.bottom) > 0;

  void setMargin(double? value) {
    onNotifyWithCallback(() => marginValue = value);
  }

  void setMarginStart(double? value) {
    onNotifyWithCallback(() => marginStart = value);
  }

  void setMarginEnd(double? value) {
    onNotifyWithCallback(() => marginEnd = value);
  }

  void setMarginTop(double? value) {
    onNotifyWithCallback(() => marginTop = value);
  }

  void setMarginBottom(double? value) {
    onNotifyWithCallback(() => marginBottom = value);
  }

  void setMarginHorizontal(double? value) {
    onNotifyWithCallback(() => marginHorizontal = value);
  }

  void setMarginVertical(double? value) {
    onNotifyWithCallback(() => marginVertical = value);
  }

  void setMarginCustom(EdgeInsets? value) {
    onNotifyWithCallback(() => marginCustom = value);
  }

  void _initMargin(YMRView view) {
    marginValue = view.margin ?? 0;
    marginVertical = view.marginVertical;
    marginStart = view.marginStart;
    marginEnd = view.marginEnd;
    marginTop = view.marginTop;
    marginBottom = view.marginBottom;
    marginHorizontal = view.marginHorizontal;
    marginCustom = view.marginCustom;
  }

  /// OPACITY PROPERTIES
  double? _opacity;

  set opacity(double? value) => _opacity = value;

  ValueState<double>? opacityState;

  double get opacity => opacityState?.fromController(this) ?? _opacity ?? 0;

  bool get isOpacity => _opacity != null || opacityState != null;

  void setOpacity(double? value) {
    onNotifyWithCallback(() => opacity = value);
  }

  void setOpacityState(ValueState<double>? value) {
    onNotifyWithCallback(() => opacityState = value);
  }

  bool opacityAlwaysIncludeSemantics = false;

  void setOpacityAlwaysIncludeSemantics(bool value) {
    onNotifyWithCallback(() => opacityAlwaysIncludeSemantics = value);
  }

  void _initOpacity(YMRView view) {
    opacity = view.opacity;
    opacityState = view.opacityState;
    opacityAlwaysIncludeSemantics = view.opacityAlwaysIncludeSemantics;
  }

  /// PADDING PROPERTIES
  double? paddingValue;

  EdgeInsets? paddingCustom;

  EdgeInsets get padding {
    return paddingCustom ??
        EdgeInsets.only(
          left: paddingStart ?? 0,
          right: paddingEnd ?? 0,
          top: paddingTop ?? 0,
          bottom: paddingBottom ?? 0,
        );
  }

  double get paddingAll {
    return padding.left + padding.right + padding.top + padding.bottom;
  }

  double? _paddingStart;

  set paddingStart(double? value) => _paddingStart = value;

  double? get paddingStart =>
      _paddingStart ?? paddingHorizontal ?? paddingValue;

  double? _paddingEnd;

  set paddingEnd(double? value) => _paddingEnd = value;

  double? get paddingEnd => _paddingEnd ?? paddingHorizontal ?? paddingValue;

  double? _paddingTop;

  set paddingTop(double? value) => _paddingTop = value;

  double? get paddingTop => _paddingTop ?? paddingVertical ?? paddingValue;

  double? _paddingBottom;

  set paddingBottom(double? value) => _paddingBottom = value;

  double? get paddingBottom =>
      _paddingBottom ?? paddingVertical ?? paddingValue;

  double? paddingHorizontal;

  double? paddingVertical;

  bool get isPadding => roots.padding && paddingAll > 0;

  bool get isPaddingX {
    return roots.padding && ((paddingStart ?? 0) + (paddingEnd ?? 0)) > 0;
  }

  bool get isPaddingY {
    return roots.padding && ((paddingTop ?? 0) + (paddingBottom ?? 0)) > 0;
  }

  void setPadding(double value) {
    onNotifyWithCallback(() => paddingValue = value);
  }

  void setPaddingStart(double? value) {
    onNotifyWithCallback(() => paddingStart = value);
  }

  void setPaddingEnd(double? value) {
    onNotifyWithCallback(() => paddingEnd = value);
  }

  void setPaddingTop(double? value) {
    onNotifyWithCallback(() => paddingTop = value);
  }

  void setPaddingBottom(double? value) {
    onNotifyWithCallback(() => paddingBottom = value);
  }

  void setPaddingHorizontal(double? value) {
    onNotifyWithCallback(() => paddingHorizontal = value);
  }

  void setPaddingVertical(double? value) {
    onNotifyWithCallback(() => paddingVertical = value);
  }

  void setPaddingCustom(EdgeInsets? value) {
    onNotifyWithCallback(() => paddingCustom = value);
  }

  void _initPadding(YMRView view) {
    paddingValue = view.padding ?? 0;
    paddingStart = view.paddingStart;
    paddingEnd = view.paddingEnd;
    paddingTop = view.paddingTop;
    paddingBottom = view.paddingBottom;
    paddingHorizontal = view.paddingHorizontal;
    paddingVertical = view.paddingVertical;
    paddingCustom = view.paddingCustom;
  }

  @mustCallSuper
  ViewController fromView(YMRView view) {
    /// ROOT PROPERTIES
    _initCallback(view);
    _initClick(view);

    /// OTHER PROPERTIES
    _initBackdrop(view);
    _initBorder(view);
    _initBorderRadius(view);
    _initIndicator(view);
    _initMargin(view);
    _initOpacity(view);
    _initPadding(view);

    ///
    ///
    ///
    ///
    ///
    hoverColor = view.hoverColor;
    pressedColor = view.pressedColor;
    rippleColor = view.rippleColor;

    /// VIEW CONDITIONAL PROPERTIES
    absorbMode = view.absorbMode ?? false;
    activated = view.activated ?? false;
    enabled = view.enabled ?? true;
    expandable = view.expandable ?? false;
    scrollable = view.scrollable ?? false;
    visible = view.visibility ?? true;
    wrapper = view.wrapper ?? false;

    /// ANIMATION PROPERTIES
    animation = view.animation ?? 0;
    animationType = view.animationType ?? Curves.linear;

    /// VIEW SIZE PROPERTIES
    flex = view.flex ?? 0;
    _dimensionRatio = view.dimensionRatio;
    elevation = view.elevation ?? 0;
    _width = view.width;
    widthState = view.widthState;
    _widthMax = view.widthMax;
    _widthMin = view.widthMin;
    _height = view.height;
    heightState = view.heightState;
    _heightMax = view.heightMax;
    _heightMin = view.heightMin;

    /// VIEW SHADOW PROPERTIES
    shadowColor = view.shadowColor;
    shadow = view.shadow ?? 0;
    _shadowStart = view.shadowStart;
    _shadowEnd = view.shadowEnd;
    _shadowTop = view.shadowTop;
    _shadowBottom = view.shadowBottom;
    shadowHorizontal = view.shadowHorizontal;
    shadowVertical = view.shadowVertical;
    shadowBlurRadius = view.shadowBlurRadius ?? 5;
    shadowBlurStyle = view.shadowBlurStyle ?? BlurStyle.normal;
    shadowSpreadRadius = view.shadowSpreadRadius ?? 0;
    shadowType = view.shadowType ?? ViewShadowType.none;

    /// VIEW DECORATION PROPERTIES
    _background = view.background;
    foreground = view.foreground;
    backgroundBlendMode = view.backgroundBlendMode;
    foregroundBlendMode = view.foregroundBlendMode;
    _backgroundGradient = view.backgroundGradient;
    foregroundGradient = view.foregroundGradient;
    _backgroundImage = view.backgroundImage;
    foregroundImage = view.foregroundImage;
    clipBehavior = view.clipBehavior ?? Clip.antiAlias;
    gravity = view.gravity;
    orientation = view.orientation ?? Axis.vertical;
    _position = view.position;
    positionType = view.positionType ?? ViewPositionType.center;
    scrollController = view.scrollController;
    scrollingType = view.scrollingType ?? ViewScrollingType.none;
    shape = view.shape ?? ViewShape.rectangular;
    transform = view.transform;
    transformGravity = view.transformGravity;
    transform = view.transform;
    child = view.child;

    /// Properties
    roots = view.initRootProperties();

    /// Value States
    backgroundState = view.backgroundState;
    backgroundImageState = view.backgroundImageState;
    backgroundGradientState = view.backgroundGradientState;

    return this;
  }

  bool expandable = false;
  bool scrollable = false;
  bool wrapper = false;

  double elevation = 0;

  Color? _background;
  Color hoverColor = Colors.transparent;
  Color pressedColor = Colors.transparent;
  Color rippleColor = Colors.transparent;

  bool get isHovered => onHover != null || hoverColor != Colors.transparent;

  bool get isWrapper => roots.wrapper && wrapper;

  bool get isPressed => pressedColor != Colors.transparent;

  bool get isRippled => rippleColor != Colors.transparent;

  bool get isInkWellMode => !isBorder && (isHovered || isPressed || isRippled);

  BlendMode? backgroundBlendMode;
  Gradient? _backgroundGradient;
  DecorationImage? _backgroundImage;

  ValueState<Color>? backgroundState;
  ValueState<Gradient>? backgroundGradientState;
  ValueState<DecorationImage>? backgroundImageState;

  set background(Color? value) => _background = value;

  set backgroundGradient(Gradient? value) => _backgroundGradient = value;

  set backgroundImage(DecorationImage? value) => _backgroundImage = value;

  Color? get background {
    return backgroundState?.fromController(this) ?? _background;
  }

  Gradient? get backgroundGradient {
    return backgroundGradientState?.fromController(this) ?? _backgroundGradient;
  }

  DecorationImage? get backgroundImage {
    return backgroundImageState?.fromController(this) ?? _backgroundImage;
  }

  bool absorbMode = false;

  bool activated = false;

  Alignment? gravity;

  int animation = 0;

  bool get animationEnabled => animation > 0;

  Curve animationType = Curves.linear;

  Clip clipBehavior = Clip.antiAlias;

  double? _dimensionRatio;

  double get dimensionRatio => _dimensionRatio ?? 0;

  Color? foreground;

  Gradient? foregroundGradient;

  BlendMode? foregroundBlendMode;

  DecorationImage? foregroundImage;

  /// CHILD PROPERTIES
  Widget? child;

  bool enabled = true;

  bool error = false;

  bool focused = false;

  bool valid = false;

  int flex = 0;

  bool hover = false;

  /// width properties
  double? _width;

  ValueState<double>? widthState;

  set width(double? value) => _width = value;

  double? get width => isSquire || isCircular
      ? maxSize
      : widthState?.fromController(this) ?? _width;

  double? _widthMax;

  double get widthMax => _widthMax ?? double.infinity;

  double? _widthMin;

  double get widthMin => _widthMin ?? 0.0;

  /// height properties
  double? _height;

  ValueState<double>? heightState;

  set height(double? value) => _height = value;

  double? get height => isSquire || isCircular
      ? maxSize
      : heightState?.fromController(this) ?? _height;

  double? _heightMax;

  double get heightMax => _heightMax ?? double.infinity;

  double? _heightMin;

  double get heightMin => _heightMin ?? 0.0;

  /// positional properties

  ViewPosition? _position;

  ViewPosition get position => _position ?? positionType.position;

  ViewPositionType positionType = ViewPositionType.center;

  /// scroll properties
  Axis orientation = Axis.vertical;

  ScrollController? scrollController;

  void setScrollController(ScrollController? value) {
    if (scrollController != null) scrollController?.dispose();
    onNotifyWithCallback(() => scrollController = value);
  }

  ViewScrollingType scrollingType = ViewScrollingType.none;

  /// Shadow properties
  double shadow = 0;

  List<BoxShadow>? get shadows {
    return isShadow
        ? [
            BoxShadow(
              color: shadowColor ?? Colors.black12,
              blurRadius: shadowBlurRadius,
              offset: isOverlayShadow
                  ? Offset.zero
                  : Offset(-shadowStart, -shadowTop),
              blurStyle: shadowBlurStyle,
              spreadRadius: shadowSpreadRadius,
            ),
            if (!isOverlayShadow)
              BoxShadow(
                color: shadowColor ?? Colors.black12,
                blurRadius: shadowBlurRadius,
                offset: Offset(shadowEnd, shadowBottom),
                blurStyle: shadowBlurStyle,
                spreadRadius: shadowSpreadRadius,
              ),
          ]
        : null;
  }

  bool get isShadow {
    final x = shadowStart + shadowEnd + shadowTop + shadowBottom;
    return roots.shadow && (x > 0 || shadowType == ViewShadowType.overlay);
  }

  Color? shadowColor;

  double shadowBlurRadius = 5;

  BlurStyle shadowBlurStyle = BlurStyle.normal;

  double shadowSpreadRadius = 0;

  ViewShadowType shadowType = ViewShadowType.none;

  double? shadowHorizontal;

  double? shadowVertical;

  double? _shadowStart;

  double get shadowStart => _shadowStart ?? shadowHorizontal ?? shadow;

  double? _shadowEnd;

  double get shadowEnd => _shadowEnd ?? shadowHorizontal ?? shadow;

  double? _shadowTop;

  double get shadowTop => _shadowTop ?? shadowVertical ?? shadow;

  double? _shadowBottom;

  double get shadowBottom => _shadowBottom ?? shadowVertical ?? shadow;

  ViewShape shape = ViewShape.rectangular;

  Matrix4? transform;

  Alignment? transformGravity;

  /// default properties
  bool visible = true;

  /// custom properties
  bool get isCircular => roots.shape && shape == ViewShape.circular;

  bool get isConstraints =>
      roots.constraints &&
      (_widthMax != null ||
          _widthMin != null ||
          _heightMax != null ||
          _heightMin != null);

  bool get isDimensional => roots.ratio && dimensionRatio > 0;

  bool get isExpendable {
    return roots.flex && flex > 0;
  }

  bool get isHeight => height != null;

  bool get isOverlayShadow =>
      roots.shadow && shadowType == ViewShadowType.overlay;

  bool get isPositional {
    return roots.position &&
        (_position != null || positionType != ViewPositionType.center);
  }

  bool get isScrollable => roots.scrollable && scrollable;

  bool get isSquire {
    return shape == ViewShape.squire;
  }

  bool get isToggleClickable {
    return onToggleClick != null || onActivator != null || expandable;
  }

  double get maxSize {
    return max(_width ?? 0, _height ?? 0);
  }

  double get minSize {
    return min(_width ?? 0, _height ?? 0);
  }

  /// Boolean properties
  void setAbsorbMode(bool value) {
    absorbMode = value;
    _notify;
  }

  void setActivated(bool value) {
    activated = value;
    _notify;
  }

  void setEnabled(bool value) {
    enabled = value;
    _notify;
  }

  void setError(bool value) {
    error = value;
    _notify;
  }

  void setHover(bool value) {
    hover = value;
    _notify;
  }

  void setVisibility(bool value) {
    visible = value;
    _notify;
  }

  /// Animation properties
  void setAnimation(int value) {
    animation = value;
    _notify;
  }

  void setAnimationType(Curve value) {
    animationType = value;
    _notify;
  }

  /// Base properties
  void setAlignment(Alignment? value) {
    gravity = value;
    _notify;
  }

  void setBackground(Color? value) {
    _background = value;
    _notify;
  }

  void setBackgroundState(ValueState<Color>? value) {
    backgroundState = value;
    _notify;
  }

  void setBackgroundGradient(Gradient? value) {
    _backgroundGradient = value;
    _notify;
  }

  void setBackgroundGradientState(ValueState<Gradient>? value) {
    backgroundGradientState = value;
    _notify;
  }

  void setBackgroundBlendMode(BlendMode? value) {
    backgroundBlendMode = value;
    _notify;
  }

  void setBackgroundImage(DecorationImage? value) {
    _backgroundImage = value;
    _notify;
  }

  void setBackgroundImageState(ValueState<DecorationImage>? value) {
    backgroundImageState = value;
    _notify;
  }

  void setClipBehavior(Clip value) {
    clipBehavior = value;
    _notify;
  }

  void setDimensionRatio(double? value) {
    _dimensionRatio = value;
    _notify;
  }

  void setElevation(double value) {
    elevation = value;
    _notify;
  }

  void setForeground(Color? value) {
    foreground = value;
    _notify;
  }

  void setForegroundGradient(Gradient? value) {
    foregroundGradient = value;
    _notify;
  }

  void setForegroundBlendMode(BlendMode? value) {
    foregroundBlendMode = value;
    _notify;
  }

  void setForegroundImage(DecorationImage? value) {
    foregroundImage = value;
    _notify;
  }

  void setChild(Widget? value) {
    child = value;
    _notify;
  }

  void setFlex(int value) {
    flex = value;
    _notify;
  }

  void setWidth(double? value) {
    _width = value;
    _notify;
  }

  void setMaxWidth(double? value) {
    _widthMax = value;
    _notify;
  }

  void setMinWidth(double? value) {
    _widthMin = value;
    _notify;
  }

  void setHeight(double? value) {
    _height = value;
    _notify;
  }

  void setViewSize({
    double? width,
    double? height,
  }) {
    _width = width ?? _width;
    _height = height ?? _height;
    _notify;
  }

  void setMaxHeight(double? value) {
    _heightMax = value;
    _notify;
  }

  void setMinHeight(double? value) {
    _heightMin = value;
    _notify;
  }

  void setPosition(ViewPosition? value) {
    _position = value;
    _notify;
  }

  void setPositionType(ViewPositionType value) {
    positionType = value;
    _notify;
  }

  void setTransform(Matrix4 value) {
    transform = value;
    _notify;
  }

  void setTransformAlignment(Alignment value) {
    transformGravity = value;
    _notify;
  }

  void setShadow(double value) {
    shadow = value;
    _notify;
  }

  void setShadowColor(Color value) {
    shadowColor = value;
    _notify;
  }

  void setShadowBlurRadius(double value) {
    shadowBlurRadius = value;
    _notify;
  }

  void setShadowBlurStyle(BlurStyle value) {
    shadowBlurStyle = value;
    _notify;
  }

  void setShadowSpreadRadius(double value) {
    shadowSpreadRadius = value;
    _notify;
  }

  void setShadowType(ViewShadowType value) {
    shadowType = value;
    _notify;
  }

  void setShadowHorizontal(double? value) {
    shadowHorizontal = value;
    _notify;
  }

  void setShadowVertical(double? value) {
    shadowVertical = value;
    _notify;
  }

  void setShadowStart(double? value) {
    _shadowStart = value;
    _notify;
  }

  void setShadowEnd(double? value) {
    _shadowEnd = value;
    _notify;
  }

  void setShadowTop(double? value) {
    _shadowTop = value;
    _notify;
  }

  void setShadowBottom(double? value) {
    _shadowBottom = value;
    _notify;
  }

  void setViewShape(ViewShape value) {
    shape = value;
    _notify;
  }

  /// notifier properties

  bool isMountable = false;

  OnViewNotifier? _notifier;

  void get _notify {
    if (_notifier != null && isMountable) {
      _notifier?.call(() {});
    }
  }

  void setNotifier(OnViewNotifier? notifier) => _notifier = notifier;

  void onNotify() => _notify;

  void onNotifyWithCallback(VoidCallback callback) {
    if (_notifier != null && isMountable) {
      _notifier?.call(callback);
    }
  }

  void onNotifyHover(bool status) {
    hover = status;
    onHover?.call(hover);
    _notify;
  }

  void onNotifyWrapper(Size size) {
    width = size.width;
    height = size.height;
    _notify;
  }

  void onNotifyToggle() {
    activated = !activated;
    onToggleClick?.call(activated);
    _notify;
  }

  void _dispose() => scrollController?.dispose();
}
