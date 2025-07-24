import 'package:flutter/material.dart';

class SettingsCardLayout extends StatelessWidget {
  final Widget? child;

  const SettingsCardLayout({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFEAEAEA), width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
