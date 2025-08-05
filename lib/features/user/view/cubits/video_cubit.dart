import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_video.dart';
import '../../../../data/use_cases/user_video/get_by_pagination.dart';

class UserVideoCubit extends Cubit<Response<UserVideo>> {
  final String uid;

  UserVideoCubit([String? uid])
    : uid = uid ?? UserHelper.uid,
      super(Response());

  void fetch({int initialSize = 10, int fetchingSize = 5}) {
    emit(state.copy(status: Status.loading));
    GetUserVideosByPaginationUseCase.i(
      uid: uid,
      initialSize: initialSize,
      fetchingSize: fetchingSize,
      snapshot: state.snapshot,
    ).then(_attach).catchError((error, st) {
      emit(state.copy(status: Status.failure));
    });
  }

  void update(UserVideo value) {
    final index = state.result.indexOf(value);
    if (index >= 0) {
      state.result.removeAt(index);
      state.result.insert(index, value);
      emit(state.copy(data: value, result: state.result, requestCode: 202));
    }
  }

  void _attach(Response<UserVideo> response) {
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
