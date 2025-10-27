import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_video.dart';
import '../../../../data/use_cases/user_video/get_by_pagination.dart';

class UserVideoCubit extends DataCubit<UserVideo> {
  final String uid;

  UserVideoCubit([String? uid]) : uid = uid ?? UserHelper.uid;

  @override
  void fetch({int initialSize = 10, int fetchingSize = 5}) {
    emit(state.copyWith(status: Status.loading));
    GetUserVideosByPaginationUseCase.i(
      uid: uid,
      initialSize: initialSize,
      fetchingSize: fetchingSize,
      snapshot: state.snapshot,
    ).then(_attach).catchError((error, st) {
      emit(state.copyWith(status: Status.failure));
    });
  }

  void update(UserVideo value) {
    final index = state.result.indexOf(value);
    if (index >= 0) {
      state.result.removeAt(index);
      state.result.insert(index, value);
      emit(state.copyWith(data: value, result: state.result, requestCode: 202));
    }
  }

  void _attach(Response<UserVideo> response) {
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
