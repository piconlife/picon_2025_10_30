import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../roots/utils/haptic.dart';

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, tan(pi / 3) * size.width / 2);
    path.close();
    Paint paint = Paint();
    paint.color = const Color.fromARGB(255, 118, 165, 248);
    paint.style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class RulerPicker extends StatefulWidget {
  final double width;
  final double height;
  final List<ScaleLineStyle> scaleLineStyleList;
  final List<RulerRange> ranges;
  final Widget? marker;
  final double marginTop;
  final double value;
  final Widget Function(int index, double value) textBuilder;
  final ValueChanged<double>? onChanged;

  const RulerPicker({
    super.key,
    required this.width,
    required this.height,
    this.ranges = const [],
    this.marginTop = 0,
    this.scaleLineStyleList = const [
      ScaleLineStyle(
        scale: 0,
        color: Color.fromARGB(255, 188, 194, 203),
        width: 2,
        height: 32,
      ),
      ScaleLineStyle(
        color: Color.fromARGB(255, 188, 194, 203),
        width: 1,
        height: 20,
      ),
    ],
    this.marker,
    required this.value,
    required this.textBuilder,
    this.onChanged,
  });

  @override
  State<StatefulWidget> createState() {
    return RulerPickerState();
  }
}

class RulerPickerState extends State<RulerPicker> {
  double lastOffset = 0;
  bool isPosFixed = false;
  String value = '';
  late ScrollController scrollController;
  final Map<int, ScaleLineStyle> _scaleLineStyleMap = {};
  int itemCount = 0;

  int _calculateItemCount() {
    int itemCount = 0;
    for (var element in widget.ranges) {
      itemCount += ((element.end - element.begin) / element.scale).truncate();
    }
    itemCount += 1;
    return itemCount;
  }

  late double previousValue = widget.value;

  void _changed() {
    int currentIndex = scrollController.offset ~/ _ruleScaleInterval.toInt();

    if (currentIndex < 0) currentIndex = 0;
    double currentValue = _scale(currentIndex);

    final lastConfig = widget.ranges.last;
    if (currentValue > lastConfig.end) currentValue = lastConfig.end;

    if (currentValue.toInt() != previousValue.toInt()) {
      Haptics.light();
    }
    previousValue = currentValue;
    if (widget.onChanged == null) return;
    widget.onChanged!(currentValue);
  }

  final double _ruleScaleInterval = 10;

  void fixOffset() {
    int tempFixedOffset = (scrollController.offset + 0.5) ~/ 1;

    double fixedOffset =
        (tempFixedOffset + _ruleScaleInterval / 2) ~/
        _ruleScaleInterval.toInt() *
        _ruleScaleInterval;
    Future.delayed(Duration.zero, () {
      scrollController.animateTo(
        fixedOffset,
        duration: Duration(milliseconds: 50),
        curve: Curves.bounceInOut,
      );
    });
  }

  double _scale(int index) {
    RulerRange? currentConfig;
    for (RulerRange config in widget.ranges) {
      currentConfig = config;
      if (currentConfig == widget.ranges.last) {
        break;
      }
      var totalCount = ((config.end - config.begin) / config.scale).truncate();

      if (index <= totalCount) {
        break;
      } else {
        index -= totalCount;
      }
    }
    return index * currentConfig!.scale + currentConfig.begin;
  }

  double getPositionByValue(num value) {
    double offsetValue = 0;
    for (RulerRange config in widget.ranges) {
      if (config.begin <= value && config.end >= value) {
        offsetValue +=
            ((value - config.begin) / config.scale) * _ruleScaleInterval;
        break;
      } else if (value >= config.begin) {
        var totalCount = ((config.end - config.begin) / config.scale)
            .truncate();
        offsetValue += totalCount * _ruleScaleInterval;
      }
    }
    return offsetValue;
  }

  void setPositionByValue(num value) {
    double offsetValue = getPositionByValue(value);
    scrollController.jumpTo(offsetValue);
    fixOffset();
  }

  @override
  void initState() {
    super.initState();
    itemCount = _calculateItemCount();
    for (var element in widget.scaleLineStyleList) {
      _scaleLineStyleMap[element.scale] = element;
    }
    double initValueOffset = getPositionByValue(widget.value);
    scrollController = ScrollController(
      initialScrollOffset: initValueOffset > 0 ? initValueOffset : 0,
    );
    scrollController.addListener(_changed);
  }

