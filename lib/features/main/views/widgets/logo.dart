import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../app/res/logo.dart';

class BrandedLogo extends StatelessWidget {
  const BrandedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      InAppLogos.tertiary(context.isDarkMode),
      height: 24,
    );
  }
}
