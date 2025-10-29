import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../data/models/feed_comment.dart';
import '../../../../data/use_cases/feed_comment/count.dart';
import '../../../../data/use_cases/feed_comment/create.dart';
import '../../../../data/use_cases/feed_comment/delete.dart';
import '../../../../data/use_cases/feed_comment/get_by_pagination.dart';

class FeedCommentCubit extends DataCubit<FeedComment> {
  final String path;

  FeedCommentCubit(this.path, {int? initialCount})
    : super(Response(count: initialCount));

  @override
  void count() {
    if (path.isEmpty || state.count > 0) return;
    GetFeedCommentsCountUseCase.i(path).then((value) {
      emit(state.copyWith(count: value.data));
    });
  }

  @override
  void fetch({int initialSize = 30, int fetchingSize = 15}) {
    if (path.isEmpty) return;
    emit(state.copyWith(status: Status.loading));
    GetFeedCommentsByPaginationUseCase.i(
      referencePath: path,
      initialSize: initialSize,
      fetchingSize: fetchingSize,
      snapshot: state.snapshot,
    ).then(_attach).catchError((error, stackTrace) {
      emit(state.copyWith(status: Status.failure));
    });
  }

  void update(FeedComment value) {
    if (path.isEmpty) return;
    emit(state.copyWith(data: value, requestCode: 202));
  }

  void _attach(Response<FeedComment> response) {
    emit(
      state.copyWith(
        status: response.status,
        snapshot: response.snapshot,
        result: response.result,
        requestCode: 0,
      ),
    );
  }

  @override
  Future<bool> onCreateByData(FeedComment data) async {
    if (path.isEmpty) return false;
    return CreateFeedCommentUseCase.i(data).then((value) {
      if (value.isSuccessful) {
        emit(state.copyWith(result: state.result..insert(0, data)));
      }
      return value.isSuccessful;
    });
  }

  @override
  Future<bool> onDeleteById(String id) async {
    if (path.isEmpty) return false;
    return DeleteFeedCommentUseCase.i(id: id, path: path).then((value) {
      if (value.isSuccessful) {
        emit(
          state.copyWith(
            result:
                state.result..removeWhere((e) {
                  return e.id == id;
                }),
          ),
        );
      }
      return value.isSuccessful;
    });
  }
}
