import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/use_cases/user_post/count.dart';

class UserPostCounterCubit extends DataCubit<int> {
  final String? uid;

  UserPostCounterCubit([String? uid]) : uid = uid ?? UserHelper.uid;

  @override
  void fetch() async {
    if (uid == null || uid!.isEmpty) {
      return emit(state.copy(status: Status.notFound));
    }
    emit(state.copy(status: Status.loading));
    GetUserPostCountUseCase.i(uid).then(_attach).catchError((error, st) {
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

  void increment(int value) {
    emit(state.copy(data: (state.data ?? 0) + value));
  }
}
