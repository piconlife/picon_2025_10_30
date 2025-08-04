import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../../models/unifier.dart';
import '../../parsers/error_parser.dart';
import 'phone.dart';

class CheckPhoneUseCase extends BaseUserPhoneUnifierUseCase {
  CheckPhoneUseCase._();

  static CheckPhoneUseCase? _i;

  static CheckPhoneUseCase get i => _i ??= CheckPhoneUseCase._();

  Future<Response<PhoneUnifier>> call(String? phone) async {
    try {
      return repository
          .search(
            Checker(
              field: UnifierKeys.i.value,
              value: phone,
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
