import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_memory.dart';
import '../../../../data/use_cases/user_memory/get_by_pagination.dart';

class UserMemoryCubit extends DataCubit<UserMemory> {
  final String uid;

  UserMemoryCubit([String? uid]) : uid = uid ?? UserHelper.uid;

  @override
  Future<Response<UserMemory>> fetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) async {
    if (resultByMe) return Response(status: Status.undefined);
    return GetUserMemoriesByPaginationUseCase.i(
      uid: uid,
      initialSize: initialSize ?? 10,
      fetchingSize: fetchingSize ?? 5,
      snapshot: state.snapshot,
    );
  }

  void update(UserMemory value) {
    final index = state.result.indexOf(value);
    if (index >= 0) {
      state.result.removeAt(index);
      state.result.insert(index, value);
      emit(state.copyWith(data: value, result: state.result, requestCode: 202));
    }
  }
}
