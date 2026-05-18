import 'package:flutter_entity/entity.dart';

import '../../../packages/data_management.dart'
    show DataSorting, DataSelection, DataFetchOptions;
import '../../constants/keys.dart';
import '../../models/user_post.dart';
import 'base.dart';

class GetUserPostsByPaginationUseCase extends BaseUserPostUseCase {
  GetUserPostsByPaginationUseCase._();

  static GetUserPostsByPaginationUseCase? _i;

  static GetUserPostsByPaginationUseCase get i {
    return _i ??= GetUserPostsByPaginationUseCase._();
  }

  Future<Response<PostModel>> call({
    String? uid,
    int? initialSize,
    int? fetchingSize,
    Object? snapshot,
    bool singletonMode = true,
  }) {
    return repository.getByQuery(
      resolveRefs: true,
      params: getParams(uid),
      cacheMode: singletonMode,
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
