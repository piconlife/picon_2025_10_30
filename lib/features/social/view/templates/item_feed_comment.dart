import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/date_helper.dart';

import '../../../../app/res/icons.dart';
import '../../../../data/models/feed_comment.dart';
import '../../../../roots/widgets/column.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/row.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../roots/widgets/user_avatar.dart';
import '../../../../roots/widgets/user_builder.dart';

class ItemFeedComment extends StatefulWidget {
  final FeedComment data;
  final VoidCallback? onReply;
  final VoidCallback? onTranslate;
  final VoidCallback? onMore;

  const ItemFeedComment({
    super.key,
    required this.data,
    this.onReply,
    this.onTranslate,
    this.onMore,
  });

  @override
  State<ItemFeedComment> createState() => _ItemFeedCommentState();
}

class _ItemFeedCommentState extends State<ItemFeedComment> with ColorMixin {
  late FeedComment data = widget.data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: light),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InAppUserBuilder(
        id: data.publisher,
        builder: (context, user) {
          return InAppRow(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InAppUserAvatar(url: user.photo, size: 40),
              Expanded(
                child: InAppColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InAppRow(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: InAppText(
                            user.name,
                            maxLines: 5,
                            style: TextStyle(
                              color: dark,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        _buildIcon(InAppIcons.comment.regular, widget.onReply),
                        _buildIcon(
                          InAppIcons.translate.regular,
                          widget.onTranslate,
                        ),
                        _buildIcon(InAppIcons.moreX.regular, widget.onMore),
                      ],
                    ),
                    InAppText(
                      data.content,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: dark, fontSize: 14, height: 1.5),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: InAppText(
                        data.timeMills.realtime,
                        style: TextStyle(color: grey, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIcon(Object? icon, VoidCallback? onTap) {
    return InAppGesture(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(color: dark.t05, shape: BoxShape.circle),
        alignment: Alignment.center,
        padding: EdgeInsets.all(6),
        child: FittedBox(child: InAppIcon(icon, color: grey)),
      ),
    );
  }
}
