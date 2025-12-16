import 'package:flutter/material.dart';

typedef AnchoredPopupArrowBuilder = Widget Function(BuildContext context);

/// Enum to define the preferred position of the bubble
enum Position {
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

/// Main widget that wraps any child widget and shows a bubble popup when clicked
class AnchoredPopup extends StatefulWidget {
  /// The widget that will be the anchor (clickable element)
  final Widget child;

  /// The content to show in the bubble popup
  final Widget content;

  /// Preferred position of the bubble relative to the anchor
  final Position position;

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

  /// Callback when bubble is shown
  final VoidCallback? onShow;

  /// Callback when bubble is hidden
  final VoidCallback? onHide;

  final AnchoredPopupArrowBuilder? arrowBuilder;

  const AnchoredPopup({
    super.key,
    required this.child,
    required this.content,
    this.position = Position.detect,
    this.backgroundColor = const Color(0xFF2C3E50),
    this.arrowSize = 8.0,
    this.borderRadius,
    this.maxWidth = 250.0,
    this.showOnTap = true,
    this.arrowBuilder,
    this.onShow,
    this.onHide,
  });

  @override
  State<AnchoredPopup> createState() => _AnchoredPopupState();
}

class _AnchoredPopupState extends State<AnchoredPopup> {
  final GlobalKey _anchorKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isShowing = false;
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();
    if (!widget.showOnTap) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showBubble(null);
      });
    }
  }

  void _toggleBubble(Offset? tapPosition) {
    if (_isShowing) {
      _hideBubble();
    } else {
      _showBubble(tapPosition);
    }
  }

  void _showBubble(Offset? tapPosition) {
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
          onClose: _hideBubble,
          child: widget.content,
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isShowing = true;
    });
    widget.onShow?.call();
  }

  void _hideBubble() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isShowing = false;
    });
    widget.onHide?.call();
  }

  @override
  void dispose() {
    _hideBubble();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _anchorKey,
      onTapDown:
          widget.showOnTap
              ? (details) {
                final RenderBox? renderBox =
                    _anchorKey.currentContext?.findRenderObject() as RenderBox?;
                if (renderBox != null) {
                  final localPosition = details.localPosition;
                  final globalPosition = renderBox.localToGlobal(localPosition);
                  _toggleBubble(globalPosition);
                }
              }
              : null,
      child: widget.child,
    );
  }
}

