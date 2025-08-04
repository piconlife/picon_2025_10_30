import 'package:auth_management/auth_management.dart';

class InAppFacebookAuthDelegate extends IFacebookAuthDelegate {
  @override
  Future<IFacebookAccessToken?> get accessToken => throw UnimplementedError();

  @override
  Future<void> autoLogAppEventsEnabled(bool enabled) {
    throw UnimplementedError();
  }

  @override
  Future<IFacebookLoginResult> expressLogin() {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getUserData({
    String fields = "name,email,picture.width(200)",
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool> get isAutoLogAppEventsEnabled => throw UnimplementedError();

  @override
  bool get isWebSdkInitialized => throw UnimplementedError();

  @override
  Future<void> logOut() {
    throw UnimplementedError();
  }

  @override
  Future<IFacebookLoginResult> login({
    List<String> permissions = const ['email', 'public_profile'],
    IFacebookLoginBehavior loginBehavior =
        IFacebookLoginBehavior.nativeWithFallback,
    IFacebookLoginTracking loginTracking = IFacebookLoginTracking.limited,
    String? nonce,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> webAndDesktopInitialize({
    required String appId,
    required bool cookie,
    required bool xfbml,
    required String version,
  }) {
    throw UnimplementedError();
  }
}
