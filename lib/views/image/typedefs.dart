part of 'view.dart';

typedef ImageViewProgressBuilder = Widget Function(
    BuildContext, String, DownloadProgress);
typedef ImageViewErrorBuilder = Widget Function(BuildContext, String, Object);
