import '../../constants/paths.dart';
import '../../delegates/local.dart';
import '../../models/channel.dart';

class LocalChannelDataSource extends InAppDataSource<Channel> {
  const LocalChannelDataSource({
    super.path = Paths.channels,
    required super.database,
  });

  @override
  Channel build(Object? source) => Channel.from(source);
}
