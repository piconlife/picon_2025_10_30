import 'package:flutter_entity/entity.dart';

import '../../../app/imports/data_management.dart'
    show DataSorting, DataSelection, DataFetchOptions;
import '../../constants/keys.dart';
import '../../models/user_video.dart';
import 'base.dart';

class GetUserVideosByPaginationUseCase extends BaseUserVideoUseCase {
  GetUserVideosByPaginationUseCase._();

  static GetUserVideosByPaginationUseCase? _i;

  static GetUserVideosByPaginationUseCase get i {
    return _i ??= GetUserVideosByPaginationUseCase._();
  }

  Future<Response<VideoModel>> call({
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
      options: DataFetchOptions(
        initialFetchSize: initialSize,
        fetchingSize: fetchingSize,
      ),
    );
  }
}
