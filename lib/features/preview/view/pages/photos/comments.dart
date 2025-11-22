import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_andomie/extensions/string.dart';

import '../../../../../app/res/icons.dart';
import '../../../../../app/styles/fonts.dart';
import '../../../../../data/models/comment.dart';
import '../../../../../data/models/content.dart';
import '../../../../../roots/widgets/icon_button.dart';
import '../../../../../roots/widgets/text.dart';
import '../../../../../roots/widgets/user_avatar.dart';
import '../../../../../roots/widgets/user_builder.dart';

class PhotoCommentsView extends StatefulWidget {
  final ContentModel photo;
  final ValueChanged<int> onChangedPageType;

  const PhotoCommentsView({
    super.key,
    required this.photo,
    required this.onChangedPageType,
  });

  @override
  State<PhotoCommentsView> createState() => _PhotoCommentsViewState();
}

class _PhotoCommentsViewState extends State<PhotoCommentsView> {
  List<Comment> comments = [];

  Future<void> _refresh() async {}

  void _close() => widget.onChangedPageType(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildToolbar(context), Expanded(child: _buildBody(context))],
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return AppBar(
      primary: true,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Colors.transparent,
      ),
      toolbarHeight: kToolbarHeight + 8,
      title: Container(
        padding: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: context.lightAsFixed.t10, width: 1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: InAppUserBuilder(
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
                        padding: EdgeInsets.symmetric(
                          horizontal: context.mediumSpace,
                        ),
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
            ),
            InAppIconButton(
              onTap: _close,
              InAppIcons.close.regular,
              iconColor: context.lightAsFixed,
              primaryColor: context.lightAsFixed.t05,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar3(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.lightAsFixed.t10, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: InAppUserBuilder(
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
                      padding: EdgeInsets.symmetric(
                        horizontal: context.mediumSpace,
                      ),
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
          ),
          InAppIconButton(
            onTap: _close,
            InAppIcons.close.regular,
            iconColor: context.lightAsFixed,
            primaryColor: context.lightAsFixed.t05,
          ),
        ],
      ),
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
