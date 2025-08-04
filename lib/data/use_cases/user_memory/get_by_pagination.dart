import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../models/user_memory.dart';
import 'base.dart';

class GetUserMemoriesByPaginationUseCase extends BaseUserMemoryUseCase {
  GetUserMemoriesByPaginationUseCase._();

  static GetUserMemoriesByPaginationUseCase? _i;

  static GetUserMemoriesByPaginationUseCase get i {
    return _i ??= GetUserMemoriesByPaginationUseCase._();
  }

  Future<Response<UserMemory>> call({
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
