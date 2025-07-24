import 'package:flutter/material.dart';

import '../../../../roots/widgets/gesture.dart';

class InAppDialogPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const InAppDialogPrimaryButton({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InAppGesture(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xffEAEAEA)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xFF585858),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
