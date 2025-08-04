import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../models/user_story.dart';
import 'base.dart';

class GetUserStoriesByPaginationUseCase extends BaseUserStoryUseCase {
  GetUserStoriesByPaginationUseCase._();

  static GetUserStoriesByPaginationUseCase? _i;

  static GetUserStoriesByPaginationUseCase get i {
    return _i ??= GetUserStoriesByPaginationUseCase._();
  }

  Future<Response<UserStory>> call({
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
