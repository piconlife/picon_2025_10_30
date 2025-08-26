import 'package:flutter_andomie/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_follower.dart';
import '../../../../data/use_cases/user_follower/get.dart';

class FollowerCubit extends DataCubit<Selection<UserFollower>> {
  final String? uid;

  FollowerCubit() : uid = UserHelper.uid;

  void _attach(Response<UserFollower> response) {
    final data = state.result;
    if (response.result.isNotEmpty) {
      data.addAll(response.result.map((e) => Selection(id: e.id, data: e)));
    }
    emit(state.copyWith(status: response.status, result: data));
  }

  @override
  void fetch() async {
    if (uid == null || uid!.isEmpty) {
      return emit(state.copyWith(status: Status.notFound));
    }
    emit(state.copyWith(status: Status.loading));
    GetUserFollowersUseCase.i().then(_attach).catchError((error, __) {
      emit(state.copyWith(status: Status.failure));
    });
  }
}
