import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_note.dart';
import '../../../../data/use_cases/user_note/get_by_pagination.dart';

class UserNoteCubit extends DataCubit<NoteModel> {
  final String uid;

  UserNoteCubit(super.context, [String? uid]) : uid = uid ?? UserHelper.uid;

  @override
  Future<Response<NoteModel>> onFetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) async {
    if (resultByMe) return Response(status: Status.undefined);
    return GetUserNotesByPaginationUseCase.i(
      uid: uid,
      initialSize: initialSize ?? 10,
      fetchingSize: fetchingSize ?? 5,
      snapshot: state.snapshot,
    );
  }
}
