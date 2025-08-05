import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../data/models/feed.dart';
import '../../../../data/use_cases/feed/get_verified.dart';

class VerifiedFeedCubit extends Cubit<Response<Feed>> {
  VerifiedFeedCubit() : super(Response());

  void fetch({int initialSize = 10, int fetchingSize = 5}) {
    emit(state.copy(status: Status.loading));
    GetVerifiedFeedsByPaginationUseCase.i(
      initialSize: initialSize,
      fetchingSize: fetchingSize,
      snapshot: state.snapshot,
    ).then(_attach).catchError((e, st) {
      emit(state.copy(status: Status.failure));
    });
  }

  void update(Feed value) {
    final index = state.result.indexOf(value);
    if (index >= 0) {
      state.result.removeAt(index);
      state.result.insert(index, value);
      emit(state.copy(data: value, result: state.result, requestCode: 202));
    }
  }

  void _attach(Response<Feed> response) {
    emit(
      state.copy(
        status: response.status,
        snapshot: response.snapshot,
        result: state.result..addAll(response.result),
        requestCode: 0,
      ),
    );
  }
}
