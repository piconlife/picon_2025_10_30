import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../models/user.dart';
import 'base.dart';

class GetSpecificUsersByPagingUseCase extends BaseUserUseCase {
  GetSpecificUsersByPagingUseCase._();

  static GetSpecificUsersByPagingUseCase? _i;

  static GetSpecificUsersByPagingUseCase get i {
    return _i ??= GetSpecificUsersByPagingUseCase._();
  }

  Future<Response<User>> call({
    required List<String> ids,
    required Object? snapshot,
    int fetchingSize = 15,
    int initialFetchingSize = 25,
    bool descending = true,
    bool cached = true,
  }) {
    return repository.getByQuery(
      cached: cached,
      queries: [DataQuery(UserKeys.i.id, whereIn: ids)],
      sorts: [DataSorting(UserKeys.i.id, descending: descending)],
      selections: [DataSelection.startAfterDocument(snapshot)],
      options: DataPagingOptions(
        initialFetchSize: initialFetchingSize,
        fetchingSize: fetchingSize,
      ),
    );
  }
}
