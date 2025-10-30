import 'package:data_management/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_andomie/extensions/list.dart';
import 'package:flutter_andomie/models/selection.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/user.dart';
import '../../../../data/use_cases/user/get_users_by_ids.dart';

class VerifiedUsersCubit extends DataCubit<Selection<User>> {
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
  Future<Response<Selection<User>>> fetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) async {
    final ids = UserHelper.followings;
    if (ids.isEmpty) return Response(status: Status.notFound);
    if (resultByMe) return Response(status: Status.undefined);
    return GetUsersByIdsUseCase.i(ids).then(_converter);
  }

  void update(BuildContext context, Selection<User> value) {
    emit(
      state.copyWith(
        result: state.result.change(value, (e) {
          return e.data.id == value.data.id;
        }),
      ),
    );
    DataFieldValue field;
    if (value.selected) {
      field = DataFieldValue.arrayRemove([value.id]);
    } else {
      field = DataFieldValue.arrayUnion([value.id]);
    }
    UserHelper.update(context, {UserKeys.i.approvals: field});
  }
}
