import 'package:data_management/core.dart';
import 'package:in_app_database/in_app_database.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/channel.dart';
import '../sources/local/channel.dart';
import '../sources/remote/channel.dart';

class ChannelRepository extends RemoteDataRepository<Channel> {
  ChannelRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static ChannelRepository? _i;

  static ChannelRepository get i => _i ??= ChannelRepository(
    source: RemoteChannelDataSource(),
    backup: LocalChannelDataSource(database: InAppDatabase.i),
  );
}
