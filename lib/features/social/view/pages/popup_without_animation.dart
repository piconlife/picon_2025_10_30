import 'package:flutter/material.dart';

/// Enum to define the preferred position of the bubble
enum BubblePosition {
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
class AnchoredBubblePopup extends StatefulWidget {
  /// The widget that will be the anchor (clickable element)
  final Widget child;

  /// The content to show in the bubble popup
  final Widget bubbleContent;

  /// Preferred position of the bubble relative to the anchor
  final BubblePosition position;

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
  final VoidCallback? onBubbleShow;

  /// Callback when bubble is hidden
  final VoidCallback? onBubbleHide;

  const AnchoredBubblePopup({
    Key? key,
    required this.child,
    required this.bubbleContent,
    this.position = BubblePosition.top,
    this.backgroundColor = const Color(0xFF2C3E50),
    this.arrowSize = 12.0,
    this.borderRadius,
    this.maxWidth = 250.0,
    this.showOnTap = true,
    this.onBubbleShow,
    this.onBubbleHide,
  }) : super(key: key);

  @override
  State<AnchoredBubblePopup> createState() => _AnchoredBubblePopupState();
}

class _AnchoredBubblePopupState extends State<AnchoredBubblePopup> {
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
      builder:
          (context) => _BubbleOverlay(
            anchorOffset: offset,
            anchorSize: size,
            position: widget.position,
            tapPosition: _tapPosition,
            backgroundColor: widget.backgroundColor,
            arrowSize: widget.arrowSize,
            borderRadius: widget.borderRadius,
            maxWidth: widget.maxWidth,
            onClose: _hideBubble,
            child: widget.bubbleContent,
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isShowing = true;
    });
    widget.onBubbleShow?.call();
  }

  void _hideBubble() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isShowing = false;
    });
    widget.onBubbleHide?.call();
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
class _BubbleOverlay extends StatefulWidget {
  final Offset anchorOffset;
  final Size anchorSize;
  final BubblePosition position;
  final Widget child;
  final VoidCallback onClose;
  final Color backgroundColor;
  final double arrowSize;
  final BorderRadius? borderRadius;
  final double? maxWidth;
  final Offset? tapPosition;

  const _BubbleOverlay({
    Key? key,
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
  }) : super(key: key);

  @override
  State<_BubbleOverlay> createState() => _BubbleOverlayState();
}

class _BubbleOverlayState extends State<_BubbleOverlay> {
  final GlobalKey _bubbleKey = GlobalKey();
  Size _bubbleSize = Size.zero;
  BubblePosition _actualPosition = BubblePosition.bottom;

