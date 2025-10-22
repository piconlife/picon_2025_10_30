import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy_kits/widgets/button.dart';
import 'package:flutter_androssy_kits/widgets/gesture.dart';

class InAppPurchaseButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const InAppPurchaseButton({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = context.color.base;
    return AndrossyButton(
      height: 70,
      enabled: onTap != null,
      width: double.infinity,
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      primary: color.dark,
      textColor: AndrossyButtonProperty(
        disabled: color.dark?.withValues(alpha: 0.5),
        enabled: color.light,
      ),
      backgroundColor: AndrossyButtonProperty(
        disabled: color.dark?.withValues(alpha: 0.1),
        enabled: color.dark,
      ),
      text: text,
      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      clickEffect: AndrossyGestureEffect(
        primary:
            onTap == null
                ? null
                : AndrossyGestureAnimation(
                  lowerBound: 0.95,
                  repeat: true,
                  duration: Duration(milliseconds: 700),
                  builder: (context, animation, child) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                ),
      ),
    );
  }
}
