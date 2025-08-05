import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/models/selection.dart';
import 'package:flutter_andomie/utils/validator.dart';
import 'package:flutter_androssy_kits/widgets.dart';

import '../../../../app/res/icons.dart';
import '../../../../app/styles/fonts.dart';
import '../../../../data/models/channel.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/pleasure_button.dart';
import '../../../../roots/widgets/text.dart';

class ItemSuggestedChannel extends StatelessWidget {
  final Selection<Channel> selection;
  final VoidCallback? onTap;
  final VoidCallback? onFollow;

  const ItemSuggestedChannel({
    super.key,
    required this.selection,
    this.onTap,
    this.onFollow,
  });

  @override
  Widget build(BuildContext context) {
    final dark = context.dark;
    final primary = context.primary;
    final dimen = context.dimens;
    final item = selection.data;
    return InAppGesture(
      onTap: onTap,
      scalerLowerBound: 1,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: dark.t05,
          borderRadius: BorderRadius.circular(dimen.dp(16)),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if ((item.coverPhoto ?? item.profilePhoto).isValidWebUrl)
              InAppImage(
                item.coverPhoto ?? item.profilePhoto,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent.withValues(alpha: 0.01),
                    Colors.transparent.withValues(alpha: 0.02),
                    Colors.transparent.withValues(alpha: 0.05),
                    Colors.black12,
                    Colors.black26,
                    Colors.black54,
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(dimen.dp(10)),
                alignment: Alignment.center,
                child: InAppText(
                  item.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: InAppFonts.secondary,
                    fontSize: dimen.dp(16),
                    fontWeight: dimen.mediumFontWeight,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(dimen.dp(12)),
                  ),
                ),
                padding: EdgeInsets.all(dimen.dp(2)),
                alignment: Alignment.center,
                child: InAppPleasureButton(
                  onTap: onFollow,
                  icon: selection.selected
                      ? InAppIcons.heart.solid
                      : InAppIcons.heart.regular,
                  iconColor: primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderSuggestedChannel extends StatelessWidget {
  const PlaceholderSuggestedChannel({super.key});

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    return AndrossyShimmer(
      fadeLowerBound: 0.25,
      shimmerDuration: Duration.zero,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: dark.t05,
          borderRadius: BorderRadius.circular(dimen.dp(16)),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 24,
                margin: EdgeInsets.symmetric(
                  horizontal: dimen.dp(12),
                  vertical: dimen.dp(8),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(dimen.dp(25)),
                  color: dark.t05,
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: dimen.dp(40),
                height: dimen.dp(40),
                decoration: BoxDecoration(
                  color: dark.t05,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(dimen.dp(12)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
