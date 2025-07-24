import 'package:flutter/material.dart';
import 'package:flutter_androssy_kits/widgets.dart';

class InAppOutlinedButton extends StatefulWidget {
  final bool enabled;
  final double? width;
  final double? height;
  final String text;
  final Color? textColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const InAppOutlinedButton({
    super.key,
    required this.text,
    this.borderColor,
    this.borderRadius,
    this.onTap,
    this.enabled = true,
    this.width = double.infinity,
    this.height = 45,
    this.textColor,
  });

  @override
  State<InAppOutlinedButton> createState() => InAppOutlinedButtonState();
}

class InAppOutlinedButtonState extends State<InAppOutlinedButton> {
  late bool enabled = widget.enabled;
  bool loading = false;

  void setEnabled(bool value) {
    if (value == enabled) return;
    setState(() => enabled = value);
  }

  void showLoading() => setLoading(true);

  void hideLoading() => setLoading(false);

  void setLoading(bool value) {
    if (value == loading) return;
    setState(() {
      enabled = !value;
      loading = value;
    });
  }

  @override
  void didUpdateWidget(covariant InAppOutlinedButton oldWidget) {
    enabled = widget.enabled;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AndrossyButton(
      enabled: widget.enabled,
      borderColor: AndrossyButtonProperty(enabled: widget.borderColor),
      borderRadius: widget.borderRadius,
      text: widget.text,
      width: widget.width,
      height: widget.height,
      borderOnly: true,
      loading: loading,
      textColor: AndrossyButtonProperty(enabled: widget.textColor),
      clickEffect: const AndrossyGestureEffect(
        primary: AndrossyGestureAnimation.scale(),
        secondary: AndrossyGestureAnimation.fade(),
      ),
      onTap: widget.onTap,
    );
  }
}
