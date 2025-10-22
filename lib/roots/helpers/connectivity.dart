import 'dart:async';
import 'dart:io';

import 'package:flutter_network_status/flutter_network_status.dart';
import 'package:http/http.dart';
import 'package:in_app_configs/configs.dart';

import '../../app/configs/local.dart';

const kConnectivityChecking = "connectivity_checking";
const kConnectivityTimeout = "connectivity_timeout";
const kConnectivityUrl = "connectivity_url";

class ConnectivityHelper {
  const ConnectivityHelper._();

  static Future<bool> get isInternetActive async {
    if (!Configs.get(
      kConnectivityChecking,
      defaultValue: LocalConfigs.connectivityChecking,
    )) {
      return true;
    }
    try {
      await get(
        Uri.parse(
          Configs.get(
            kConnectivityUrl,
            defaultValue: LocalConfigs.connectivityUrl,
          ),
        ),
      ).timeout(
        Duration(
          seconds: Configs.get(
            kConnectivityTimeout,
            defaultValue: LocalConfigs.connectivityTimeout,
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
