import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy_kits/widgets.dart';

import '../../../../app/res/placeholders.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/image.dart';

class FeedImageBody extends StatelessWidget {
  final String? description;
  final List? photos;
  final ValueChanged<int>? onTap;

  const FeedImageBody({super.key, this.description, this.photos, this.onTap});

  @override
  Widget build(BuildContext context) {
    final dark = context.dark;
    final dimen = context.dimens;
    return Column(
      children: [
        if (photos.use.isNotEmpty) ...[
          Divider(height: dimen.dp(1)),
          AndrossyImageGrid(
            itemBackground: dark.t05,
            itemCount: photos?.length ?? 0,
            itemBuilder: (context, index) {
              final image = photos?.elementAtOrNull(index);
              return InAppGesture(
                onTap: onTap != null ? () => onTap!(index) : null,
                child: InAppImage(
                  image ?? InAppPlaceholders.image,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ],
        if (description.use.isNotEmpty) ...[
          Divider(height: dimen.dp(1)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: dimen.dp(16),
              vertical: dimen.dp(16) * 0.75,
            ),
            child: AndrossyExpandableText(
              description.use,
              initial: 50,
              style: TextStyle(fontSize: dimen.dp(16), color: dark),
            ),
          ),
        ],
      ],
    );
  }
}
