import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/use_cases/user_following/count.dart';

class UserFollowingCounterCubit extends DataCubit<int> {
  final String? uid;

  UserFollowingCounterCubit([String? uid]) : uid = uid ?? UserHelper.uid;

  @override
  void fetch() async {
    if (uid == null || uid!.isEmpty) {
      return emit(state.copy(status: Status.notFound));
    }
    emit(state.copy(status: Status.loading));
    GetUserFollowingCountUseCase.i(uid).then(_attach).catchError((error, st) {
      emit(state.copy(status: Status.failure));
    });
  }

  void _attach(Response<int> response) {
    emit(
      state.copy(
        status: response.status,
        snapshot: response.snapshot,
        data: response.data,
      ),
    );
  }
}
