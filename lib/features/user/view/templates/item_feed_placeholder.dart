import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy_kits/widgets.dart';

class ItemUserFeedPlaceholder extends StatelessWidget {
  const ItemUserFeedPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    return AndrossyShimmer(
      fadeLowerBound: 0.0,
      fadeUpperBound: 1.0,
      child: SizedBox(
        width: double.infinity,
        child: ColoredBox(
          color: context.light,
          child: Column(
            children: [
              SizedBox(height: dimen.dp(12)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: dimen.dp(12)),
                  CircleAvatar(radius: dimen.dp(20), backgroundColor: dark.t10),
                  SizedBox(width: dimen.dp(16)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: dimen.dp(120),
                          height: dimen.dp(18),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: dark.t10,
                              borderRadius: BorderRadius.circular(dimen.dp(24)),
                            ),
                          ),
                        ),
                        SizedBox(height: dimen.dp(4)),
                        SizedBox(
                          width: dimen.dp(180),
                          height: dimen.dp(14),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: dark.t05,
                              borderRadius: BorderRadius.circular(dimen.dp(24)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: dimen.dp(12)),
                ],
              ),
              SizedBox(height: dimen.dp(12)),
              AspectRatio(aspectRatio: 1.5, child: ColoredBox(color: dark.t05)),
              Padding(
                padding: EdgeInsets.all(dimen.dp(8)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: dimen.dp(8)),
                    CircleAvatar(
                      backgroundColor: dark.t05,
                      radius: dimen.dp(20),
                    ),
                    SizedBox(width: dimen.dp(8)),
                    CircleAvatar(
                      backgroundColor: dark.t05,
                      radius: dimen.dp(20),
                    ),
                    SizedBox(width: dimen.dp(8)),
                    Expanded(
                      child: SizedBox(
                        height: dimen.dp(40),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: dark.t05,
                            borderRadius: BorderRadius.circular(dimen.dp(24)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
