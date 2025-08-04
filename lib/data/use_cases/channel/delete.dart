import 'package:flutter_entity/entity.dart';

import '../../models/channel.dart';
import 'base.dart';

class DeleteChannelUseCase extends BaseChannelUseCase {
  DeleteChannelUseCase._();

  static DeleteChannelUseCase? _i;

  static DeleteChannelUseCase get i => _i ??= DeleteChannelUseCase._();

  Future<Response<Channel>> call(String uid) {
    return repository.deleteById(uid);
  }
}
