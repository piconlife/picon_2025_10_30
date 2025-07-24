import 'package:flutter_device_config/flutter_device_config.dart';

class InAppDevices {
  const InAppDevices._();

  static const watch = Device.watch(width: 360, height: 640);

  static const mobile = Device.mobile(width: 360, height: 640);

  static const tablet = Device.tablet(width: 360, height: 640);

  static const laptop = Device.laptop(width: 360, height: 640);

  static const desktop = Device.desktop(width: 360, height: 640);

  static const tv = Device.tv(width: 360, height: 640);
}
