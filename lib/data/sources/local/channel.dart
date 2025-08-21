import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/channel.dart';

class LocalChannelDataSource extends LocalDataSource<Channel> {
  LocalChannelDataSource()
    : super(delegate: LocalDataDelegate.i, path: Paths.channels);

  @override
  Channel build(Object? source) => Channel.from(source);
}
