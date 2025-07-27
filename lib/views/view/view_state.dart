part of 'view.dart';

class _ViewState<T extends ViewController> extends State<YMRView<T>> {
  late T controller;

  @override
  void initState() {
    super.initState();
    if (mounted){
      controller = widget.controller ?? widget.initController();
      controller.setNotifier(setState);
      controller.isMountable = mounted;
      controller = widget.attachController(controller);
      widget.onInit(context, controller);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onReady(context, controller);
      });
    }
  }

  @override
  void didUpdateWidget(covariant YMRView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller = widget.controller ?? widget.initController();
    controller.setNotifier(setState);
    controller.isMountable = mounted;
    controller = widget.attachController(controller);
    widget.onUpdateWidget(context, controller, oldWidget);
  }

  @override
  void didChangeDependencies() {
    widget.onChangeDependencies(context, controller);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    widget.onDispose(context, controller);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.context = context;

    /// INITIAL
    Widget child = const SizedBox();

    /// VISIBILITY
    if (controller.visible) {
      /// ATTACH
      child = widget.attach(context, controller) ?? child;

      /// SCROLLER
      if (controller.isScrollable) {
        child = SingleChildScrollView(
          controller: controller.scrollController,
          physics: controller.scrollingType.physics,
          scrollDirection: controller.orientation,
          padding: controller.padding,
          child: child,
        );
      }

      /// BACKDROP FILTER
      if (controller.isBackdropFilter) {
        child = BackdropFilter(
          filter: controller.backdropFilter ?? ImageFilter.blur(),
          blendMode: controller.backdropMode ?? BlendMode.srcOver,
          child: child,
        );
      }

      /// STYLES
      if (controller.roots.view) {
        final root = controller.roots;
        final isCircular = controller.isCircular;
        final isRadius = controller.isBorderRadius;
        final isRippleMode = controller.isInkWellMode;
        final isMargin = controller.isMargin;
        final isConstraints = controller.isConstraints;

        final borderRadius = !isRippleMode && isRadius && !isCircular
            ? controller.borderRadius
            : null;

        if (controller.animationEnabled) {
          child = AnimatedContainer(
            duration: Duration(milliseconds: controller.animation),
            curve: controller.animationType,
            alignment: controller.gravity,
            clipBehavior: root.decoration && !isRippleMode
                ? controller.clipBehavior
                : Clip.none,
            width: controller.width,
            height: controller.height,
            transform: controller.transform,
            transformAlignment: controller.transformGravity,
            constraints: isConstraints
                ? BoxConstraints(
                    maxWidth: controller.widthMax,
                    minWidth: controller.widthMin,
                    maxHeight: controller.heightMax,
                    minHeight: controller.heightMin,
                  )
                : null,
            decoration: root.decoration
                ? BoxDecoration(
                    backgroundBlendMode: controller.backgroundBlendMode,
                    border: controller.isBorder ? controller.boxBorder : null,
                    borderRadius: isCircular ? null : borderRadius,
                    color: root.background && !isRippleMode
                        ? controller.background
                        : null,
                    gradient: controller.backgroundGradient,
                    image: controller.backgroundImage,
                    boxShadow: controller.shadows,
                    shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
                  )
                : null,
            foregroundDecoration: root.decoration
                ? BoxDecoration(
                    backgroundBlendMode: controller.foregroundBlendMode,
                    borderRadius: borderRadius,
                    color: controller.foreground,
                    gradient: controller.foregroundGradient,
                    image: controller.foregroundImage,
                    shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
                  )
                : null,
            margin: isMargin && !isRippleMode ? controller.margin : null,
            padding: controller.isPadding && !controller.isScrollable
                ? controller.padding
                : null,
            child: child,
          );
        } else {
          child = Container(
            alignment: controller.gravity,
            clipBehavior: root.decoration && !isRippleMode
                ? controller.clipBehavior
                : Clip.none,
            width: controller.width,
            height: controller.height,
            transform: controller.transform,
            transformAlignment: controller.transformGravity,
            constraints: isConstraints
                ? BoxConstraints(
                    maxWidth: controller.widthMax,
                    minWidth: controller.widthMin,
                    maxHeight: controller.heightMax,
                    minHeight: controller.heightMin,
                  )
                : null,
            decoration: root.decoration
                ? BoxDecoration(
                    backgroundBlendMode: controller.backgroundBlendMode,
                    border: controller.isBorder ? controller.boxBorder : null,
                    borderRadius: isCircular ? null : borderRadius,
                    color: root.background && !isRippleMode
                        ? controller.background
                        : null,
                    gradient: controller.backgroundGradient,
                    image: controller.backgroundImage,
                    boxShadow: controller.shadows,
                    shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
                  )
                : null,
            foregroundDecoration: root.decoration
                ? BoxDecoration(
                    backgroundBlendMode: controller.foregroundBlendMode,
                    borderRadius: borderRadius,
                    color: controller.foreground,
                    gradient: controller.foregroundGradient,
                    image: controller.foregroundImage,
                    shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
                  )
                : null,
            margin: isMargin && !isRippleMode ? controller.margin : null,
            padding: controller.isPadding && !controller.isScrollable
                ? controller.padding
                : null,
            child: child,
          );
        }
      }

      /// BUILDER
      child = widget.build(context, controller, child);

      /// OPACITY
      if (controller.isOpacity) {
        child = Opacity(
          opacity: controller.opacity,
          alwaysIncludeSemantics: controller.opacityAlwaysIncludeSemantics,
          child: child,
        );
      }

      /// WRAPPER
      if (controller.isWrapper) {
        child = WidgetWrapper(
          wrapper: controller.onNotifyWrapper,
          child: child,
        );
      }

      /// ABSORBER
      if (controller.absorbMode) {
        child = AbsorbPointer(child: child);
      }

      /// CALLBACKS
      if (controller.isClickMode) {
        child = ViewListener(
          controller: controller,
          child: child,
        );
      }

      /// DIMENSION
      if (controller.isDimensional) {
        child = AspectRatio(
          aspectRatio: controller.dimensionRatio,
          child: child,
        );
      }

      /// EXPENDABLE
      if (controller.isExpendable) {
        child = Expanded(
          flex: controller.flex,
          child: child,
        );
      }

      /// POSITION
      if (controller.isPositional) {
        child = Positioned(
          top: controller.position.top,
          bottom: controller.position.bottom,
          left: controller.position.left,
          right: controller.position.right,
          child: child,
        );
      }

      /// ROOT (FINAL)
      child = widget.root(context, controller, child);
    }

    /// BUILD
    return child;
  }
}
