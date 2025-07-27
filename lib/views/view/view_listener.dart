part of 'view.dart';

class ViewListener extends StatelessWidget {
  final ViewController controller;
  final Widget child;

  const ViewListener({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = this.child;
    if (controller.isInkWellMode) {
      child = Padding(
        padding: controller.isMargin ? controller.margin : EdgeInsets.zero,
        child: Material(
          elevation: controller.elevation,
          borderRadius: controller.isCircular
              ? BorderRadius.circular(controller.maxSize)
              : controller.borderRadius,
          color: controller.background,
          clipBehavior: controller.clipBehavior,
          child: _Listener(
            controller: controller,
            onClick: _onClick,
            onDoubleClick: _onDoubleClick,
            onLongClick: _onLongClick,
            child: child,
          ),
        ),
      );
    } else {
      child = _Listener(
        controller: controller,
        onClick: _onClick,
        onDoubleClick: _onDoubleClick,
        onLongClick: _onLongClick,
        child: child,
      );
    }
    if (kIsWeb) {
      return RepaintBoundary(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: child,
        ),
      );
    } else {
      return child;
    }
  }

  void _onClick(BuildContext context) {
    if (controller.isToggleClickable) {
      controller.onNotifyToggleWithActivator();
    } else {
      controller.onClickHandler != null
          ? controller.onClickHandler?.call(controller)
          : controller.onClick?.call(context);
    }
  }

  void _onDoubleClick(BuildContext context) {
    controller.onDoubleClickHandler != null
        ? controller.onDoubleClickHandler?.call(controller)
        : controller.onDoubleClick?.call(context);
  }

  void _onLongClick(BuildContext context) {
    controller.onLongClickHandler != null
        ? controller.onLongClickHandler?.call(controller)
        : controller.onLongClick?.call(context);
  }
}

class _Listener extends StatefulWidget {
  final ViewController controller;
  final Widget child;
  final OnViewClickListener onClick;
  final OnViewClickListener onDoubleClick;
  final OnViewClickListener onLongClick;

  const _Listener({
    required this.controller,
    required this.child,
    required this.onClick,
    required this.onDoubleClick,
    required this.onLongClick,
  });

  @override
  State<_Listener> createState() => _ListenerState();
}

class _ListenerState extends State<_Listener>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  ViewClickEffect get _effect {
    return widget.controller.clickEffect ?? const ViewClickEffect.none();
  }

  @override
  void initState() {
    if (!_effect.effect.isNone) {
      _controller = AnimationController(
        vsync: this,
        animationBehavior: _effect.behavior,
        duration: _effect.duration,
        reverseDuration: _effect.reverseDuration,
        value: _effect.value,
        upperBound: _effect.upperBound,
        lowerBound: _effect.lowerBound,
      );
      _animation = CurvedAnimation(
        parent: _controller!,
        curve: _effect.curve,
        reverseCurve: _effect.reverseCurve ?? _effect.curve,
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    if (_controller != null) _controller!.dispose();
    super.dispose();
  }

  void _onClick() async {
    widget.onClick(context);
    if (_controller != null) {
      _controller!.reverse().whenComplete(_controller!.forward);
    }
  }

  void _onDClick() {
    widget.onDoubleClick(context);
    if (_controller != null) {
      _controller!.reverse().whenComplete(_controller!.forward);
    }
  }

  void _onLClick() {
    widget.onLongClick(context);
    if (_controller != null) {
      _controller!.reverse().whenComplete(_controller!.forward);
    }
  }

  void _onHover(bool value) async {
    widget.controller.onNotifyHover(value);
    if (_controller != null) {
      if (value) {
        _controller!.reverse();
      } else {
        _controller!.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.isInkWellMode) {
      return InkWell(
        splashColor: widget.controller.rippleColor,
        hoverColor: widget.controller.hoverColor,
        highlightColor: widget.controller.pressedColor,
        onTap: widget.controller.isClickable ? _onClick : null,
        onDoubleTap: widget.controller.isDoubleClickable ? _onDClick : null,
        onLongPress: widget.controller.isLongClickable ? _onLClick : null,
        onHover: widget.controller.isHovered ? _onHover : null,
        child: _Effect(
          effect: _effect,
          value: _animation,
          child: widget.child,
        ),
      );
    } else {
      return GestureDetector(
        onTap: widget.controller.isClickable ? _onClick : null,
        onDoubleTap: widget.controller.isDoubleClickable ? _onDClick : null,
        onLongPress: widget.controller.isLongClickable ? _onLClick : null,
        child: _Effect(
          effect: _effect,
          value: _animation,
          child: widget.child,
        ),
      );
    }
  }
}

class _Effect extends StatelessWidget {
  final ViewClickEffect effect;
  final Animation<double>? value;
  final Widget child;

  const _Effect({
    required this.effect,
    required this.value,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = this.child;
    if (value != null) {
      if (effect.effect.isBounce) {
        child = ScaleTransition(scale: value!, child: child);
      } else if (effect.effect.isCustom) {
        child = AnimatedBuilder(
          animation: value!,
          builder: (context, child) => effect.builder!(
            context,
            value!.value,
            child!,
          ),
          child: child,
        );
      }
    }
    return child;
  }
}
