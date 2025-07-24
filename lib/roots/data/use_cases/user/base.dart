import '../../repositories/user.dart';

class BaseUserUseCase {
  final UserRepository repository;

  BaseUserUseCase() : repository = UserRepository.i;
}
