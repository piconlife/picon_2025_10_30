import 'package:data_management/core.dart'
    show DataQuery, DataSelection, DataSorting, DataPagingOptions;
import 'package:flutter_entity/flutter_entity.dart';

import '../../models/user.dart';
import 'base.dart';

class GetUsersByPagingUseCase extends BaseUserUseCase {
  GetUsersByPagingUseCase._();

  static GetUsersByPagingUseCase? _i;

  static GetUsersByPagingUseCase get i => _i ??= GetUsersByPagingUseCase._();

  Future<Response<User>> call({
    required String uid,
    required Object? snapshot,
    int fetchingSize = 15,
    int initialFetchingSize = 25,
    bool descending = true,
  }) {
    return repository.getByQuery(
      queries: [DataQuery(UserKeys.i.id, isNotEqualTo: uid)],
      sorts: [DataSorting(UserKeys.i.id, descending: descending)],
      selections: [DataSelection.startAfterDocument(snapshot)],
      options: DataPagingOptions(
        initialFetchSize: initialFetchingSize,
        fetchingSize: fetchingSize,
      ),
    );
  }
}
