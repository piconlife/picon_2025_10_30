import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../models/photo.dart';
import 'base.dart';

class GetFeedPhotosByPaginationUseCase extends PhotoBaseUseCase {
  GetFeedPhotosByPaginationUseCase._();

  static GetFeedPhotosByPaginationUseCase? _i;

  static GetFeedPhotosByPaginationUseCase get i {
    return _i ??= GetFeedPhotosByPaginationUseCase._();
  }

  Future<Response<Photo>> call({
    required String referencePath,
    int? initialSize,
    int? fetchingSize,
    Object? snapshot,
    bool cached = true,
  }) {
    return repository.getByQuery(
      cached: cached,
      params: getParams(referencePath),
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
