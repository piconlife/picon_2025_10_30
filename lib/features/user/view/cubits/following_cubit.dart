import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/base/countable_response.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_following.dart';
import '../../../../data/use_cases/user_following/create.dart';
import '../../../../data/use_cases/user_following/delete.dart';
import '../../../../data/use_cases/user_following/get.dart';

class UserFollowingCubit extends Cubit<CountableResponse<UserFollowing>> {
  final String uid;

  UserFollowingCubit([String? uid])
    : uid = uid ?? UserHelper.uid,
      super(CountableResponse(count: 0));

  void fetch({int initialSize = 30, int fetchingSize = 15}) {
    if (uid.isEmpty) return;
    emit(state.copy(status: Status.loading));
    GetUserFollowingsUseCase.i().then(_attach).catchError((error, stackTrace) {
      emit(state.copy(status: Status.failure));
    });
  }

  void _attach(Response<UserFollowing> response) {
    emit(
      state.copy(
        status: response.status,
        snapshot: response.snapshot,
        result: response.result,
        requestCode: 0,
      ),
    );
  }

  UserFollowing? following(String uid) => state.elementOf((e) => e.id == uid);

  void toggle(String uid, [UserFollowing? data]) {
    if (data != null) {
      unfollow(data);
    } else {
      follow(uid);
    }
  }

  void follow(String uid) {
    if (uid.isEmpty) return;
    final data = UserFollowing.create(uid: uid);
    emit(
      state.copy(result: state.result..insert(0, data), count: state.count + 1),
    );
    CreateUserFollowingUseCase.i(data).then((value) {
      if (!value.isSuccessful) {
        emit(state.copy(result: state.result..remove(data)));
      }
      return value;
    });
  }

  void unfollow(UserFollowing data) {
    if (data.id.isEmpty) return;
    emit(
      state.copy(result: state.result..remove(data), count: state.count - 1),
    );
    DeleteUserFollowingUseCase.i(data.id).then((value) {
      if (!value.isSuccessful) {
        emit(state.copy(result: state.result..insert(0, data)));
      }
      return value;
    });
  }
}
