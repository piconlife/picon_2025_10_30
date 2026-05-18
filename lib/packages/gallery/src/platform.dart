import 'package:flutter/foundation.dart' show kIsWeb;

import '_platform_stub.dart' if (dart.library.io) '_platform_io.dart';

bool get isAndroid => !kIsWeb && platformIsAndroid;

bool get isIos => !kIsWeb && platformIsIos;
