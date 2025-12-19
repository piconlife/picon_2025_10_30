import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:data_management/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_andomie/utils/key_generator.dart';
import 'package:flutter_andomie/utils/number.dart';
import 'package:flutter_andomie/utils/path_replacer.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';
import 'package:picon/roots/widgets/gesture.dart';

import '../../../../../app/helpers/user.dart';
import '../../../../../app/res/icons.dart';
import '../../../../../app/styles/fonts.dart';
import '../../../../../data/constants/paths.dart';
import '../../../../../data/enums/comment_type.dart';
import '../../../../../data/models/comment.dart';
import '../../../../../data/models/content.dart';
import '../../../../../data/models/user.dart';
import '../../../../../roots/extensions/time_ago.dart';
import '../../../../../roots/services/path_provider.dart';
import '../../../../../roots/widgets/bottom_bar.dart';
import '../../../../../roots/widgets/column.dart';
import '../../../../../roots/widgets/error.dart';
import '../../../../../roots/widgets/icon.dart';
import '../../../../../roots/widgets/icon_button.dart';
import '../../../../../roots/widgets/row.dart';
import '../../../../../roots/widgets/scaffold_shimmer.dart';
import '../../../../../roots/widgets/text.dart';
import '../../../../../roots/widgets/user_avatar.dart';
import '../../../../../roots/widgets/user_builder.dart';
import '../../../../social/utils/text_span_parser.dart';
import '../../../../social/view/cubits/comment_cubit.dart';
import '../../../../social/view/templates/nullable_body.dart';
import '../../../../social/view/widgets/emotion_button.dart';
import '../../../../user/view/pages/profile.dart';

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

class _PhotoCommentsViewState extends State<PhotoCommentsView> with ColorMixin {
  final editor = TextEditingController();
  final _controller = ScrollController();

  late final textSpanParser = TextSpanParser(
    tagStyle: _tagStyle,
    onTagTap: _tagHandle,
  );

  late String? path = widget.photo.contentPath;

  CommentCubit? cubit;

  bool get isContentMode => path.isNotEmpty;

  void _init() {
    final path = this.path ?? '';
    if (path.isEmpty) {
      return;
    }
    cubit = CommentCubit(context, path)
      ..load(initialSize: 50, fetchingSize: 25);
  }

  TextStyle _tagStyle(String sign) {
    if (sign == '@') return TextStyle(color: dark, fontWeight: FontWeight.bold);
    return TextStyle(color: blue);
  }

  void _tagHandle(
    String sign,
    String tag, [
    CommentModel? data,
    UserModel? user,
  ]) {
    if (sign == '@' && (user?.id ?? '').isNotEmpty) {
      UserProfilePage.open(context, uid: user?.id, data: user);
      return;
    }
  }

  Future<void> _refreshComments() async {
    if (cubit == null) return;
    await cubit!.refresh();
  }

  bool hasMore = true;

  Future<void> loadMore() async {
    if (cubit == null) return;
    final x = await cubit!.load(fetchingSize: 25, initialSize: 50);
    if (x.isNullable) hasMore = false;
  }

  void _initPagination() {
    bool isLoading = false;
    _controller.addListener(() async {
      if (_controller.position.pixels >=
              _controller.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMore) {
        isLoading = true;
        await loadMore();
        isLoading = false;
      }
    });
  }

  void _sendComment(String text) {
    if (!isContentMode || cubit == null) return;
    if (text.isEmpty) return;
    final parentPath = this.path ?? '';
    final id = KeyGenerator.generateKey();
    final path = PathReplacer.replaceByIterable(
      PathProvider.generatePath(Paths.refComments, id),
      [parentPath],
    );
    final model = CommentModel.create(
      id: id,
      text: text,
      path: path,
      parentPath: parentPath,
    );
    cubit!.create(model, index: null);
  }

  void _react(CommentModel data, Emotions? emotion) {
    _like(data, emotion?.name);
  }

