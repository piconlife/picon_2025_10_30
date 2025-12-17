import 'package:flutter/material.dart';

typedef PopupArrowBuilder = Widget Function(BuildContext context);

/// Main widget that wraps any child widget and shows a bubble popup when clicked
class Popup extends StatefulWidget {
  /// The widget that will be the anchor (clickable element)
  final Widget child;

  /// The content to show in the bubble popup
  final Widget? content;
  final Widget Function(BuildContext context, VoidCallback callback)?
  contentBuilder;

  /// Preferred position of the bubble relative to the anchor
  final PopupPosition position;

  /// Background color of the bubble
  final Color backgroundColor;

  /// Size of the arrow pointing to the anchor
  final double arrowSize;

  /// Border radius of the bubble
  final BorderRadius? borderRadius;

  /// Maximum width of the bubble content
  final double? maxWidth;

  /// Whether to show the bubble on tap (true) or show it always (false)
  final bool showOnTap;
  final bool showOnDoubleTap;
  final bool showOnLongPressed;

  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;

  /// Callback when bubble is shown
  final VoidCallback? onShow;

  /// Callback when bubble is hidden
  final VoidCallback? onHide;

  final PopupArrowBuilder? arrowBuilder;

  const Popup({
    super.key,
    required this.child,
    this.content,
    this.contentBuilder,
    this.position = PopupPosition.detect,
    this.backgroundColor = const Color(0xFF2C3E50),
    this.arrowSize = 8.0,
    this.borderRadius,
    this.maxWidth = 250.0,
    this.showOnTap = true,
    this.showOnDoubleTap = false,
    this.showOnLongPressed = false,
    this.arrowBuilder,
    this.onTap,
    this.onDoubleTap,
    this.onShow,
    this.onHide,
  }) : assert(content != null || contentBuilder != null);

  @override
  State<Popup> createState() => _PopupState();
}

class _PopupState extends State<Popup> {
  final GlobalKey _anchorKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isShowing = false;
  Offset? _tapPosition;

  void _toggle([Offset? tapPosition]) {
    if (_isShowing) {
      _hide();
    } else {
      _show(tapPosition);
    }
  }

  void _show([Offset? tapPosition]) {
    if (_isShowing) return;

    final RenderBox? renderBox =
        _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    // Store tap position for use in overlay
    _tapPosition = tapPosition;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return _Overlay(
          anchorOffset: offset,
          anchorSize: size,
          position: widget.position,
          tapPosition: _tapPosition,
          backgroundColor: widget.backgroundColor,
          arrowSize: widget.arrowSize,
          borderRadius: widget.borderRadius,
          maxWidth: widget.maxWidth,
          arrowBuilder: widget.arrowBuilder,
          onClose: _hide,
          child: widget.contentBuilder?.call(context, _hide) ?? widget.content!,
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isShowing = true;
    });
    widget.onShow?.call();
  }

  void _hide() {
    try {
      _overlayEntry?.remove();
      _overlayEntry = null;
      setState(() {
        _isShowing = false;
      });
      widget.onHide?.call();
    } catch (_) {}
  }

  void _tap(Offset localPosition) {
    final RenderBox? renderBox =
        _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final globalPosition = renderBox.localToGlobal(localPosition);
      _toggle(globalPosition);
    }
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _anchorKey,
      onTap: widget.onTap,
      onDoubleTap: widget.onDoubleTap,
      onTapDown: widget.showOnTap ? (d) => _tap(d.localPosition) : null,
      onDoubleTapDown:
          widget.showOnDoubleTap ? (d) => _tap(d.localPosition) : null,
      onLongPressStart:
          widget.showOnLongPressed ? (d) => _tap(d.localPosition) : null,
      child: ColoredBox(color: Colors.transparent, child: widget.child),
    );
  }
}

/// The actual bubble popup widget with positioning logic (internal use)
class _Overlay extends StatefulWidget {
  final PopupArrowBuilder? arrowBuilder;
  final Offset anchorOffset;
  final Size anchorSize;
  final PopupPosition position;
  final Widget child;
  final VoidCallback onClose;
  final Color backgroundColor;
  final double arrowSize;
  final BorderRadius? borderRadius;
  final double? maxWidth;
  final Offset? tapPosition;

