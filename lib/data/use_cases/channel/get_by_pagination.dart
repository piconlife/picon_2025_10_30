import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../models/channel.dart';
import 'base.dart';

class GetChannelsByPaginationUseCase extends BaseChannelUseCase {
  GetChannelsByPaginationUseCase._();

  static GetChannelsByPaginationUseCase? _i;

  static GetChannelsByPaginationUseCase get i {
    return _i ??= GetChannelsByPaginationUseCase._();
  }

  Future<Response<Channel>> call({
    int? initialSize,
    int? fetchingSize,
    Object? snapshot,
  }) {
    return repository.getByQuery(
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