  void _like(CommentModel data, String? react) {
    if (cubit == null) return;
    final old = data.reactsUidAndSymbol[UserHelper.uid];
    final isOld = old != null;
    final isNew = react != null;
    final newSymbol = '${UserHelper.uid}:$react';
    final oldSymbol = '${UserHelper.uid}:$old';

    cubit!.update(
      data,
      {
        CommentKeys.i.reacts:
            isOld && !isNew
                ? DataFieldValue.arrayRemove([oldSymbol])
                : DataFieldValue.arrayUnion([newSymbol]),
      },
      deletes: {
        if (isNew && isOld)
          CommentKeys.i.reacts: DataFieldValue.arrayRemove([oldSymbol]),
      },
      modifier: (a, b) {
        if (b) return a;
        final reacts = a.reacts ?? [];
        return a
          ..reacts =
              isOld && isNew
                  ? (reacts
                    ..remove(oldSymbol)
                    ..add(newSymbol))
                  : isOld
                  ? (reacts..remove(oldSymbol))
                  : (reacts..add(newSymbol));
      },
    );
  }

  void _more(CommentModel data) async {
    final index = await context.showOptions(
      title: "Options",
      options: ['Edit', "Delete"],
      initialIndex: -1,
    );
    if (index == 0) {
      _edit(data);
      return;
    }
    if (index == 1) {
      _delete(data);
      return;
    }
  }

  void _edit(CommentModel data) async {
    if (cubit == null) return;
    final text = await context.showEditor(text: data.text);
    cubit!.update(
      data,
      {
        CommentKeys.i.text:
            (text ?? '').isEmpty ? DataFieldValue.delete() : text,
      },
      modifier: (old, updated) {
        return old..text = text;
      },
    );
  }

  void _delete(CommentModel data) {
    if (cubit == null) return;
    cubit!.delete(data);
  }

  void _close() => widget.onChangedPageType(0);

  @override
  void initState() {
    _init();
    _initPagination();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PhotoCommentsView oldWidget) {
    if (widget.photo != oldWidget.photo) {
      path = widget.photo.contentPath;
      _init();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    editor.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty || cubit == null) {
      return _buildLayout(false);
    }
    return BlocProvider.value(value: cubit!, child: _buildLayout(true));
  }

