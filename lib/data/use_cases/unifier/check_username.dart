import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../models/unifier.dart';
import '../../parsers/error_parser.dart';
import 'username.dart';

class CheckUsernameUseCase extends BaseUserNameUnifierUseCase {
  CheckUsernameUseCase._();

  static CheckUsernameUseCase? _i;

  static CheckUsernameUseCase get i => _i ??= CheckUsernameUseCase._();

  Future<Response<NameUnifier>> call(String? name) async {
    try {
      return repository
          .search(
            Checker(
              field: UnifierKeys.i.value,
              value: name,
              type: CheckerType.equal,
            ),
          )
          .onError(exception)
          .catchError(exception);
    } catch (error) {
      return Response(status: Status.failure, error: parseError(error));
    }
  }
}
