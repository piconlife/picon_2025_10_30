import 'package:data_management/core.dart' show DataQuery;
import 'package:flutter_entity/flutter_entity.dart';

import '../../models/user.dart';
import 'base.dart';

class GetUsersWithoutIdUseCase extends BaseUserUseCase {
  GetUsersWithoutIdUseCase._();

  static GetUsersWithoutIdUseCase? _i;

  static GetUsersWithoutIdUseCase get i => _i ??= GetUsersWithoutIdUseCase._();

  Future<Response<User>> call({required String uid}) {
    return repository.getByQuery(
      queries: [DataQuery(UserKeys.i.id, isNotEqualTo: uid)],
    );
  }
}
