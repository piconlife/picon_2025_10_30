import 'package:flutter_device_config/flutter_device_config.dart';

import '../../app/styles/devices.dart';

DeviceConfig kDeviceConfig = const DeviceConfig(
  watch: InAppDevices.watch,
  mobile: InAppDevices.mobile,
  tablet: InAppDevices.tablet,
  laptop: InAppDevices.laptop,
  desktop: InAppDevices.desktop,
  tv: InAppDevices.tv,
);
