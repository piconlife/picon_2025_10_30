import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_andomie/extensions/string.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../../app/base/data_cubit.dart';
import '../../../../../app/res/icons.dart';
import '../../../../../app/styles/fonts.dart';
import '../../../../../app/widgets/comment_input_field.dart';
import '../../../../../data/models/content.dart';
import '../../../../../data/models/comment.dart';
import '../../../../../roots/widgets/bottom_bar.dart';
import '../../../../../roots/widgets/icon_button.dart';
import '../../../../../roots/widgets/text.dart';
import '../../../../../roots/widgets/user_avatar.dart';
import '../../../../../roots/widgets/user_builder.dart';
import '../../../../social/view/cubits/comment_cubit.dart';

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
  late final cubit = DataCubit.of<CommentCubit>(context);

  Future<void> _refresh() async {}

  void _close() => widget.onChangedPageType(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildToolbar(context),
        Expanded(child: _buildBody(context)),
        _buildBottomBar(context),
      ],
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

  Widget _buildBottomBar(BuildContext context) {
    return InAppBottomBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
        child: CommentInputField(
          onChanged: (v){},
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: BlocBuilder<CommentCubit, Response<CommentModel>>(
        builder: (context, state) {
          final comments = state.result;
          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final data = comments.elementAtOrNull(index);
              if (data == null) return _buildPlaceholder();
              return _buildListItem(context, index, data);
            },
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    return SizedBox();
  }

  Widget _buildListItem(BuildContext context, int index, CommentModel data) {
    return ListTile(
      title: Text(data.content.use, style: TextStyle(color: Colors.white)),
    );
  }
}
