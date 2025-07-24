import 'package:flutter/material.dart';

class HeightPicker extends StatefulWidget {
  final ValueChanged<double> onChanged;
  final Widget Function(int index, num rulerScaleValue) scaleLabel;
  final List<ScaleLineStyle> scaleLineStyleList;
  final List<RulerRange> ranges;

  final Widget? marker;
  final Color background;
  final ValueNotifier<double>? controller;

  const HeightPicker({
    super.key,
    required this.onChanged,
    required this.scaleLabel,
    this.ranges = const [],
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
    this.background = Colors.white,
    this.controller,
  });

  @override
  State<StatefulWidget> createState() {
    return HeightPickerState();
  }
}

class HeightPickerState extends State<HeightPicker> {
  double lastOffset = 0;
  bool isPosFixed = false;
  String value = '';
  late ScrollController scrollController;
  final Map<int, ScaleLineStyle> _scaleLineStyleMap = {};
  int itemCount = 0;

  @override
  void initState() {
    super.initState();

    itemCount = _calculateItemCount();

    for (var e in widget.scaleLineStyleList) {
      _scaleLineStyleMap[e.scale] = e;
    }

    double initValueOffset = _position(widget.controller?.value ?? 0);

    scrollController = ScrollController(
      initialScrollOffset: initValueOffset > 0 ? initValueOffset : 0,
    );

    scrollController.addListener(_onValueChanged);

    widget.controller?.addListener(() {
      positionByValue = widget.controller?.value ?? 0;
    });
  }

  int _calculateItemCount() {
    int itemCount = 0;
    for (var e in widget.ranges) {
      itemCount += ((e.end - e.begin) / e.scale).truncate();
    }
    itemCount += 1;
    return itemCount;
  }

  void _onValueChanged() {
    int currentIndex = scrollController.offset ~/ _ruleScaleInterval.toInt();

    if (currentIndex < 0) currentIndex = 0;
    num currentValue = _value(currentIndex);

    var lastConfig = widget.ranges.last;
    if (currentValue > lastConfig.end) currentValue = lastConfig.end;

    widget.onChanged(currentValue.toDouble());
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
    return Container(
      color: Colors.grey,
      height: 20,
      margin: EdgeInsets.only(left: 2, right: 2),
    );
    return SizedBox(
      width: _ruleScaleInterval,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildRulerScaleLine(index),
          ),
          if (index % 10 == 0)
            Positioned(
              bottom: 50,
              width: 100,
              left: -50 + _ruleScaleInterval / 2,
              child: Container(
                alignment: Alignment.center,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: widget.scaleLabel(index, _value(index)),
                ),
              ),
            ),
        ],
      ),
    );
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

  num _value(int index) {
    num rulerScaleValue = 0;

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

    rulerScaleValue = index * currentConfig!.scale + currentConfig.begin;

    return rulerScaleValue;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ListView.separated(
              itemCount: itemCount,
              controller: scrollController,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    color: Colors.red,
                    width: 12,
                    height: _ruleScaleInterval,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: _ruleScaleInterval);
              },
            ),
          ),
          IgnorePointer(child: widget.marker),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  void didUpdateWidget(HeightPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (mounted) {
      if (isRangesChanged(oldWidget)) {
        Future.delayed(Duration.zero, () {
          setState(() {
            itemCount = _calculateItemCount();
          });
          _onValueChanged();
        });
      }
    }
  }

  bool isRangesChanged(HeightPicker oldWidget) {
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

  double _position(num value) {
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

  set positionByValue(num value) {
    double offsetValue = _position(value);
    scrollController.jumpTo(offsetValue);
    fixOffset();
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
  final int begin;
  final int end;

  const RulerRange({required this.begin, required this.end, this.scale = 1});
}
