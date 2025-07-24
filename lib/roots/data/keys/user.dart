import 'package:auth_management/auth_management.dart';

class UserKeys extends AuthKeys {
  const UserKeys._();

  static UserKeys? _i;

  static UserKeys get i => _i ??= const UserKeys._();

  @override
  Iterable<String> get keys {
    return [
      id,
      idToken,
      timeMills,
      email,
      loggedIn,
      loggedInTime,
      loggedOutTime,
      name,
      password,
      phone,
      photo,
      username,
      verified,
    ];
  }
}
