import '../../base/firestore_data_source.dart';
import '../../constants/paths.dart';
import '../../models/feed_video.dart';

class RemoteFeedVideoDataSource extends FirestoreDataSource<VideoModel> {
  RemoteFeedVideoDataSource() : super(Paths.refVideos);

  @override
  VideoModel build(Object? source) => VideoModel.from(source);
}
