import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_following.dart';
import '../../../../data/use_cases/user_following/count.dart';
import '../../../../data/use_cases/user_following/create.dart';
import '../../../../data/use_cases/user_following/delete.dart';
import '../../../../data/use_cases/user_following/get.dart';
import '../../../../data/use_cases/user_following/gets.dart';

class UserFollowingCubit extends DataCubit<FollowingModel> {
  final String uid;

  UserFollowingCubit(super.context, [String? uid])
    : uid = uid ?? UserHelper.uid;

  @override
  FollowingModel? createNewObject(Object? args) {
    if (uid.isEmpty) return null;
    return FollowingModel.create(uid: uid);
  }

  @override
  Future<Response<int>> onCount() => UserFollowingCountUseCase.i(uid);

  @override
  Future<Response<FollowingModel>> onCreate(FollowingModel data) {
    return UserFollowingCreateUseCase.i(data);
  }

  @override
  Future<Response<FollowingModel>> onDelete(FollowingModel data) {
    return onDeleteById(data.id);
  }

  @override
  Future<Response<FollowingModel>> onDeleteById(String id) {
    return UserFollowingDeleteUseCase.i(id);
  }

  @override
  Future<Response<FollowingModel>> onGetById(String id) {
    return UserFollowingGetUseCase.i(id);
  }

  @override
  Future<Response<FollowingModel>> onFetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) async {
    if (resultByMe) return Response(status: Status.undefined);
    return UserFollowingGetsUseCase.i(uid);
  }
}
