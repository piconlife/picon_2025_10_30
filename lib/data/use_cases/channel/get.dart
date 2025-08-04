import 'package:flutter_entity/entity.dart';

import '../../models/channel.dart';
import 'base.dart';

class GetChannelsUseCase extends BaseChannelUseCase {
  GetChannelsUseCase._();

  static GetChannelsUseCase? _i;

  static GetChannelsUseCase get i => _i ??= GetChannelsUseCase._();

  Future<Response<Channel>> call() {
    return repository.get();
  }
}
