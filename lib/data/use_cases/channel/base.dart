import '../../repositories/channel.dart';

class BaseChannelUseCase {
  final ChannelRepository repository;

  BaseChannelUseCase() : repository = ChannelRepository.i;
}
