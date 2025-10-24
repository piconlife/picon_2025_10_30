import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart';
import 'package:in_app_configs/configs.dart';

class ConnectivityHelper {
  const ConnectivityHelper._();

  static Future<bool> get _test async {
    if (!Configs.get("connectivity_checking", defaultValue: false)) {
      return true;
    }
    try {
      await get(
        Uri.parse(
          Configs.get(
            "connectivity_url",
            defaultValue: "https://www.cloudflare.com/cdn-cgi/trace",
          ),
        ),
      ).timeout(
        Duration(seconds: Configs.get("connectivity_timeout", defaultValue: 3)),
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

  static Future<bool> get isConnected {
    return Connectivity().checkConnectivity().then((value) {
      final connected = [
        ConnectivityResult.mobile,
        ConnectivityResult.wifi,
        ConnectivityResult.ethernet,
      ].any((element) => value.contains(element));
      if (connected) return _test;
      return connected;
    });
  }

  static Future<bool> get isDisconnected async => !(await isConnected);

  static Stream<bool> get changed {
    return Connectivity().onConnectivityChanged.map((event) {
      final status = event.firstOrNull;
      final mobile = status == ConnectivityResult.mobile;
      final wifi = status == ConnectivityResult.wifi;
      final ethernet = status == ConnectivityResult.ethernet;
      return mobile || wifi || ethernet;
    });
  }

  static Future<bool> connected() => isConnected;
}
