import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/string.dart';
import 'package:flutter_androssy_kits/flutter_androssy_kits.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../../app/res/icons.dart';
import '../../../../../app/styles/fonts.dart';
import '../../../../../data/models/comment.dart';
import '../../../../../data/models/photo.dart';
import '../../../../../roots/widgets/icon_button.dart';
import '../../../../../roots/widgets/text.dart';
import '../../../../../roots/widgets/user_avatar.dart';
import '../../../../../roots/widgets/user_builder.dart';

class PhotoCommentsView extends StatefulWidget {
  final Photo photo;

  const PhotoCommentsView({super.key, required this.photo});

  @override
  State<PhotoCommentsView> createState() => _PhotoCommentsViewState();
}

class _PhotoCommentsViewState extends State<PhotoCommentsView> {
  List<Comment> comments = [];

  Future<void> _refresh() async {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildToolbar(context), Expanded(child: _buildBody(context))],
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return AndrossyToolbar(
      backgroundColor: Colors.transparent,
      elevationColor: context.lightAsFixed.t10,
      leading: InAppUserBuilder(
        id: widget.photo.publisherId,
        builder: (context, user) {
          return Row(
            children: [
              InAppUserAvatar(
                url: user.photo,
                border: 2,
                borderColor: context.lightAsFixed.t25,
                innerBorder: 2,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.mediumSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InAppText(
                      user.name,
                      style: TextStyle(
                        color: context.lightAsFixed,
                        fontSize: context.mediumFontSize,
                        fontFamily: InAppFonts.secondary,
                        fontWeight: context.semiBoldFontWeight,
                      ),
                    ),
                    InAppText(
                      user.onlineStatus,
                      style: TextStyle(
                        color: context.lightAsFixed.t75,
                        fontWeight: context.lightFontWeight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        InAppIconButton(
          onTap: context.close,
          InAppIcons.close.regular,
          iconColor: context.lightAsFixed,
          primaryColor: context.lightAsFixed.t05,
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        itemCount: comments.length,
        itemBuilder: _buildListItem,
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    final comment = comments.elementAt(index);
    return ListTile(
      title: Text(
        comment.description.use,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
