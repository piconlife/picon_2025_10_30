import 'package:flutter_entity/entity.dart';

import '../../models/channel.dart';
import 'base.dart';

class UpdateChannelUseCase extends BaseChannelUseCase {
  UpdateChannelUseCase._();

  static UpdateChannelUseCase? _i;

  static UpdateChannelUseCase get i => _i ??= UpdateChannelUseCase._();

  Future<Response<Channel>> call(String id, Map<String, dynamic> data) {
    return repository.updateById(id, data);
  }
}
