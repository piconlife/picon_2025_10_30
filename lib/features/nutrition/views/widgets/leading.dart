import 'dart:ui';

import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';

import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';

class NutritionLeading extends StatelessWidget {
  const NutritionLeading({super.key});

  @override
  Widget build(BuildContext context) {
    return InAppGesture(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.dark.t05,
              shape: BoxShape.circle,
            ),
            child: InAppIcon(Icons.arrow_back_ios_new, color: context.dark),
          ),
        ),
      ),
      onTap: () => Navigator.pop(context),
    );
  }
}
