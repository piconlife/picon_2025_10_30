import 'package:flutter_entity/entity.dart';

import '../../../packages/data_management.dart' show DataQuery;
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
      cacheMode: singletonMode,
      queries: [DataQuery(UserKeys.i.id, whereIn: ids)],
    );
  }
}
