import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../enums/content.dart';
import '../../models/user_post.dart';
import 'base.dart';

class GetUserNotesByPaginationUseCase extends BaseUserPostUseCase {
  GetUserNotesByPaginationUseCase._();

  static GetUserNotesByPaginationUseCase? _i;

  static GetUserNotesByPaginationUseCase get i {
    return _i ??= GetUserNotesByPaginationUseCase._();
  }

  Future<Response<UserPost>> call({
    String? uid,
    int? initialSize,
    int? fetchingSize,
    Object? snapshot,
    bool cached = true,
  }) {
    return repository.getByQuery(
      params: getParams(uid),
      cached: cached,
      queries: [DataQuery(Keys.i.type, isEqualTo: ContentType.none.name)],
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
