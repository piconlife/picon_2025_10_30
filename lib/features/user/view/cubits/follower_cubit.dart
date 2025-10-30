import 'package:flutter_andomie/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_follower.dart';
import '../../../../data/use_cases/user_follower/count.dart';
import '../../../../data/use_cases/user_follower/get.dart';

class UserFollowerCubit extends DataCubit<Selection<UserFollower>> {
  final String? uid;

  UserFollowerCubit(super.context, [String? uid]) : uid = uid ?? UserHelper.uid;

  @override
  Future<Response<int>> onCount() => GetUserFollowerCountUseCase.i(uid);

  @override
  Future<Response<Selection<UserFollower>>> onFetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) async {
    if (resultByMe) return Response(status: Status.undefined);
    return GetUserFollowersUseCase.i(uid).then((value) {
      return Response.convert(value, (e) {
        return Selection(id: e.id, data: e);
      });
    });
  }
}
