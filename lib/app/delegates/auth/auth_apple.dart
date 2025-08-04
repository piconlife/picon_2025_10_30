import 'package:auth_management/auth_management.dart';

class InAppAppleAuthDelegate extends IAppleAuthDelegate {
  @override
  Future<IAppleAuthorizationCredentialAppleID> getAppleIDCredential({
    required List<IAppleIDAuthorizationScopes> scopes,
    IAppleWebAuthenticationOptions? webAuthenticationOptions,
    String? nonce,
    String? state,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<IAppleCredentialState> getCredentialState(String userIdentifier) {
    throw UnimplementedError();
  }

  @override
  Future<IAppleAuthorizationCredentialPassword> getKeychainCredential() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isAvailable() {
    throw UnimplementedError();
  }
}
