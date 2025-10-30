import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user_note.dart';
import '../../../../data/use_cases/user_note/get_by_pagination.dart';

class UserNoteCubit extends DataCubit<UserNote> {
  final String uid;

  UserNoteCubit([String? uid]) : uid = uid ?? UserHelper.uid;

  @override
  Future<Response<UserNote>> fetch({
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

  void update(UserNote value) {
    final index = state.result.indexOf(value);
    if (index >= 0) {
      state.result.removeAt(index);
      state.result.insert(index, value);
      emit(state.copyWith(data: value, result: state.result, requestCode: 202));
    }
  }
}
