part of 'authorizer.dart';

mixin _AuthBiometricMixin<T extends Auth>
    on _AuthorizerBase<T>, _AuthEmitMixin<T>, _AuthUpdateMixin<T> {
  Future<Response<T>> get canUseBiometric async {
    try {
      return await _checkBiometricEligibility();
    } catch (error) {
      return Response(status: Status.failure, error: error.toString());
    }
  }

  Future<Response<T>> biometricEnable(bool enabled) async {
    try {
      final eligibility = await _checkBiometricEligibility();
      if (!eligibility.isSuccessful) return eligibility;
      final auth = eligibility.data!;
      if (enabled) {
        final response = await delegate.signInWithBiometric();
        if (!response.isSuccessful) {
          return Response(status: response.status, error: response.error);
        }
      }
      final value = await _update(
        id: auth.id,
        updateMode: true,
        data: {keys.biometric: enabled},
      );
      return Response(status: Status.ok, data: value);
    } catch (error) {
      return Response(status: Status.failure, error: error.toString());
    }
  }

  Future<AuthResponse<T>> signInByBiometric({
    Object? args,
    String? id,
    bool notifiable = true,
  }) async {
    emit(
      const AuthResponse.loading(AuthType.biometric),
      args: args,
      id: id,
      notifiable: notifiable,
    );

    final opToken = _beginOp();

    try {
      final user = await _cachedAuth;
      if (user == null || !user.isBiometric) {
        return emit(
          AuthResponse.unauthorized(
            msg: msg.signInWithBiometric.failure ?? _errorNotifier.value,
            type: AuthType.biometric,
          ),
          args: args,
          id: id,
          notifiable: notifiable,
        );
      }

      final response = await delegate.signInWithBiometric();
      if (!_isOpAlive(opToken)) {
        return AuthResponse.failure('Cancelled', type: AuthType.biometric);
      }
      if (!response.isSuccessful) {
        return _failure(
          response.error,
          type: AuthType.biometric,
          args: args,
          id: id,
          notifiable: notifiable,
        );
      }

      final provider = user.provider;
      Response<Credential> current = Response<Credential>();

      final hasCredentials =
          (user.email ?? user.username ?? '').isNotEmpty &&
          (user.password ?? '').isNotEmpty;

      // We only re-attempt password sign-in if credentials are stored.
      // For OAuth/phone/biometric-only flows, the device biometric
      // success itself is treated as proof — re-fetch user instead.
      if (hasCredentials) {
        if (provider == 'EMAIL') {
          current = await delegate.signInWithEmailNPassword(
            user.email ?? '',
            user.password ?? '',
          );
        } else if (provider == 'USERNAME') {
          current = await delegate.signInWithUsernameNPassword(
            user.username ?? '',
            user.password ?? '',
          );
        } else {
          // Stored credentials but unsupported provider — treat as ok.
          current = Response(status: Status.ok);
        }
      } else {
        // No stored credentials — biometric alone gates the cache.
        current = Response(status: Status.ok);
      }

      if (!_isOpAlive(opToken)) {
        return AuthResponse.failure('Cancelled', type: AuthType.biometric);
      }

      if (!current.isSuccessful) {
        return _failure(
          current.error,
          type: AuthType.biometric,
          args: args,
          id: id,
          notifiable: notifiable,
        );
      }

      final value = await _update(
        id: user.id,
        updateMode: true,
        data: {
          keys.loggedIn: true,
          keys.loggedInTime: EntityHelper.generateTimeMills,
        },
      );

      if (!_isOpAlive(opToken)) {
        return AuthResponse.failure('Cancelled', type: AuthType.biometric);
      }

      return emit(
        AuthResponse.authenticated(
          value,
          msg: msg.signInWithBiometric.done,
          type: AuthType.biometric,
        ),
        args: args,
        id: id,
        notifiable: notifiable,
      );
    } catch (error) {
      return _failure(
        msg.signInWithBiometric.failure ?? error.toString(),
        type: AuthType.biometric,
        args: args,
        id: id,
        notifiable: notifiable,
      );
    }
  }

  Future<Response<T>> _checkBiometricEligibility() async {
    final auth = await _cachedAuth;
    final provider = auth?.provider;
    if (auth == null ||
        !auth.isLoggedIn ||
        !['EMAIL', 'USERNAME'].contains(provider)) {
      return Response(
        status: Status.notSupported,
        error: 'User not logged in with email or username!',
      );
    }
    return Response(status: Status.ok, data: auth);
  }
}
