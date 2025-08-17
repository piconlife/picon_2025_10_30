import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/base/countable_response.dart';
import '../../../../data/models/feed_comment.dart';
import '../../../../data/use_cases/feed_comment/count.dart';
import '../../../../data/use_cases/feed_comment/create.dart';
import '../../../../data/use_cases/feed_comment/delete.dart';
import '../../../../data/use_cases/feed_comment/get_by_pagination.dart';

class FeedCommentCubit extends Cubit<CountableResponse<FeedComment>> {
  final String reference;

  FeedCommentCubit(this.reference) : super(CountableResponse(count: 0));

  void count() {
    if (reference.isEmpty) return;
    GetFeedCommentsCountUseCase.i(reference).then((value) {
      emit(state.copy(count: value.data));
    });
  }

  void fetch({int initialSize = 30, int fetchingSize = 15}) {
    if (reference.isEmpty) return;
    emit(state.copy(status: Status.loading));
    GetFeedCommentsByPaginationUseCase.i(
      referencePath: reference,
      initialSize: initialSize,
      fetchingSize: fetchingSize,
      snapshot: state.snapshot,
    ).then(_attach).catchError((error, stackTrace) {
      emit(state.copy(status: Status.failure));
    });
  }

  void update(FeedComment value) {
    if (reference.isEmpty) return;
    emit(state.copy(data: value, requestCode: 202));
  }

  void _attach(Response<FeedComment> response) {
    emit(
      state.copy(
        status: response.status,
        snapshot: response.snapshot,
        result: response.result,
        requestCode: 0,
      ),
    );
  }

  void create(FeedComment data) {
    if (reference.isEmpty) return;
    CreateFeedCommentUseCase.i(data).then((value) {
      if (value.isSuccessful) {
        emit(state.copy(result: state.result..insert(0, data)));
      }
      return value;
    });
  }

  void delete(String id) {
    if (reference.isEmpty) return;
    DeleteFeedCommentUseCase.i(id: id, path: reference).then((value) {
      if (value.isSuccessful) {
        emit(
          state.copy(
            result: state.result
              ..removeWhere((e) {
                return e.id == id;
              }),
          ),
        );
      }
      return value;
    });
  }
}
