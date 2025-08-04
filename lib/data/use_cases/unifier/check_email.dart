import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../models/unifier.dart';
import '../../parsers/error_parser.dart';
import 'email.dart';

class CheckUserPrefixUseCase extends BaseUserPrefixUnifierUseCase {
  CheckUserPrefixUseCase._();

  static CheckUserPrefixUseCase? _i;

  static CheckUserPrefixUseCase get i => _i ??= CheckUserPrefixUseCase._();

  Future<Response<Unifier>> call(String? email) async {
    try {
      return repository
          .search(
            Checker(
              field: UnifierKeys.i.value,
              value: email,
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
