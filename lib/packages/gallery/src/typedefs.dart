import 'enums.dart' show GalleryType;

typedef LaunchCameraHandler = Future<String?> Function(GalleryType mode);
