import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/base/countable_response.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/enums/like_type.dart';
import '../../../../data/models/feed_like.dart';
import '../../../../data/use_cases/feed_like/counter.dart';
import '../../../../data/use_cases/feed_like/create.dart';
import '../../../../data/use_cases/feed_like/delete.dart';
import '../../../../data/use_cases/feed_like/get_by_id.dart';
import '../../../../data/use_cases/feed_like/get_by_pagination.dart';

class FeedLikeCubit extends Cubit<CountableResponse<FeedLike>> {
  final String reference;

  FeedLikeCubit(this.reference) : super(CountableResponse(count: 0));

  void count() {
    if (reference.isEmpty) return;
    ListenFeedLikesCountUseCase.i(reference).listen((value) {
      emit(state.copy(count: value.data));
    });
  }

  void fetchByMe() {
    if (reference.isEmpty) return;
    GetFeedLikeUseCase.i(referencePath: reference, id: UserHelper.uid).then((
      value,
    ) {
      emit(state.copy(resultByMe: value.data != null ? [value.data!] : null));
    });
  }

  void fetch({int initialSize = 30, int fetchingSize = 15}) {
    if (reference.isEmpty) return;
    emit(state.copy(status: Status.loading));
    GetFeedLikesByPaginationUseCase.i(
      referencePath: reference,
      initialSize: initialSize,
      fetchingSize: fetchingSize,
      snapshot: state.snapshot,
    ).then(_attach).catchError((error, stackTrace) {
      emit(state.copy(status: Status.failure));
    });
  }

  void refresh({int initialSize = 30, int fetchingSize = 15}) {
    if (reference.isEmpty) return;
    emit(state.copy(status: Status.loading));
    GetFeedLikesByPaginationUseCase.i(
      referencePath: reference,
      initialSize: initialSize,
      fetchingSize: fetchingSize,
    ).then((response) {
      emit(CountableResponse.from(response, (e) => e.id));
    });
  }

  void update(FeedLike value) {
    if (reference.isEmpty) return;
    emit(state.copy(data: value, requestCode: 202));
  }

  void _attach(Response<FeedLike> response) {
    emit(
      state.copy(
        status: response.status,
        snapshot: response.snapshot,
        result: response.result,
      ),
    );
  }

  void toggle({int? index, LikeType? type}) {
    if (reference.isEmpty) return;
    final data = state.resultByMe.firstOrNull;
    if (data != null) {
      unlike(data);
    } else {
      like(type);
    }
  }

  void like([LikeType? type]) {
    if (reference.isEmpty) return;
    final data = FeedLike.create(type: type);
    emit(
      state.copy(
        // count: state.count + 1,
        result: state.result..insert(0, data),
        resultByMe: state.resultByMe..insert(0, data),
      ),
    );
    CreateFeedLikeUseCase.i(path: reference, data: data).then((value) {
      if (!value.isSuccessful) {
        emit(
          state.copy(
            // count: state.count - 1,
            result: state.result..remove(data),
            resultByMe: state.resultByMe..remove(data),
          ),
        );
      }
      return value;
    });
  }

  void unlike(FeedLike data) {
    if (reference.isEmpty) return;
    emit(
      state.copy(
        // count: state.count - 1,
        result: state.result..remove(data),
        resultByMe: state.resultByMe..remove(data),
      ),
    );
    DeleteFeedLikeUseCase.i(path: reference, id: data.id).then((value) {
      if (!value.isSuccessful) {
        emit(
          state.copy(
            // count: state.count + 1,
            result: state.result..insert(0, data),
            resultByMe: state.resultByMe..insert(0, data),
          ),
        );
      }
      return value;
    });
  }
}
