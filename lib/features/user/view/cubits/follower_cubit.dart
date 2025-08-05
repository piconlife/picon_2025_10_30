import 'package:flutter_andomie/models/selection.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_follower.dart';
import '../../../../data/use_cases/user_follower/get.dart';

class UserFollowerCubit extends DataCubit<Selection<UserFollower>> {
  final String? uid;

  UserFollowerCubit([String? uid]) : uid = uid ?? UserHelper.uid;

  void _attach(Response<UserFollower> response) {
    final data = state.result;
    if (response.result.isNotEmpty) {
      data.addAll(response.result.map((e) => Selection(id: e.id, data: e)));
    }
    emit(
      state.copy(
        status: response.status,
        snapshot: response.snapshot,
        result: data,
      ),
    );
  }

  @override
  void fetch() async {
    if (uid == null || uid!.isEmpty) {
      return emit(state.copy(status: Status.notFound));
    }
    emit(state.copy(status: Status.loading));
    GetUserFollowersUseCase.i().then(_attach).catchError((error, stackTrace) {
      emit(state.copy(status: Status.failure));
    });
  }
}
