import 'dart:io';

import 'package:flutter/foundation.dart';

bool get isAndroid => !kIsWeb && Platform.isAndroid;

bool get isIOS => !kIsWeb && Platform.isIOS;

bool get isMacOS => !kIsWeb && Platform.isMacOS;

bool get isIosDevice => isIOS || isMacOS;
