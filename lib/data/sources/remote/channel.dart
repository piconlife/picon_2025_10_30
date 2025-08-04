import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/channel.dart';

class RemoteChannelDataSource extends FirestoreDataSource<Channel> {
  RemoteChannelDataSource({super.path = Paths.channels});

  @override
  Channel build(Object? source) => Channel.from(source);
}
