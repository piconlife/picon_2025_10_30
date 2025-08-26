import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_post.dart';
import '../../../../data/use_cases/user_post/get_photos_by_pagination.dart';

class UserPhotoCubit extends Cubit<Response<UserPost>> {
  final String uid;

  UserPhotoCubit([String? uid])
    : uid = uid ?? UserHelper.uid,
      super(Response());

  void fetch({int initialSize = 10, int fetchingSize = 5}) {
    emit(state.copyWith(status: Status.loading));
    GetUserPhotosByPaginationUseCase.i(
      uid: uid,
      initialSize: initialSize,
      fetchingSize: fetchingSize,
      snapshot: state.snapshot,
    ).then(_attach).catchError((error, st) {
      emit(state.copyWith(status: Status.failure));
    });
  }

  void _attach(Response<UserPost> response) {
    emit(
      state.copyWith(
        status: response.status,
        snapshot: response.snapshot,
        result: state.result..addAll(response.result),
      ),
    );
  }

  void add(UserPost data) {
    if (!data.isPhotoMode) return;
    emit(state.copyWith(result: state.result..insert(0, data)));
  }
}
