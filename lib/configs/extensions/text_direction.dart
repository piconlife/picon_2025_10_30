import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';

extension PaddingTextDirectionalExtension on EdgeInsets {
  EdgeInsets get directional {
    final isLtr = Translation.textDirection == TextDirection.ltr;
    return copyWith(left: isLtr ? left : right, right: isLtr ? right : left);
  }
}

extension BorderRadiusDirectionalExtension on BorderRadius {
  BorderRadius get directional {
    final isLtr = Translation.textDirection == TextDirection.ltr;
    return copyWith(
      topLeft: isLtr ? topLeft : topRight,
      topRight: isLtr ? topRight : topLeft,
      bottomLeft: isLtr ? bottomLeft : bottomRight,
      bottomRight: isLtr ? bottomRight : bottomLeft,
    );
  }
}
