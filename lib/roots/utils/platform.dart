import 'dart:io';

import 'package:flutter/foundation.dart';

bool get isAndroid => !kIsWeb && Platform.isAndroid;

bool get isIos => !kIsWeb && Platform.isIOS;

bool get isIosDevice => isIos;
