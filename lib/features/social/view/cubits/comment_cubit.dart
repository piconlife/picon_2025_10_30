import 'package:flutter/material.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../data/models/feed_comment.dart';

class CommentCubit extends DataCubit<CommentModel> {
  final String path;

  CommentCubit(BuildContext context, this.path, {int? initialCount})
    : super(context, Response(count: initialCount));
  //
  // @override
  // void count() {
  //   if (path.isEmpty || state.count > 0) return;
  //   GetFeedCommentsCountUseCase.i(path).then((value) {
  //     emit(state.copyWith(count: value.data));
  //   });
  // }
  //
  // @override
  // void fetch({int initialSize = 30, int fetchingSize = 15}) {
  //   if (path.isEmpty) return;
  //   emit(state.copyWith(status: Status.loading));
  //   GetFeedCommentsByPaginationUseCase.i(
  //     referencePath: path,
  //     initialSize: initialSize,
  //     fetchingSize: fetchingSize,
  //     snapshot: state.snapshot,
  //   ).then(_attach).catchError((error, stackTrace) {
  //     emit(state.copyWith(status: Status.failure));
  //   });
  // }
  //
  // void update(CommentModel value) {
  //   if (path.isEmpty) return;
  //   emit(state.copyWith(data: value, requestCode: 202));
  // }
  //
  // void _attach(Response<CommentModel> response) {
  //   emit(
  //     state.copyWith(
  //       status: response.status,
  //       snapshot: response.snapshot,
  //       result: response.result,
  //       requestCode: 0,
  //     ),
  //   );
  // }
  //
  // @override
  // Future<bool> create(CommentModel data) async {
  //   if (path.isEmpty) return false;
  //   return CreateFeedCommentUseCase.i(data).then((value) {
  //     if (value.isSuccessful) {
  //       emit(state.copyWith(result: state.result..insert(0, data)));
  //     }
  //     return value.isSuccessful;
  //   });
  // }
  //
  // @override
  // Future<bool> deleteById(String id) async {
  //   if (path.isEmpty) return false;
  //   return DeleteFeedCommentUseCase.i(id: id, path: path).then((value) {
  //     if (value.isSuccessful) {
  //       emit(
  //         state.copyWith(
  //           result:
  //               state.result..removeWhere((e) {
  //                 return e.id == id;
  //               }),
  //         ),
  //       );
  //     }
  //     return value.isSuccessful;
  //   });
  // }
}
