import 'package:flutter_andomie/utils/configs.dart';

import '../../../roots/keys/configs.dart';

enum AuthorizationMode {
  none,
  soft,
  normal,
  hard;

  bool get isNone => this == none;

  bool get isSoft => this == soft;

  bool get isHard => this == hard;

  bool get isNormal => this == normal;

  factory AuthorizationMode.parse(Object? source) {
    final x = values.where((e) {
      if (e.index == source) return true;
      final y = source.toString().trim().toLowerCase();
      if (e.name.toLowerCase() == y) return true;
      if (e.toString().toLowerCase() == y) return true;
      return false;
    }).firstOrNull;

    return x ?? AuthorizationMode.none;
  }

  static AuthorizationMode get detect {
    return Configs.get(
      ConfigKeys.authorizationMode,
      defaultValue: AuthorizationMode.normal,
      parser: AuthorizationMode.parse,
    );
  }
}
