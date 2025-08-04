import 'package:auth_management/core.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';

class LoginUserUseCase {
  const LoginUserUseCase._();

  static LoginUserUseCase? _i;

  static LoginUserUseCase get i => _i ??= const LoginUserUseCase._();

  Future<AuthResponse<User>> call({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return const AuthResponse.failure("Email or password is invalid!");
    }
    return context.signInByEmail<User>(
      EmailAuthenticator(email: email, password: password),
    );
  }
}
