import 'package:data_management/core.dart';

import '../../../roots/data/repositories/user.dart';
import '../../models/user.dart';

class BaseUserUseCase {
  final DataRepository<User> repository;

  BaseUserUseCase() : repository = UserRepository.i;
}
