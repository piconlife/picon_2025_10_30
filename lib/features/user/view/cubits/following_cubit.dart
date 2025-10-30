import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_following.dart';
import '../../../../data/use_cases/user_following/count.dart';
import '../../../../data/use_cases/user_following/create.dart';
import '../../../../data/use_cases/user_following/delete.dart';
import '../../../../data/use_cases/user_following/get.dart';

class UserFollowingCubit extends DataCubit<UserFollowing> {
  final String uid;

  UserFollowingCubit([String? uid]) : uid = uid ?? UserHelper.uid;

  @override
  UserFollowing? createNewObject(Object? args) {
    if (uid.isEmpty) return null;
    return UserFollowing.create(uid: uid);
  }

  @override
  Future<Response<int>> count() => GetUserFollowingCountUseCase.i(uid);

  @override
  Future<Response<UserFollowing>> create(UserFollowing data) {
    return CreateUserFollowingUseCase.i(data);
  }

  @override
  Future<Response<UserFollowing>> delete(UserFollowing data) {
    return DeleteUserFollowingUseCase.i(data.id);
  }

  @override
  Future<Response<UserFollowing>> fetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) async {
    if (resultByMe) return Response(status: Status.undefined);
    return GetUserFollowingsUseCase.i(uid);
  }
}
