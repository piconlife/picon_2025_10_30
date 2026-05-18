import 'package:flutter_entity/entity.dart';

import '../../../packages/data_management.dart'
    show DataSorting, DataSelection, DataFetchOptions;
import '../../constants/keys.dart';
import '../../models/user_cover.dart';
import 'base.dart';

class GetUserCoversByPaginationUseCase extends BaseUserCoverUseCase {
  GetUserCoversByPaginationUseCase._();

  static GetUserCoversByPaginationUseCase? _i;

  static GetUserCoversByPaginationUseCase get i {
    return _i ??= GetUserCoversByPaginationUseCase._();
  }

  Future<Response<CoverModel>> call({
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
      options: DataFetchOptions(
        initialFetchSize: initialSize,
        fetchingSize: fetchingSize,
      ),
    );
  }
}
