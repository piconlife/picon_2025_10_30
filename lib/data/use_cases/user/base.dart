import 'package:data_management/data_management.dart';

import '../../models/user.dart';
import '../../repositories/user.dart';

class BaseUserUseCase {
  final DataRepository<User> repository;

  BaseUserUseCase() : repository = UserRepository.i;
}
