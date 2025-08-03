import 'package:data_management/core.dart'
    show DataQuery, DataSelection, DataSorting, DataPagingOptions;
import 'package:flutter_entity/flutter_entity.dart';

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
  }) {
    return repository.getByQuery(
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