  Widget _buildLayout(bool cubitApplied) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.25)),
    );
    return Column(
      children: [
        AppBar(
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
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshComments,
            child: BlocBuilder<CommentCubit, Response<CommentModel>>(
              builder: (context, state) {
                final comments = state.result;
                if (!isContentMode || !cubitApplied) {
                  return Center(
                    child: InAppError(
                      type: InAppErrorType.nullable,
                      iconColor: InAppErrorProperties.all(lightAsFixed.t30),
                      titleText: InAppErrorProperties.all(
                        "Something went wrong!",
                      ),
                      titleTextStyle: InAppErrorProperties.all(
                        TextStyle(color: lightAsFixed.t50),
                      ),
                    ),
                  );
                }
                if (comments.isEmpty && state.isLoading) {
                  return InAppScaffoldShimmer(background: Colors.transparent);
                }
                if (comments.isEmpty) {
                  return Center(
                    child: InAppNullableBody(
                      header: "No comments yet",
                      icon: InAppIcons.comment.regular,
                      iconColor: lightAsFixed.t30,
                      iconSize: 100,
                      body: "Be the first to comment.",
                      bodyStyle: TextStyle(
                        color: lightAsFixed.withValues(alpha: 0.5),
                      ),
                      headerStyle: TextStyle(color: lightAsFixed.t75),
                    ),
                  );
                }
                return ListView.builder(
                  controller: _controller,
                  padding: EdgeInsets.only(bottom: 24),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final data = comments[index];
                    return _buildComment(data, index);
                  },
                );
              },
            ),
          ),
        ),
        if (cubitApplied)
          InAppBottomBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              margin: EdgeInsets.only(left: 24, right: 24, bottom: 8),
              child: TextField(
                controller: editor,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border.copyWith(
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: .5),
                    ),
                  ),
                  hintText: "Type here...",
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  suffixIcon: ValueListenableBuilder(
                    valueListenable: editor,
                    builder: (context, value, child) {
                      final text = value.text.trim();
                      if (text.isEmpty) return SizedBox();
                      return InAppGesture(
                        onTap: () {
                          _sendComment(text);
                          editor.clear();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(right: 4),
                          child: InAppIcon(
                            InAppIcons.send.solid,
                            color: primary,
                          ),
                        ),
                      );
                    },
                  ),
                  suffixIconConstraints: BoxConstraints(
                    maxHeight: 40,
                    minHeight: 40,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAvatar(String id, String? url) {
    return InAppUserAvatar(
      url: url,
      size: 40,
      backgroundColor: lightAsFixed.withValues(alpha: 0.05),
    );
  }

  Widget _buildAuthor(String id, String? name) {
    return InAppText(
      name,
      style: TextStyle(
        color: lightAsFixed,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTimelineText(String text) {
    return InAppText(
      text,
      style: TextStyle(
        color: lightAsFixed.withValues(alpha: 0.75),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTimeline(CommentModel data) {
    final timeAgo = data.dateTime.toTimeAgoShort(nowText: 'Now');
    return Container(
      margin: EdgeInsets.only(left: 12, top: 2),
      child: InAppRow(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          _buildTimelineText(timeAgo),
          EmotionButton(
            initial: data.emotionByMe,
            animation: EmotionAnimation.gif,
            darkTheme: true,
            onTap: (emotion) => _react(data, emotion),
            onChanged: (emotion) => _react(data, emotion),
            builder: (context, emotion) {
              return InAppRow(
                spacing: 4,
                children: [
                  if (emotion != null) Emotion(emotion, size: 14),
                  _buildTimelineText(emotion?.label ?? "Like"),
                ],
              );
            },
          ),
          // _buildTimelineText("Reply"),
          Spacer(),
          if (data.reactCount > 0)
            InAppRow(
              spacing: 4,
              children: [
                EmotionStack(emotions: data.emotions, iconSize: 14),
                _buildTimelineText(data.reactCount.text),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildComment(CommentModel data, int index) {
    return InAppUserBuilder(
      id: data.publisher,
      builder: (context, user) {
        return switch (data.type) {
          CommentType.none ||
          CommentType.text => _buildCommentText(data, user, index),
          CommentType.emoji => _buildCommentEmoji(data, user, index),
          CommentType.gif => _buildCommentGif(data, user, index),
          CommentType.photo => _buildCommentPhoto(data, user, index),
          CommentType.video => _buildCommentPhoto(data, user, index),
        };
      },
    );
  }

  Widget _buildCommentText(CommentModel data, UserModel user, int index) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InAppRow(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildAvatar(user.id, user.photo),
          Flexible(
            child: InAppColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onLongPress: () => _more(data),
                  child: Container(
                    decoration: BoxDecoration(
                      color: lightAsFixed.withValues(alpha: 0.02),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: InAppColumn(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAuthor(user.id, user.name),
                        Text.rich(
                          textSpanParser.parseAsTextSpan(
                            data.text,
                            onTagTap: (a, b) => _tagHandle(a, b, data, user),
                          ),
                          style: TextStyle(
                            color: lightAsFixed.withValues(alpha: 0.75),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildTimeline(data),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentEmoji(CommentModel data, UserModel user, int index) {
    return SizedBox();
  }

  Widget _buildCommentGif(CommentModel data, UserModel user, int index) {
    return SizedBox();
  }

  Widget _buildCommentPhoto(CommentModel data, UserModel user, int index) {
    return SizedBox();
  }

  Widget _buildCommentVideo(CommentModel data, UserModel user, int index) {
    return SizedBox();
  }
}
