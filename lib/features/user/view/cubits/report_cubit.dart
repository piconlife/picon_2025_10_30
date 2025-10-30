import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_report.dart';
import '../../../../data/use_cases/user_report/count.dart';
import '../../../../data/use_cases/user_report/get_by_pagination.dart';

class UserReportCubit extends DataCubit<UserReport> {
  final String uid;

  UserReportCubit(super.context, [String? uid]) : uid = uid ?? UserHelper.uid;

  @override
  Future<Response<int>> onCount() => GetUserReportCountUseCase.i(uid);

  @override
  Future<Response<UserReport>> onFetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) async {
    if (resultByMe) return Response(status: Status.undefined);
    return GetUserReportsByPaginationUseCase.i(
      uid: uid,
      initialSize: initialSize ?? 10,
      fetchingSize: fetchingSize ?? 5,
      snapshot: state.snapshot,
    );
  }
}
