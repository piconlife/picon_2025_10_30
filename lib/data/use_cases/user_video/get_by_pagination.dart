import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../models/user_video.dart';
import 'base.dart';

class GetUserVideosByPaginationUseCase extends BaseUserVideoUseCase {
  GetUserVideosByPaginationUseCase._();

  static GetUserVideosByPaginationUseCase? _i;

  static GetUserVideosByPaginationUseCase get i {
    return _i ??= GetUserVideosByPaginationUseCase._();
  }

  Future<Response<UserVideo>> call({
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
