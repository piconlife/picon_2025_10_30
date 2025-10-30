import 'package:data_management/core.dart';
import 'package:flutter_andomie/models/selection.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user.dart';
import '../../../../data/use_cases/user/get_users_by_ids.dart';

class VerifiedUsersCubit extends DataCubit<Selection<User>> {
  VerifiedUsersCubit(super.context);

  Response<Selection<User>> _converter(Response<User> response) {
    return Response.convert(response, (e) {
      return Selection(
        id: e.id,
        data: e,
        selected: UserHelper.approvals.contains(e.id),
      );
    });
  }

  @override
  Future<Response<Selection<User>>> onFetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) async {
    final ids = UserHelper.followings;
    if (ids.isEmpty) return Response(status: Status.notFound);
    if (resultByMe) return Response(status: Status.undefined);
    return GetUsersByIdsUseCase.i(ids).then(_converter);
  }

  @override
  Future<Response<Selection<User>>> onUpdate(
    Selection<User> old,
    Map<String, dynamic> changes,
  ) async {
    DataFieldValue field;
    if (old.selected) {
      field = DataFieldValue.arrayRemove([old.id]);
    } else {
      field = DataFieldValue.arrayUnion([old.id]);
    }
    UserHelper.update(context, {UserKeys.i.approvals: field});
    return Response(status: Status.ok);
  }
}
