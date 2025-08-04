import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../enums/content.dart';
import '../../models/user_post.dart';
import 'base.dart';

class GetUserStoriesByPaginationUseCase extends BaseUserPostUseCase {
  GetUserStoriesByPaginationUseCase._();

  static GetUserStoriesByPaginationUseCase? _i;

  static GetUserStoriesByPaginationUseCase get i {
    return _i ??= GetUserStoriesByPaginationUseCase._();
  }

  Future<Response<UserPost>> call({
    String? uid,
    int? initialSize,
    int? fetchingSize,
    Object? snapshot,
    bool cached = true,
  }) {
    return repository.getByQuery(
      cached: cached,
      params: getParams(uid),
      queries: [DataQuery(Keys.i.type, isEqualTo: ContentType.memory.name)],
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
