import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../enums/content.dart';
import '../../models/user_post.dart';
import 'base.dart';

class GetUserPhotosByPaginationUseCase extends BaseUserPostUseCase {
  GetUserPhotosByPaginationUseCase._();

  static GetUserPhotosByPaginationUseCase? _i;

  static GetUserPhotosByPaginationUseCase get i {
    return _i ??= GetUserPhotosByPaginationUseCase._();
  }

  Future<Response<UserPost>> call({
    String? uid,
    int? initialSize,
    int? fetchingSize,
    Object? snapshot,
    bool singletonMode = true,
  }) {
    return repository.getByQuery(
      singletonMode: singletonMode,
      params: getParams(uid),
      queries: [DataQuery(Keys.i.type, isEqualTo: ContentType.photo.name)],
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
