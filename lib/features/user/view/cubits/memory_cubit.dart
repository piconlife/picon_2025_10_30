import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_memory.dart';
import '../../../../data/use_cases/user_memory/get_by_pagination.dart';

class UserMemoryCubit extends DataCubit<MemoryModel> {
  final String uid;

  UserMemoryCubit(super.context, [String? uid]) : uid = uid ?? UserHelper.uid;

  @override
  Future<Response<MemoryModel>> onFetch({
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
}