  @override
  void initState() {
    super.initState();
    _actualPosition = widget.position;
    // Measure bubble size after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureAndAdjustPosition();
    });
  }

  void _measureAndAdjustPosition() {
    final RenderBox? renderBox =
        _bubbleKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _bubbleSize = renderBox.size;
        _actualPosition = _determineBestPosition();
      });
    }
  }

  BubblePosition _determineBestPosition() {
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
      case BubblePosition.top:
      case BubblePosition.topLeft:
      case BubblePosition.topRight:
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

      case BubblePosition.bottom:
      case BubblePosition.bottomLeft:
      case BubblePosition.bottomRight:
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

      case BubblePosition.left:
        // Check if there's enough space on the left
        if (widget.anchorOffset.dx - bubbleWidth >= padding) {
          return widget.position;
        }
        // Try right instead
        if (widget.anchorOffset.dx + widget.anchorSize.width + bubbleWidth <=
            screenSize.width - padding) {
          return BubblePosition.right;
        }
        break;

      case BubblePosition.right:
        // Check if there's enough space on the right
        if (widget.anchorOffset.dx + widget.anchorSize.width + bubbleWidth <=
            screenSize.width - padding) {
          return widget.position;
        }
        // Try left instead
        if (widget.anchorOffset.dx - bubbleWidth >= padding) {
          return BubblePosition.left;
        }
        break;
    }

    // If nothing fits perfectly, find the best option
    return _findBestFallbackPosition(screenSize, bubbleWidth, bubbleHeight);
  }

  BubblePosition _autoDetectPositionFromTap(
    Size screenSize,
    double bubbleWidth,
    double bubbleHeight,
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
    final scores = <BubblePosition, double>{};

    // Top positions
    if (spaceTop >= bubbleHeight) {
      scores[BubblePosition.top] = spaceTop * (isTopSide ? 2.0 : 1.0);
    }

    // Bottom positions
    if (spaceBottom >= bubbleHeight) {
      scores[BubblePosition.bottom] = spaceBottom * (!isTopSide ? 2.0 : 1.0);
    }

    // Left positions
    if (spaceLeft >= bubbleWidth) {
      scores[BubblePosition.left] = spaceLeft * (isLeftSide ? 2.0 : 1.0);
    }

    // Right positions
    if (spaceRight >= bubbleWidth) {
      scores[BubblePosition.right] = spaceRight * (!isLeftSide ? 2.0 : 1.0);
    }

    // If no perfect fit, find best fallback
    if (scores.isEmpty) {
      return _findBestFallbackPosition(screenSize, bubbleWidth, bubbleHeight);
    }

    // Return position with highest score (prefers tap side when available)
    return scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  BubblePosition _convertToBottom(BubblePosition pos) {
    switch (pos) {
      case BubblePosition.top:
        return BubblePosition.bottom;
      case BubblePosition.topLeft:
        return BubblePosition.bottomLeft;
      case BubblePosition.topRight:
        return BubblePosition.bottomRight;
      default:
        return pos;
    }
  }

  BubblePosition _convertToTop(BubblePosition pos) {
    switch (pos) {
      case BubblePosition.bottom:
        return BubblePosition.top;
      case BubblePosition.bottomLeft:
        return BubblePosition.topLeft;
      case BubblePosition.bottomRight:
        return BubblePosition.topRight;
      default:
        return pos;
    }
  }

  BubblePosition _findBestFallbackPosition(
    Size screenSize,
    double bubbleWidth,
    double bubbleHeight,
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
      return BubblePosition.bottom;
    } else if (maxSpace == spaceTop) {
      return BubblePosition.top;
    } else if (maxSpace == spaceRight) {
      return BubblePosition.right;
    } else {
      return BubblePosition.left;
    }
  }

  @override
  Widget build(BuildContext context) {
    final position = _calculatePosition(context);

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
        // The bubble
        Positioned(
          left: position.left,
          top: position.top,
          child: Material(
            color: Colors.transparent,
            child: CustomPaint(
              painter: BubblePainter(
                color: widget.backgroundColor,
                position: _actualPosition,
                arrowSize: widget.arrowSize,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
                arrowOffset: position.arrowOffset,
              ),
              child: Container(
                key: _bubbleKey,
                margin: _getMargin(_actualPosition),
                constraints: BoxConstraints(maxWidth: widget.maxWidth ?? 250.0),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ],
    );
  }

  EdgeInsets _getMargin(BubblePosition position) {
    switch (position) {
      case BubblePosition.top:
      case BubblePosition.topLeft:
      case BubblePosition.topRight:
        return EdgeInsets.only(bottom: widget.arrowSize);
      case BubblePosition.bottom:
      case BubblePosition.bottomLeft:
      case BubblePosition.bottomRight:
        return EdgeInsets.only(top: widget.arrowSize);
      case BubblePosition.left:
        return EdgeInsets.only(right: widget.arrowSize);
      case BubblePosition.right:
        return EdgeInsets.only(left: widget.arrowSize);
    }
  }

  _PositionData _calculatePosition(BuildContext context) {
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
      case BubblePosition.top:
      case BubblePosition.bottom:
        // Try to center bubble horizontally on tap/anchor point
        left = targetX - (bubbleWidth / 2);

        // Clamp to screen bounds
        final minLeft = padding;
        final maxLeft = screenSize.width - bubbleWidth - padding;
        left = left.clamp(minLeft, maxLeft);

        // Calculate where arrow should point (relative to bubble's left edge)
        // Arrow points to tap position or anchor center
        arrowOffset = targetX - left;

        if (_actualPosition == BubblePosition.top) {
          top = widget.anchorOffset.dy - bubbleHeight - widget.arrowSize - 8;
        } else {
          top =
              widget.anchorOffset.dy +
              widget.anchorSize.height +
              widget.arrowSize +
              8;
        }
        break;

      case BubblePosition.topLeft:
      case BubblePosition.bottomLeft:
        left = widget.anchorOffset.dx;
        left = left.clamp(padding, screenSize.width - bubbleWidth - padding);

        // Arrow should point to the tap position or left side of anchor
        arrowOffset = targetX - left;

        if (_actualPosition == BubblePosition.topLeft) {
          top = widget.anchorOffset.dy - bubbleHeight - widget.arrowSize - 8;
        } else {
          top =
              widget.anchorOffset.dy +
              widget.anchorSize.height +
              widget.arrowSize +
              8;
        }
        break;

      case BubblePosition.topRight:
      case BubblePosition.bottomRight:
        left = widget.anchorOffset.dx + widget.anchorSize.width - bubbleWidth;
        left = left.clamp(padding, screenSize.width - bubbleWidth - padding);

        // Arrow should point to the tap position or right side of anchor
        arrowOffset = targetX - left;

        if (_actualPosition == BubblePosition.topRight) {
          top = widget.anchorOffset.dy - bubbleHeight - widget.arrowSize - 8;
        } else {
          top =
              widget.anchorOffset.dy +
              widget.anchorSize.height +
              widget.arrowSize +
              8;
        }
        break;

      case BubblePosition.left:
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

      case BubblePosition.right:
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
    }

    // Final safety clamp for top
    top = top.clamp(padding, screenSize.height - bubbleHeight - padding);

    return _PositionData(left: left, top: top, arrowOffset: arrowOffset);
  }
}

class _PositionData {
  final double left;
  final double top;
  final double arrowOffset;

  _PositionData({
    required this.left,
    required this.top,
    required this.arrowOffset,
  });
}

/// Custom painter to draw the bubble with an arrow
class BubblePainter extends CustomPainter {
  final Color color;
  final BubblePosition position;
  final double arrowSize;
  final BorderRadius borderRadius;
  final double arrowOffset;

  BubblePainter({
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
      case BubblePosition.top:
      case BubblePosition.topLeft:
      case BubblePosition.topRight:
        // Arrow pointing down
        _drawBottomArrow(path, size);
        break;
      case BubblePosition.bottom:
      case BubblePosition.bottomLeft:
      case BubblePosition.bottomRight:
        // Arrow pointing up
        _drawTopArrow(path, size);
        break;
      case BubblePosition.left:
        // Arrow pointing right
        _drawRightArrow(path, size);
        break;
      case BubblePosition.right:
        // Arrow pointing left
        _drawLeftArrow(path, size);
        break;
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
  bool shouldRepaint(BubblePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.position != position ||
        oldDelegate.arrowSize != arrowSize ||
        oldDelegate.arrowOffset != arrowOffset;
  }
}
