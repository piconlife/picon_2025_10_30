import 'package:flutter_entity/entity.dart';

import '../../../app/helpers/user.dart';
import '../../models/channel.dart';
import 'base.dart';

class GetChannelUseCase extends BaseChannelUseCase {
  GetChannelUseCase._();

  static GetChannelUseCase? _i;

  static GetChannelUseCase get i => _i ??= GetChannelUseCase._();

  Future<Response<Channel>> call([String? uid]) {
    return repository.getById(uid ?? UserHelper.uid);
  }
}
