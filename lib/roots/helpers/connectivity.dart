import 'dart:async';
import 'dart:io';

import 'package:flutter_andomie/utils/configs.dart';
import 'package:flutter_network_status/flutter_network_status.dart';
import 'package:http/http.dart';

import '../keys/configs.dart';
import '../res/defaults.dart';

class ConnectivityHelper {
  const ConnectivityHelper._();

  static Future<bool> get isInternetActive async {
    if (!Configs.get(
      ConfigKeys.connectivityChecking,
      defaultValue: RootDefaults.connectivityChecking,
    )) {
      return true;
    }
    try {
      await get(
        Uri.parse(
          Configs.get(
            ConfigKeys.connectivityUrl,
            defaultValue: RootDefaults.connectivityUrl,
          ),
        ),
      ).timeout(
        Duration(
          seconds: Configs.get(
            ConfigKeys.connectivityTimeout,
            defaultValue: RootDefaults.connectivityTimeout,
          ),
        ),
      );
      return true;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> get isInternetInactive async => !(await isInternetActive);

  static Future<bool> get isConnected async {
    final connected = await ConnectivityProvider.I.isConnected;
    if (connected) return isInternetActive;
    return connected;
  }

  static Future<bool> get isDisconnected async => !(await isConnected);

  static Stream<bool> get activityChanges {
    return ConnectivityProvider.I.connection.asyncMap((connected) {
      if (connected) return isInternetActive;
      return connected;
    });
  }

  static Stream<bool> get changes => ConnectivityProvider.I.connection;

  static Future<bool> connection() => isConnected;
}
