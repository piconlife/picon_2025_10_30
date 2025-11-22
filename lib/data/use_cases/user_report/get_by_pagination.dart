import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../models/user_report.dart';
import 'base.dart';

class GetUserReportsByPaginationUseCase extends BaseUserReportUseCase {
  GetUserReportsByPaginationUseCase._();

  static GetUserReportsByPaginationUseCase? _i;

  static GetUserReportsByPaginationUseCase get i {
    return _i ??= GetUserReportsByPaginationUseCase._();
  }

  Future<Response<ReportModel>> call({
    String? uid,
    int? initialSize,
    int? fetchingSize,
    Object? snapshot,
  }) {
    return repository.getByQuery(
      params: getParams(uid),
      sorts: [DataSorting(Keys.i.timeMills, descending: true)],
      selections: [
        if (snapshot != null) DataSelection.startAfterDocument(snapshot),
      ],
      options: DataPagingOptions(
        initialFetchSize: initialSize,
        fetchingSize: fetchingSize,
      ),
    );
  }
}