/// The actual bubble popup widget with positioning logic (internal use)
class _Overlay extends StatefulWidget {
  final AnchoredPopupArrowBuilder? arrowBuilder;
  final Offset anchorOffset;
  final Size anchorSize;
  final Position position;
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
  Size _bubbleSize = Size.zero;
  Position _actualPosition = Position.bottom;
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
        _bubbleSize = renderBox.size;
        if (widget.position == Position.detect) {
          _actualPosition = _determineBestPosition();
        }
      });
    }
  }

  Position _determineBestPosition() {
    final screenSize = MediaQuery.of(context).size;
    const padding = 16.0;
    final bubbleWidth = _bubbleSize.width + widget.arrowSize + padding * 2;
    final bubbleHeight = _bubbleSize.height + widget.arrowSize + padding * 2;

    // If we have tap position, use it to determine the best position
    if (widget.tapPosition != null) {
      return _autoDetectPositionFromTap(screenSize, bubbleWidth, bubbleHeight);
    }

    // Otherwise, check if preferred position fits
    switch (widget.position) {
      case Position.top:
      case Position.topLeft:
      case Position.topRight:
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

      case Position.bottom:
      case Position.bottomLeft:
      case Position.bottomRight:
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

      case Position.left:
        // Check if there's enough space on the left
        if (widget.anchorOffset.dx - bubbleWidth >= padding) {
          return widget.position;
        }
        // Try right instead
        if (widget.anchorOffset.dx + widget.anchorSize.width + bubbleWidth <=
            screenSize.width - padding) {
          return Position.right;
        }
        break;

      case Position.right:
        // Check if there's enough space on the right
        if (widget.anchorOffset.dx + widget.anchorSize.width + bubbleWidth <=
            screenSize.width - padding) {
          return widget.position;
        }
        // Try left instead
        if (widget.anchorOffset.dx - bubbleWidth >= padding) {
          return Position.left;
        }
        break;
      default:
    }

    // If nothing fits perfectly, find the best option
    return _findBestFallbackPosition(screenSize, bubbleWidth, bubbleHeight);
  }

  Position _autoDetectPositionFromTap(Size screenSize, double pw, double ph) {
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
    final scores = <Position, double>{};

    // Top positions
    if (spaceTop >= ph) {
      scores[Position.top] = spaceTop * (isTopSide ? 2.0 : 1.0);
    }

    // Bottom positions
    if (spaceBottom >= ph) {
      scores[Position.bottom] = spaceBottom * (!isTopSide ? 2.0 : 1.0);
    }

    // Left positions
    if (spaceLeft >= pw) {
      scores[Position.left] = spaceLeft * (isLeftSide ? 2.0 : 1.0);
    }

    // Right positions
    if (spaceRight >= pw) {
      scores[Position.right] = spaceRight * (!isLeftSide ? 2.0 : 1.0);
    }

    // If no perfect fit, find best fallback
    if (scores.isEmpty) {
      return _findBestFallbackPosition(screenSize, pw, ph);
    }

    // Return position with highest score (prefers tap side when available)
    return scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  Position _convertToBottom(Position pos) {
    switch (pos) {
      case Position.top:
        return Position.bottom;
      case Position.topLeft:
        return Position.bottomLeft;
      case Position.topRight:
        return Position.bottomRight;
      default:
        return pos;
    }
  }

  Position _convertToTop(Position pos) {
    switch (pos) {
      case Position.bottom:
        return Position.top;
      case Position.bottomLeft:
        return Position.topLeft;
      case Position.bottomRight:
        return Position.topRight;
      default:
        return pos;
    }
  }

  Position _findBestFallbackPosition(Size screenSize, double pw, double ph) {
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
      return Position.bottom;
    } else if (maxSpace == spaceTop) {
      return Position.top;
    } else if (maxSpace == spaceRight) {
      return Position.right;
    } else {
      return Position.left;
    }
  }

  PositionData _calculatePosition(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const padding = 16.0;
    final bubbleWidth = _bubbleSize.width > 0 ? _bubbleSize.width : 250.0;
    final bubbleHeight = _bubbleSize.height > 0 ? _bubbleSize.height : 150.0;

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
      case Position.top:
      case Position.bottom:
        // Try to center bubble horizontally on tap/anchor point
        left = targetX - (bubbleWidth / 2);

        // Clamp to screen bounds
        final minLeft = padding;
        final maxLeft = screenSize.width - bubbleWidth - padding;
        left = left.clamp(minLeft, maxLeft);

        // Calculate where arrow should point (relative to bubble's left edge)
        // Arrow points to tap position or anchor center
        arrowOffset = targetX - left;

        if (_actualPosition == Position.top) {
          top = widget.anchorOffset.dy - bubbleHeight - widget.arrowSize - 8;
        } else {
          top =
              widget.anchorOffset.dy +
              widget.anchorSize.height +
              widget.arrowSize +
              8;
        }
        break;

      case Position.topLeft:
      case Position.bottomLeft:
        left = widget.anchorOffset.dx;
        left = left.clamp(padding, screenSize.width - bubbleWidth - padding);

        // Arrow should point to the tap position or left side of anchor
        arrowOffset = targetX - left;

        if (_actualPosition == Position.topLeft) {
          top = widget.anchorOffset.dy - bubbleHeight - widget.arrowSize - 8;
        } else {
          top =
              widget.anchorOffset.dy +
              widget.anchorSize.height +
              widget.arrowSize +
              8;
        }
        break;

      case Position.topRight:
      case Position.bottomRight:
        left = widget.anchorOffset.dx + widget.anchorSize.width - bubbleWidth;
        left = left.clamp(padding, screenSize.width - bubbleWidth - padding);

        // Arrow should point to the tap position or right side of anchor
        arrowOffset = targetX - left;

        if (_actualPosition == Position.topRight) {
          top = widget.anchorOffset.dy - bubbleHeight - widget.arrowSize - 8;
        } else {
          top =
              widget.anchorOffset.dy +
              widget.anchorSize.height +
              widget.arrowSize +
              8;
        }
        break;

      case Position.left:
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

      case Position.right:
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

    return PositionData(left: left, top: top, arrowOffset: arrowOffset);
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
                          (_bubbleSize.width > 0 ? _bubbleSize.width : 250.0)) *
                      2 -
                  1,
              ((tapPos.dy - position.top) /
                          (_bubbleSize.height > 0
                              ? _bubbleSize.height
                              : 150.0)) *
                      2 -
                  1,
            ),
            child: Material(
              key: _popupKey,
              color: Colors.transparent,
              child: _buildArrow(position),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArrow(PositionData position) {
    if (widget.arrowBuilder != null) {}
    return CustomPaint(
      painter: PopupArrow(
        color: widget.backgroundColor,
        position: _actualPosition,
        arrowSize: widget.arrowSize,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        arrowOffset: position.arrowOffset,
      ),
      child: Container(
        constraints: BoxConstraints(maxWidth: widget.maxWidth ?? 250.0),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        ),
        child: widget.child,
      ),
    );
  }
}

class PositionData {
  final double left;
  final double top;
  final double arrowOffset;

  PositionData({
    required this.left,
    required this.top,
    required this.arrowOffset,
  });
}

/// Custom painter to draw the bubble with an arrow
class PopupArrow extends CustomPainter {
  final Color color;
  final Position position;
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
      case Position.top:
      case Position.topLeft:
      case Position.topRight:
        // Arrow pointing down
        _drawBottomArrow(path, size);
        break;
      case Position.bottom:
      case Position.bottomLeft:
      case Position.bottomRight:
        // Arrow pointing up
        _drawTopArrow(path, size);
        break;
      case Position.left:
        // Arrow pointing right
        _drawRightArrow(path, size);
        break;
      case Position.right:
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
