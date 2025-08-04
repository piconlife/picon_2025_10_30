import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../models/user.dart';
import 'base.dart';

class GetUsersWithoutIdUseCase extends BaseUserUseCase {
  GetUsersWithoutIdUseCase._();

  static GetUsersWithoutIdUseCase? _i;

  static GetUsersWithoutIdUseCase get i => _i ??= GetUsersWithoutIdUseCase._();

  Future<Response<User>> call({required String uid, bool cached = true}) {
    return repository.getByQuery(
      cached: cached,
      queries: [DataQuery(UserKeys.i.id, isNotEqualTo: uid)],
    );
  }
}
