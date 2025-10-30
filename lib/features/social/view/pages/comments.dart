import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/res/icons.dart';
import '../../../../data/models/feed_comment.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/bottom_bar.dart';
import '../../../../roots/widgets/column.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/row.dart';
import '../../../../roots/widgets/screen.dart';
import '../cubits/comment_cubit.dart';
import '../templates/item_feed_comment.dart';
import '../templates/nullable_body.dart';

class CommentsPage extends StatefulWidget {
  final Object? args;

  const CommentsPage({super.key, this.args});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> with ColorMixin {
  late final cubit = context.read<CommentCubit>()..fetch();
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;

  List<CommentModel> comments = [];

  Future<void> _refreshComments() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
  }

  void _sendComment() {
    final text = _commentController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        comments.add(CommentModel.empty()..content = text);
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InAppScreen(
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
                child:
                    comments.isNotEmpty
                        ? ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            return ItemFeedComment(data: comments[index]);
                          },
                        )
                        : Center(
                          child: InAppNullableBody(
                            header: "No comments yet",
                            icon: InAppIcons.comment.regular,
                            iconColor: dark.t10,
                            iconSize: 100,
                            body: "Be the first to comment.",
                          ),
                        ),
              ),
            ),
            InAppBottomBar(
              backgroundColor: light,
              elevation: 1,
              shadowBlurRadius: 0,
              ignoreSystemPadding: true,
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: InAppRow(
                    children: [
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: "Write a comment...",
                            contentPadding: const EdgeInsets.only(
                              left: 12,
                              right: 8,
                            ),
                            filled: true,
                            fillColor: dark.t05,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ValueListenableBuilder(
                        valueListenable: _commentController,
                        builder: (context, value, child) {
                          final enabled = value.text.isNotEmpty && !_isLoading;
                          return InAppGesture(
                            onTap: _sendComment,
                            child: Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.all(8),
                              child: InAppIcon(
                                InAppIcons.send.regularBold(enabled),
                                color: enabled ? primary : grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
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
