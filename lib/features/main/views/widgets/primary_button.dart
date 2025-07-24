import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';

import '../../../../roots/widgets/gesture.dart';

class InAppPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const InAppPrimaryButton({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InAppGesture(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: context.light,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
