import 'dart:io';

import 'package:flutter/foundation.dart';

bool get isAndroid => !kIsWeb && Platform.isAndroid;

bool get isFuchsia => !kIsWeb && Platform.isFuchsia;

bool get isIOS => !kIsWeb && Platform.isIOS;

bool get isLinux => !kIsWeb && Platform.isLinux;

bool get isMacOS => !kIsWeb && Platform.isMacOS;

bool get isWindows => !kIsWeb && Platform.isWindows;

bool get isAppleDevice => isIOS || isMacOS;