  const _Overlay({
    required this.arrowBuilder,
    required this.anchorOffset,
    required this.anchorSize,
    required this.position,
    required this.child,
    required this.onClose,
    required this.backgroundColor,
    required this.arrowSize,
    this.borderRadius,
    this.maxWidth,
    this.tapPosition,
  });

  @override
  State<_Overlay> createState() => _OverlayState();
}

class _OverlayState extends State<_Overlay>
    with SingleTickerProviderStateMixin {
  final GlobalKey _popupKey = GlobalKey();
  Size _size = Size.zero;
  PopupPosition _actualPosition = PopupPosition.bottom;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _actualPosition = widget.position;

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    // Start animation
    _animationController.forward();

    // Measure bubble size after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureAndAdjustPosition();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _measureAndAdjustPosition() {
    final RenderBox? renderBox =
        _popupKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _size = renderBox.size;
        if (widget.position == PopupPosition.detect) {
          _actualPosition = _determineBestPosition();
        }
      });
    }
  }

  PopupPosition _determineBestPosition() {
    final screenSize = MediaQuery.of(context).size;
    const padding = 16.0;
    final bubbleWidth = _size.width + widget.arrowSize + padding * 2;
    final bubbleHeight = _size.height + widget.arrowSize + padding * 2;

    // If we have tap position, use it to determine the best position
    if (widget.tapPosition != null) {
      return _autoDetectPositionFromTap(screenSize, bubbleWidth, bubbleHeight);
    }

    // Otherwise, check if preferred position fits
    switch (widget.position) {
      case PopupPosition.top:
      case PopupPosition.topLeft:
      case PopupPosition.topRight:
        // Check if there's enough space above
        if (widget.anchorOffset.dy - bubbleHeight >= padding) {
          return widget.position;
        }
        // Try bottom instead
        if (widget.anchorOffset.dy + widget.anchorSize.height + bubbleHeight <=
            screenSize.height - padding) {
          return _convertToBottom(widget.position);
        }
        break;

      case PopupPosition.bottom:
      case PopupPosition.bottomLeft:
      case PopupPosition.bottomRight:
        // Check if there's enough space below
        if (widget.anchorOffset.dy + widget.anchorSize.height + bubbleHeight <=
            screenSize.height - padding) {
          return widget.position;
        }
        // Try top instead
        if (widget.anchorOffset.dy - bubbleHeight >= padding) {
          return _convertToTop(widget.position);
        }
        break;

      case PopupPosition.left:
        // Check if there's enough space on the left
        if (widget.anchorOffset.dx - bubbleWidth >= padding) {
          return widget.position;
        }
        // Try right instead
        if (widget.anchorOffset.dx + widget.anchorSize.width + bubbleWidth <=
            screenSize.width - padding) {
          return PopupPosition.right;
        }
        break;

      case PopupPosition.right:
        // Check if there's enough space on the right
        if (widget.anchorOffset.dx + widget.anchorSize.width + bubbleWidth <=
            screenSize.width - padding) {
          return widget.position;
        }
        // Try left instead
        if (widget.anchorOffset.dx - bubbleWidth >= padding) {
          return PopupPosition.left;
        }
        break;
      default:
    }

    // If nothing fits perfectly, find the best option
    return _findBestFallbackPosition(screenSize, bubbleWidth, bubbleHeight);
  }

  PopupPosition _autoDetectPositionFromTap(
    Size screenSize,
    double pw,
    double ph,
  ) {
    const padding = 16.0;
    final tapPos = widget.tapPosition!;

    // Calculate tap position relative to anchor
    final tapRelativeX = tapPos.dx - widget.anchorOffset.dx;
    final tapRelativeY = tapPos.dy - widget.anchorOffset.dy;

    // Determine which side of the anchor was tapped
    final isLeftSide = tapRelativeX < widget.anchorSize.width / 2;
    final isTopSide = tapRelativeY < widget.anchorSize.height / 2;

    // Calculate available space in each direction from tap point
    final spaceTop = tapPos.dy - padding;
    final spaceBottom = screenSize.height - tapPos.dy - padding;
    final spaceLeft = tapPos.dx - padding;
    final spaceRight = screenSize.width - tapPos.dx - padding;

    // Score each position based on tap location and available space
    final scores = <PopupPosition, double>{};

    // Top positions
    if (spaceTop >= ph) {
      scores[PopupPosition.top] = spaceTop * (isTopSide ? 2.0 : 1.0);
    }

    // Bottom positions
    if (spaceBottom >= ph) {
      scores[PopupPosition.bottom] = spaceBottom * (!isTopSide ? 2.0 : 1.0);
    }

    // Left positions
    if (spaceLeft >= pw) {
      scores[PopupPosition.left] = spaceLeft * (isLeftSide ? 2.0 : 1.0);
    }

    // Right positions
    if (spaceRight >= pw) {
      scores[PopupPosition.right] = spaceRight * (!isLeftSide ? 2.0 : 1.0);
    }

    // If no perfect fit, find best fallback
    if (scores.isEmpty) {
      return _findBestFallbackPosition(screenSize, pw, ph);
    }

    // Return position with highest score (prefers tap side when available)
    return scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  PopupPosition _convertToBottom(PopupPosition pos) {
    switch (pos) {
      case PopupPosition.top:
        return PopupPosition.bottom;
      case PopupPosition.topLeft:
        return PopupPosition.bottomLeft;
      case PopupPosition.topRight:
        return PopupPosition.bottomRight;
      default:
        return pos;
    }
  }

  PopupPosition _convertToTop(PopupPosition pos) {
    switch (pos) {
      case PopupPosition.bottom:
        return PopupPosition.top;
      case PopupPosition.bottomLeft:
        return PopupPosition.topLeft;
      case PopupPosition.bottomRight:
        return PopupPosition.topRight;
      default:
        return pos;
    }
  }

  PopupPosition _findBestFallbackPosition(
    Size screenSize,
    double pw,
    double ph,
  ) {
    const padding = 16.0;

    // Calculate available space in each direction
    final spaceTop = widget.anchorOffset.dy - padding;
    final spaceBottom =
        screenSize.height -
        (widget.anchorOffset.dy + widget.anchorSize.height) -
        padding;
    final spaceLeft = widget.anchorOffset.dx - padding;
    final spaceRight =
        screenSize.width -
        (widget.anchorOffset.dx + widget.anchorSize.width) -
        padding;

    // Find the direction with most space
    final maxSpace = [
      spaceTop,
      spaceBottom,
      spaceLeft,
      spaceRight,
    ].reduce((a, b) => a > b ? a : b);

    if (maxSpace == spaceBottom) {
      return PopupPosition.bottom;
    } else if (maxSpace == spaceTop) {
      return PopupPosition.top;
    } else if (maxSpace == spaceRight) {
      return PopupPosition.right;
    } else {
      return PopupPosition.left;
    }
  }

  PopupPositionData _calculatePosition(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const padding = 16.0;
    final bubbleWidth = _size.width > 0 ? _size.width : 250.0;
    final bubbleHeight = _size.height > 0 ? _size.height : 150.0;

    double left = 0;
    double top = 0;
    double arrowOffset = 0;

    // Use tap position if available, otherwise use anchor center
    final targetX =
        widget.tapPosition?.dx ??
        (widget.anchorOffset.dx + (widget.anchorSize.width / 2));
    final targetY =
        widget.tapPosition?.dy ??
        (widget.anchorOffset.dy + (widget.anchorSize.height / 2));

    switch (_actualPosition) {
      case PopupPosition.top:
      case PopupPosition.bottom:
        // Try to center bubble horizontally on tap/anchor point
        left = targetX - (bubbleWidth / 2);

        // Clamp to screen bounds
        final minLeft = padding;
        final maxLeft = screenSize.width - bubbleWidth - padding;
        left = left.clamp(minLeft, maxLeft);

        // Calculate where arrow should point (relative to bubble's left edge)
        // Arrow points to tap position or anchor center
        arrowOffset = targetX - left;

        if (_actualPosition == PopupPosition.top) {
          top = widget.anchorOffset.dy - bubbleHeight - widget.arrowSize - 8;
        } else {
          top =
              widget.anchorOffset.dy +
              widget.anchorSize.height +
              widget.arrowSize +
              8;
        }
        break;

      case PopupPosition.topLeft:
      case PopupPosition.bottomLeft:
        left = widget.anchorOffset.dx;
        left = left.clamp(padding, screenSize.width - bubbleWidth - padding);

        // Arrow should point to the tap position or left side of anchor
        arrowOffset = targetX - left;

        if (_actualPosition == PopupPosition.topLeft) {
          top = widget.anchorOffset.dy - bubbleHeight - widget.arrowSize - 8;
        } else {
          top =
              widget.anchorOffset.dy +
              widget.anchorSize.height +
              widget.arrowSize +
              8;
        }
        break;

      case PopupPosition.topRight:
      case PopupPosition.bottomRight:
        left = widget.anchorOffset.dx + widget.anchorSize.width - bubbleWidth;
        left = left.clamp(padding, screenSize.width - bubbleWidth - padding);

        // Arrow should point to the tap position or right side of anchor
        arrowOffset = targetX - left;

        if (_actualPosition == PopupPosition.topRight) {
          top = widget.anchorOffset.dy - bubbleHeight - widget.arrowSize - 8;
        } else {
          top =
              widget.anchorOffset.dy +
              widget.anchorSize.height +
              widget.arrowSize +
              8;
        }
        break;

      case PopupPosition.left:
        left = widget.anchorOffset.dx - bubbleWidth - widget.arrowSize - 8;
        left = left.clamp(padding, screenSize.width - bubbleWidth - padding);

        // Try to center vertically on tap/anchor point
        top = targetY - (bubbleHeight / 2);
        final minTop = padding;
        final maxTop = screenSize.height - bubbleHeight - padding;
        top = top.clamp(minTop, maxTop);

        // Calculate where arrow should point (relative to bubble's top edge)
        arrowOffset = targetY - top;
        break;

      case PopupPosition.right:
        left =
            widget.anchorOffset.dx +
            widget.anchorSize.width +
            widget.arrowSize +
            8;
        left = left.clamp(padding, screenSize.width - bubbleWidth - padding);

        // Try to center vertically on tap/anchor point
        top = targetY - (bubbleHeight / 2);
        final minTop = padding;
        final maxTop = screenSize.height - bubbleHeight - padding;
        top = top.clamp(minTop, maxTop);

        // Calculate where arrow should point (relative to bubble's top edge)
        arrowOffset = targetY - top;
        break;
      default:
    }

    // Final safety clamp for top
    top = top.clamp(padding, screenSize.height - bubbleHeight - padding);

    return PopupPositionData(left: left, top: top, arrowOffset: arrowOffset);
  }

  @override
  Widget build(BuildContext context) {
    final position = _calculatePosition(context);

    // Calculate the origin point for scaling animation
    final tapPos =
        widget.tapPosition ??
        Offset(
          widget.anchorOffset.dx + widget.anchorSize.width / 2,
          widget.anchorOffset.dy + widget.anchorSize.height / 2,
        );

    return Stack(
      children: [
        // Tap outside to close
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onClose,
            behavior: HitTestBehavior.translucent,
            child: Container(color: Colors.transparent),
          ),
        ),
        // The bubble with scale animation
        Positioned(
          left: position.left,
          top: position.top,
          child: ScaleTransition(
            scale: _scaleAnimation,
            alignment: Alignment(
              // Calculate alignment based on tap position relative to bubble position
              ((tapPos.dx - position.left) /
                          (_size.width > 0 ? _size.width : 250.0)) *
                      2 -
                  1,
              ((tapPos.dy - position.top) /
                          (_size.height > 0 ? _size.height : 150.0)) *
                      2 -
                  1,
            ),
            child: Material(
              key: _popupKey,
              color: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              child: _buildArrow(position),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArrow(PopupPositionData position) {
    Widget child = Container(
      constraints: BoxConstraints(maxWidth: widget.maxWidth ?? 250.0),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
      ),
      child: widget.child,
    );
    if (widget.arrowSize <= 0) {
      return child;
    }
    return CustomPaint(
      painter: PopupArrow(
        color: widget.backgroundColor,
        position: _actualPosition,
        arrowSize: widget.arrowSize,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        arrowOffset: position.arrowOffset,
      ),
      child: child,
    );
  }
}

/// Enum to define the preferred position of the bubble
enum PopupPosition {
  detect,
  top,
  bottom,
  left,
  right,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class PopupPositionData {
  final double left;
  final double top;
  final double arrowOffset;

  const PopupPositionData({
    required this.left,
    required this.top,
    required this.arrowOffset,
  });
}

/// Custom painter to draw the bubble with an arrow
class PopupArrow extends CustomPainter {
  final Color color;
  final PopupPosition position;
  final double arrowSize;
  final BorderRadius borderRadius;
  final double arrowOffset;

  const PopupArrow({
    required this.color,
    required this.position,
    required this.arrowSize,
    required this.borderRadius,
    this.arrowOffset = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final path = Path();

    switch (position) {
      case PopupPosition.top:
      case PopupPosition.topLeft:
      case PopupPosition.topRight:
        // Arrow pointing down
        _drawBottomArrow(path, size);
        break;
      case PopupPosition.bottom:
      case PopupPosition.bottomLeft:
      case PopupPosition.bottomRight:
        // Arrow pointing up
        _drawTopArrow(path, size);
        break;
      case PopupPosition.left:
        // Arrow pointing right
        _drawRightArrow(path, size);
        break;
      case PopupPosition.right:
        // Arrow pointing left
        _drawLeftArrow(path, size);
        break;
      default:
    }

    canvas.drawPath(path, paint);
  }

  void _drawTopArrow(Path path, Size size) {
    // Arrow pointing upward - arrow position is where anchor center is
    final arrowX = arrowOffset.clamp(
      arrowSize + 8.0,
      size.width - arrowSize - 8.0,
    );

    path.moveTo(arrowX - arrowSize, 0);
    path.lineTo(arrowX, -arrowSize);
    path.lineTo(arrowX + arrowSize, 0);
    path.close();
  }

  void _drawBottomArrow(Path path, Size size) {
    // Arrow pointing downward - arrow position is where anchor center is
    final arrowX = arrowOffset.clamp(
      arrowSize + 8.0,
      size.width - arrowSize - 8.0,
    );

    path.moveTo(arrowX - arrowSize, size.height);
    path.lineTo(arrowX, size.height + arrowSize);
    path.lineTo(arrowX + arrowSize, size.height);
    path.close();
  }

  void _drawLeftArrow(Path path, Size size) {
    // Arrow pointing left - arrow position is where anchor center is
    final arrowY = arrowOffset.clamp(
      arrowSize + 8.0,
      size.height - arrowSize - 8.0,
    );

    path.moveTo(0, arrowY - arrowSize);
    path.lineTo(-arrowSize, arrowY);
    path.lineTo(0, arrowY + arrowSize);
    path.close();
  }

  void _drawRightArrow(Path path, Size size) {
    // Arrow pointing right - arrow position is where anchor center is
    final arrowY = arrowOffset.clamp(
      arrowSize + 8.0,
      size.height - arrowSize - 8.0,
    );

    path.moveTo(size.width, arrowY - arrowSize);
    path.lineTo(size.width + arrowSize, arrowY);
    path.lineTo(size.width, arrowY + arrowSize);
    path.close();
  }

  @override
  bool shouldRepaint(PopupArrow oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.position != position ||
        oldDelegate.arrowSize != arrowSize ||
        oldDelegate.arrowOffset != arrowOffset;
  }
}
