import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../constants/keys.dart';
import '../../models/user_note.dart';
import 'base.dart';

class GetUserNotesByPaginationUseCase extends BaseUserNoteUseCase {
  GetUserNotesByPaginationUseCase._();

  static GetUserNotesByPaginationUseCase? _i;

  static GetUserNotesByPaginationUseCase get i {
    return _i ??= GetUserNotesByPaginationUseCase._();
  }

  Future<Response<NoteModel>> call({
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
