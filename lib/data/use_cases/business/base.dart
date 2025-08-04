import '../../repositories/business.dart';

class BaseBusinessUseCase {
  final BusinessRepository repository;

  BaseBusinessUseCase() : repository = BusinessRepository.i;
}
