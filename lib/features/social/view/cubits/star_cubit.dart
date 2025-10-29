import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/enums/privacy.dart';
import '../../../../data/models/feed_star.dart';
import '../../../../data/use_cases/feed_like/delete.dart';
import '../../../../data/use_cases/feed_star/count.dart';
import '../../../../data/use_cases/feed_star/create.dart';
import '../../../../data/use_cases/feed_star/get_by_id.dart';
import '../../../../data/use_cases/feed_star/get_by_pagination.dart';

class FeedStarCubit extends DataCubit<FeedStar> {
  final String path;

  FeedStarCubit(this.path, {int? initialCount})
    : super(Response(count: initialCount));

  @override
  FeedStar? createNewObject(Object? args) {
    if (path.isEmpty) return null;
    return FeedStar.create(
      privacy: args is Privacy ? args : null,
      parentPath: path,
    );
  }

  @override
  Future<bool> onCreateByData(FeedStar data) {
    return CreateFeedStarUseCase.i(data).then((value) {
      return value.isSuccessful;
    });
  }

  @override
  Future<bool> onDeleteByData(FeedStar data) {
    return DeleteFeedLikeUseCase.i(path, data.id).then((value) {
      return value.isSuccessful;
    });
  }

  @override
  void count() {
    if (path.isEmpty || state.count > 0) return;
    GetFeedStarsCountUseCase.i(path).then((value) {
      emit(state.copyWith(count: value.data));
    });
  }

  void fetchByMe() {
    if (path.isEmpty) return;
    GetFeedStarUseCase.i(path, UserHelper.uid).then((value) {
      emit(
        state.copyWith(resultByMe: value.data != null ? [value.data!] : null),
      );
    });
  }

  @override
  void fetch({int initialSize = 30, int fetchingSize = 15}) {
    if (path.isEmpty) return;
    emit(state.copyWith(status: Status.loading));
    GetFeedStarsByPaginationUseCase.i(
      path,
      initialSize: initialSize,
      fetchingSize: fetchingSize,
      snapshot: state.snapshot,
    ).then(_attach).catchError((error, stackTrace) {
      emit(state.copyWith(status: Status.failure));
    });
  }

  @override
  void refresh({int initialSize = 30, int fetchingSize = 15}) {
    if (path.isEmpty) return;
    emit(state.copyWith(status: Status.loading));
    GetFeedStarsByPaginationUseCase.i(
      path,
      initialSize: initialSize,
      fetchingSize: fetchingSize,
    ).then((response) {
      emit(response.selection((e) => e.id));
    });
  }

  void _attach(Response<FeedStar> response) {
    emit(
      state.copyWith(
        status: response.status,
        snapshot: response.snapshot,
        result: response.result,
      ),
    );
  }
}
