import 'package:flutter_entity/entity.dart';

import '../../../app/imports/data_management.dart' show DataQuery;
import '../../models/user.dart';
import 'base.dart';

class GetUsersByIdsUseCase extends BaseUserUseCase {
  GetUsersByIdsUseCase._();

  static GetUsersByIdsUseCase? _i;

  static GetUsersByIdsUseCase get i => _i ??= GetUsersByIdsUseCase._();

  Future<Response<UserModel>> call(
    Iterable<String> ids, {
    bool singletonMode = true,
  }) {
    return repository.getByQuery(
      singletonMode: singletonMode,
      queries: [DataQuery(UserKeys.i.id, whereIn: ids)],
    );
  }
}
