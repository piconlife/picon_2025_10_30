import 'package:flutter/material.dart';

class InAppDefaults {
  const InAppDefaults._();

  static final shadowPrimary = [
    BoxShadow(color: Colors.black.withValues(alpha: 0.09), blurRadius: 20),
  ];

  static final shadowSecondary = [
    BoxShadow(
      color: Colors.grey.withValues(alpha: 0.1),
      spreadRadius: 1,
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
  ];
}
