import 'package:flutter/foundation.dart';
import 'package:flutter_entity/entity.dart';

import '../../models/unifier.dart';
import '../../parsers/error_parser.dart';
import '../../repositories/unifier.dart';

class BaseUserPhoneUnifierUseCase {
  final PhoneUnifierRepository repository;

  BaseUserPhoneUnifierUseCase() : repository = PhoneUnifierRepository.i;

  @protected
  Response<PhoneUnifier> exception(Object? error, _) {
    return Response<PhoneUnifier>(
      error: parseError(error),
      status: Status.failure,
    );
  }
}
