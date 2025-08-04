import 'package:auth_management/auth_management.dart';

class InAppGoogleAuthDelegate extends IGoogleAuthDelegate {
  @override
  Future<bool> canAccessScopes(List<String> scopes, {String? accessToken}) {
    throw UnimplementedError();
  }

  @override
  IGoogleSignInAccount? get currentUser => throw UnimplementedError();

  @override
  Future<IGoogleSignInAccount?> disconnect() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isSignedIn() {
    throw UnimplementedError();
  }

  @override
  Stream<IGoogleSignInAccount?> get onCurrentUserChanged =>
      throw UnimplementedError();

  @override
  Future<bool> requestScopes(List<String> scopes) {
    throw UnimplementedError();
  }

  @override
  Future<IGoogleSignInAccount?> signIn() {
    throw UnimplementedError();
  }

  @override
  Future<IGoogleSignInAccount?> signInSilently({
    bool suppressErrors = true,
    bool reAuthenticate = false,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<IGoogleSignInAccount?> signOut() {
    throw UnimplementedError();
  }
}
