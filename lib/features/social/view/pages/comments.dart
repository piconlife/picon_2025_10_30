import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/helpers/user.dart';
import '../../../../app/res/icons.dart';
import '../../../../data/constants/paths.dart';
import '../../../../data/enums/comment_type.dart';
import '../../../../data/models/comment.dart';
import '../../../../data/models/content.dart';
import '../../../../data/models/user.dart';
import '../../../../packages/data_management.dart' show DataFieldValue;
import '../../../../roots/extensions/time_ago.dart';
import '../../../../roots/services/path_provider.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/body.dart';
import '../../../../roots/widgets/column.dart';
import '../../../../roots/widgets/error.dart';
import '../../../../roots/widgets/row.dart';
import '../../../../roots/widgets/scaffold_shimmer.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../roots/widgets/user_avatar.dart';
import '../../../../roots/widgets/user_builder.dart';
import '../../../../routes/paths.dart';
import '../../../user/view/pages/profile.dart';
import '../../utils/text_span_parser.dart';
import '../cubits/comment_cubit.dart';
import '../templates/nullable_body.dart';
import '../widgets/comment_field.dart';
import '../widgets/emotion_button.dart';

const _themeCommentBox = Color(0xFFF0F2F5);

class CommentsPage extends StatefulWidget {
  final Object? args;
  final ContentModel? content;

  const CommentsPage({super.key, this.args, this.content});

  static Future<void> open(BuildContext context, ContentModel content) async {
    await context.open(
      Routes.comments,
      args: {
        "$ContentModel": content,
        "$CommentCubit": context.read<CommentCubit>(),
      },
    );
  }

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> with ColorMixin {
  late final cubit = context.read<CommentCubit>();
  late final content = widget.content;
  late final textSpanParser = TextSpanParser(
    tagStyle: _tagStyle,
    onTagTap: _tagHandle,
  );

  bool _isLoading = false;

  bool get isContentMode => content != null;

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
    setState(() => _isLoading = true);
    await cubit.refresh();
    setState(() => _isLoading = false);
  }

  void _sendComment(String text) {
    if (!isContentMode) return;
    if (text.isEmpty) return;
    final id = KeyGenerator.generateKey();
    final parentPath = content?.contentPath ?? '';
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
    cubit.create(model, index: null);
  }

  void _react(CommentModel data, Emotions? emotion) {
    _like(data, emotion?.name);
  }

  void _like(CommentModel data, String? react) {
    final old = data.reactsUidAndSymbol[UserHelper.uid];
    final isOld = old != null;
    final isNew = react != null;
    final newSymbol = '${UserHelper.uid}:$react';
    final oldSymbol = '${UserHelper.uid}:$old';

    cubit.update(
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
    final text = await context.showEditor(text: data.text);
    cubit.update(
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
    cubit.delete(data);
  }

  @override
  Widget build(BuildContext context) {
    return InAppBody(
      unfocusMode: true,
      theme: ThemeType.secondary,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: InAppAppbar(titleText: "Comments"),
        body: InAppColumn(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshComments,
                child: BlocBuilder<CommentCubit, Response<CommentModel>>(
                  builder: (context, state) {
                    final comments = state.result;
                    if (!isContentMode) {
                      return Center(
                        child: InAppError(
                          type: InAppErrorType.nullable,
                          titleText: InAppErrorProperties.all(
                            "Something went wrong!",
                          ),
                        ),
                      );
                    }
                    if (comments.isEmpty && state.isLoading) {
                      return InAppScaffoldShimmer();
                    }
                    if (comments.isEmpty) {
                      return Center(
                        child: InAppNullableBody(
                          header: "No comments yet",
                          icon: InAppIcons.comment.regular,
                          iconColor: dark.t10,
                          iconSize: 100,
                          body: "Be the first to comment.",
                        ),
                      );
                    }
                    return ListView.builder(
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
            CommentField(loading: _isLoading, onSubmitText: _sendComment),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String id, String? url) {
    return InAppUserAvatar(url: url, size: 40);
  }

  Widget _buildAuthor(String id, String? name) {
    return InAppText(
      name,
      style: TextStyle(color: dark, fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildTimelineText(String text) {
    return InAppText(
      text,
      style: TextStyle(color: dark, fontSize: 12, fontWeight: FontWeight.w600),
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
                      color: _themeCommentBox,
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
                            color: dark,
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
