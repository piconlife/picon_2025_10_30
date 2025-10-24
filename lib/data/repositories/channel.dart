import 'package:data_management/data_management.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/channel.dart';
import '../sources/local/channel.dart';
import '../sources/remote/channel.dart';

class ChannelRepository extends RemoteDataRepository<Channel> {
  ChannelRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connected,
  });

  static ChannelRepository? _i;

  static ChannelRepository get i =>
      _i ??= ChannelRepository(
        source: RemoteChannelDataSource(),
        backup: LocalChannelDataSource(),
      );
}
