import 'package:data_management/core.dart';

import '../../constants/paths.dart';
import '../../delegates/firestore.dart';
import '../../models/channel.dart';

class RemoteChannelDataSource extends RemoteDataSource<Channel> {
  RemoteChannelDataSource()
    : super(delegate: FirestoreDataDelegate.i, path: Paths.channels);

  @override
  Channel build(Object? source) => Channel.from(source);
}
