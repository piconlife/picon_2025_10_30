import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';

class CountdownText extends StatefulWidget {
  final bool enabled;
  final List<String> data;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFinish;
  final TextStyle? textStyle;
  final Widget? child;

  const CountdownText({
    super.key,
    this.enabled = true,
    this.data = const ["3", "2", "1"],
    this.onChanged,
    this.onFinish,
    this.textStyle,
    this.child,
  });

  @override
  State<CountdownText> createState() => _CountdownTextState();
}

class _CountdownTextState extends State<CountdownText> {
  bool isFinished = false;

  @override
  Widget build(BuildContext context) {
    if (isFinished || !widget.enabled) return widget.child ?? SizedBox();
    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: Center(
          child: DefaultTextStyle(
            style:
                widget.textStyle ??
                TextStyle(
                  color: context.dark,
                  fontSize: context.dp(128),
                  fontWeight: FontWeight.w900,
                ),
            child: AnimatedTextKit(
              pause: Duration.zero,
              repeatForever: false,
              isRepeatingAnimation: false,
              onFinished: () {
                setState(() => isFinished = true);
                widget.onFinish?.call();
              },
              onNext: (a, b) {
                widget.onChanged?.call(widget.data[a]);
              },
              animatedTexts: List.generate(widget.data.length, (index) {
                return RotateAnimatedText(
                  widget.data[index].trNumber,
                  duration: const Duration(seconds: 1),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