  bool _isRangesChanged(RulerPicker oldWidget) {
    if (oldWidget.ranges.length != widget.ranges.length) {
      return true;
    }

    if (widget.ranges.isEmpty) return false;
    for (int i = 0; i < widget.ranges.length; i++) {
      RulerRange oldRange = oldWidget.ranges[i];
      RulerRange range = widget.ranges[i];
      if (oldRange.begin != range.begin ||
          oldRange.end != range.end ||
          oldRange.scale != range.scale) {
        return true;
      }
    }
    return false;
  }

  @override
  void didUpdateWidget(RulerPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!mounted) return;
    if (_isRangesChanged(oldWidget)) {
      Future.delayed(Duration.zero, () {
        setState(() {
          itemCount = _calculateItemCount();
        });
        _changed();
      });
    }
    if (widget.value != oldWidget.value) {
      setPositionByValue(widget.value);
    }
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height + widget.marginTop,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: Listener(
              onPointerDown: (event) {
                FocusScope.of(context).requestFocus(FocusNode());
                isPosFixed = false;
              },
              child: NotificationListener(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollStartNotification) {
                  } else if (scrollNotification is ScrollUpdateNotification) {
                  } else if (scrollNotification is ScrollEndNotification) {
                    if (!isPosFixed) {
                      isPosFixed = true;
                      fixOffset();
                    }
                  }
                  return true;
                },
                child: SizedBox(
                  width: double.infinity,
                  height: widget.height,
                  child: ListView.builder(
                    clipBehavior: Clip.none,
                    padding: EdgeInsets.only(
                      left: (widget.width - _ruleScaleInterval) / 2,
                      right: (widget.width - _ruleScaleInterval) / 2,
                    ),
                    itemExtent: _ruleScaleInterval,
                    itemCount: itemCount,
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: _buildRulerScale,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: IgnorePointer(child: widget.marker ?? _buildMark()),
          ),
        ],
      ),
    );
  }

  Widget _buildMark() {
    Widget triangle() {
      return SizedBox(
        width: 15,
        height: 15,
        child: CustomPaint(painter: _TrianglePainter()),
      );
    }

    return SizedBox(
      width: _ruleScaleInterval * 2,
      height: 45,
      child: Stack(
        children: <Widget>[
          Align(alignment: Alignment.topCenter, child: triangle()),
          Align(
            child: Container(
              width: 3,
              height: 34,
              color: Color.fromARGB(255, 118, 165, 248),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRulerScaleLine(int index) {
    double width = 0;
    double height = 0;
    Color color = const Color(0xffD7D8D9);
    int scale = index % 10;

    if (_scaleLineStyleMap[scale] != null) {
      width = _scaleLineStyleMap[scale]!.width;
      height = _scaleLineStyleMap[scale]!.height;
      color = _scaleLineStyleMap[scale]!.color;
    } else {
      if (_scaleLineStyleMap[-1] != null) {
        scale = -1;
        width = _scaleLineStyleMap[scale]!.width;
        height = _scaleLineStyleMap[scale]!.height;
        color = _scaleLineStyleMap[scale]!.color;
      } else {
        if (scale == 0) {
          width = 2;
          height = 24;
        } else {
          width = 2;
          height = 24;
        }
      }
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
    );
  }

  Widget _buildRulerScale(BuildContext context, int index) {
    return SizedBox(
      width: _ruleScaleInterval,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: _buildRulerScaleLine(index),
          ),
          Positioned(
            bottom: -18,
            width: 100,
            left: -50 + _ruleScaleInterval / 2,
            child: index % 10 == 0
                ? widget.textBuilder(index, _scale(index))
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}

class ScaleLineStyle {
  final int scale;
  final Color color;
  final double width;
  final double height;

  const ScaleLineStyle({
    this.scale = -1,
    required this.color,
    required this.width,
    required this.height,
  });
}

class RulerRange {
  final double scale;
  final double begin;
  final double end;

  const RulerRange({required this.begin, required this.end, this.scale = 1});
}
