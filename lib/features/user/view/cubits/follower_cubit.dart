import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_follower.dart';
import '../../../../data/use_cases/user_follower/count.dart';
import '../../../../data/use_cases/user_follower/get.dart';

class UserFollowerCubit extends Cubit<Response<UserFollower>> {
  final String? uid;

  UserFollowerCubit([String? uid])
    : uid = uid ?? UserHelper.uid,
      super(Response());

  void count() {
    GetUserFollowerCountUseCase.i(uid).then((value) {
      emit(state.copyWith(count: value.data));
    });
  }

  void fetch({int initialSize = 30, int fetchingSize = 15}) {
    emit(state.copyWith(status: Status.loading));
    GetUserFollowersUseCase.i().then(_attach).catchError((error, stackTrace) {
      emit(state.copyWith(status: Status.failure));
    });
  }

  void _attach(Response<UserFollower> response) {
    emit(
      state.copyWith(
        status: response.status,
        snapshot: response.snapshot,
        result: response.result,
        requestCode: 0,
      ),
    );
  }
}
