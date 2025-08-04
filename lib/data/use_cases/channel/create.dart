import 'package:flutter_entity/entity.dart';

import '../../models/channel.dart';
import 'base.dart';

class CreateChannelUseCase extends BaseChannelUseCase {
  CreateChannelUseCase._();

  static CreateChannelUseCase? _i;

  static CreateChannelUseCase get i => _i ??= CreateChannelUseCase._();

  Future<Response<Channel>> call(Channel data) {
    return repository.create(data);
  }
}
