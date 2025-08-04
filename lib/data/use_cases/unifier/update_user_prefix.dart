import 'package:flutter_entity/entity.dart';

import '../../models/unifier.dart';
import '../../parsers/error_parser.dart';
import 'email.dart';

class UpdateUserPrefixUseCase extends BaseUserPrefixUnifierUseCase {
  UpdateUserPrefixUseCase._();

  static UpdateUserPrefixUseCase? _i;

  static UpdateUserPrefixUseCase get i => _i ??= UpdateUserPrefixUseCase._();

  Future<Response<PrefixUnifier>> call(String prefix) async {
    try {
      final data = <String, dynamic>{
        UnifierKeys.i.timeMills: Entity.generateTimeMills,
        UnifierKeys.i.verified: true,
      };
      final value = await repository
          .updateById(Unifier.identifier(prefix), data)
          .onError(exception)
          .catchError(exception);
      return value;
    } catch (error) {
      return Response(status: Status.failure, error: parseError(error));
    }
  }
}
