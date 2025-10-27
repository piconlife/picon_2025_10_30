import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../data/models/feed.dart';
import '../../../../data/use_cases/feed/get_stars.dart';

class FeedHomeCubit extends DataCubit<Feed> {
  @override
  void fetch({int initialSize = 10, int fetchingSize = 5}) {
    emit(state.copyWith(status: Status.loading));
    GetStarFeedsByPaginationUseCase.i(
      initialSize: initialSize,
      fetchingSize: fetchingSize,
      snapshot: state.snapshot,
    ).then(_attach).catchError((e, st) {
      emit(state.copyWith(status: Status.failure));
    });
  }

  void _attach(Response<Feed> response) {
    emit(
      state.copyWith(
        status: response.status,
        snapshot: response.snapshot,
        result: state.result..addAll(response.result),
        requestCode: 0,
      ),
    );
  }
}
