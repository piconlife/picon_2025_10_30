import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

final x = {
  0.00772: "Squeeze",
  0.02523: "Holding",
  0.06218: "Relax",
  0.07607: "Hold",
  0.09358: "Squeeze",
  0.11640: "Holding",
  0.15818: "Relax",
  0.17871: "Hold",
  0.20105: "Squeeze",
  0.22073: "Holding",
  0.25503: "Relax",
  0.27652: "Hold",
  0.29934: "Squeeze",
  0.32169: "Holding",
  0.35417: "Relax",
  0.37917: "Hold",
  0.41250: "Squeeze",
  0.44051: "Holding",
  0.48580: "Relax",
  0.50367: "Hold",
  0.53482: "Squeeze",
  0.56018: "Holding",
  0.60281: "Relax",
  0.61537: "Hold",
  0.67346: "Squeeze",
  0.70329: "Holding",
  0.75087: "Relax",
  0.76258: "Hold",
  0.79458: "Squeeze",
  0.82659: "Holding",
  0.87187: "Relax",
  0.89336: "Hold",
  0.91655: "Squeeze",
  0.94372: "Holding",
  0.98333: "Relax",
};

double get a {
  return 0.95;
}

class LottiePoints extends StatefulWidget {
  final String data;
  final ValueNotifier<bool> play;
  final Map<num, String> status;

  const LottiePoints(
    this.data, {
    super.key,
    this.status = const {0: ""},
    required this.play,
  });

  @override
  State<LottiePoints> createState() => _LottiePointsState();
}

class _LottiePointsState extends State<LottiePoints>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  void _control() {
    log("CONTROL: ${widget.play.value}");
    if (widget.play.value) {
      _controller.forward(from: _controller.value);
      return;
    }
    _controller.stop();
  }

  void _status(AnimationStatus status) {
    log("STATUS: $status");
  }

  void _listen() {
    log("POSITION: ${_controller.value}");
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: 5),
    );
    _controller.addListener(_listen);
    _controller.addStatusListener(_status);
    widget.play.addListener(_control);
  }

  @override
  void dispose() {
    _controller.removeListener(_listen);
    _controller.removeStatusListener(_status);
    widget.play.removeListener(_control);
    _controller.dispose();
    super.dispose();
  }

  void _onLottieLoaded(LottieComposition composition) {
    final duration = composition.duration;
    // _controller.duration = duration;
    _controller.forward();
  }

  void _playPause() {
    if (_controller.isAnimating) {
      _controller.stop();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            Center(
              child: Lottie.asset(
                widget.data,
                controller: _controller,
                onLoaded: _onLottieLoaded,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 40,
              child: ListenableBuilder(
                listenable: _controller,
                builder: (context, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: _controller.value.toStringAsFixed(5),
                            ),
                          );
                        },
                        child: Text(
                          _controller.value.toStringAsFixed(5),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      IconButton(
                        onPressed: _playPause,
                        icon: Icon(Icons.pause),
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              _controller.reset();
                            },
                            icon: Icon(Icons.lock_reset),
                          ),
                          Expanded(
                            child: Slider(
                              value: _controller.value,
                              min: 0,
                              max: 1,
                              divisions: 15000,
                              label: _controller.value.toStringAsFixed(5),
                              onChanged: (value) {
                                _controller.value = value;
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _controller.value = _controller.value + 0.0025;
                            },
                            icon: Icon(Icons.add),
                          ),
                          IconButton(
                            onPressed: () {
                              _controller.value = _controller.value - 0.0025;
                            },
                            icon: Icon(Icons.remove),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
