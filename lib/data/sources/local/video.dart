import '../../base/in_app_data_source.dart';
import '../../constants/paths.dart';
import '../../models/feed_video.dart';

class LocalVideoDataSource extends InAppDataSource<VideoModel> {
  LocalVideoDataSource() : super(Paths.refVideos);

  @override
  VideoModel build(Object? source) => VideoModel.from(source);
}
