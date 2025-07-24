import 'package:auth_management/auth_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_andomie/utils/internet.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class InAppAuthDelegate extends AuthDelegate {
  const InAppAuthDelegate();

  @override
  Future<Response<Credential>> signInWithCredential(Object credential) async {
    if (credential is! AuthCredential) return Response(status: Status.invalid);
    final uc = await FirebaseAuth.instance.signInWithCredential(credential);
    final user = uc.user;
    await user?.reload();
    return Response(
      status: Status.ok,
      data: Credential(
        accessToken: credential.accessToken,
        additionalUserInfo: AdditionalInfo(
          isNewUser: uc.additionalUserInfo?.isNewUser ?? false,
          authorizationCode: uc.additionalUserInfo?.authorizationCode,
          providerId: uc.additionalUserInfo?.providerId,
          profile: uc.additionalUserInfo?.profile,
          username: uc.additionalUserInfo?.username,
        ),
        credential: uc,
        displayName: user?.displayName,
        email: user?.email,
        emailVerified: user?.emailVerified,
        isAnonymous: user?.isAnonymous,
        metadata: Metadata(
          creationTime: user?.metadata.creationTime,
          lastSignInTime: user?.metadata.lastSignInTime,
        ),
        multiFactor: user?.multiFactor,
        phoneNumber: user?.phoneNumber,
        photoURL: user?.photoURL,
        providerData: user?.providerData.map((e) {
          return Info(
            displayName: e.displayName,
            email: e.email,
            phoneNumber: e.phoneNumber,
            photoURL: e.photoURL,
            providerId: e.providerId,
            uid: e.uid,
          );
        }).toList(),
        providerId: credential.providerId,
        signInMethod: credential.signInMethod,
        uid: user?.uid,
      ),
    );
  }

  @override
  Future<Response<Credential>> signInWithGoogle() async {
    try {
      if (!(await Internet.connected)) {
        return Response(status: Status.networkError);
      }
      if (kIsWeb) {
        final auth = GoogleAuthProvider();
        final uc = await FirebaseAuth.instance.signInWithPopup(auth);
        final user = uc.user;
        await user?.reload();
        return Response(
          status: Status.ok,
          data: Credential(
            additionalUserInfo: AdditionalInfo(
              isNewUser: uc.additionalUserInfo?.isNewUser ?? false,
              authorizationCode: uc.additionalUserInfo?.authorizationCode,
              providerId: uc.additionalUserInfo?.providerId,
              profile: uc.additionalUserInfo?.profile,
              username: uc.additionalUserInfo?.username,
            ),
            credential: uc,
            displayName: user?.displayName,
            email: user?.email,
            emailVerified: user?.emailVerified,
            isAnonymous: user?.isAnonymous,
            metadata: Metadata(
              creationTime: user?.metadata.creationTime,
              lastSignInTime: user?.metadata.lastSignInTime,
            ),
            multiFactor: user?.multiFactor,
            phoneNumber: user?.phoneNumber,
            photoURL: user?.photoURL,
            providerData: user?.providerData.map((e) {
              return Info(
                displayName: e.displayName,
                email: e.email,
                phoneNumber: e.phoneNumber,
                photoURL: e.photoURL,
                providerId: e.providerId,
                uid: e.uid,
              );
            }).toList(),
            providerId: auth.providerId,
            signInMethod: "google_prompt",
            uid: user?.uid,
          ),
        );
      } else {
        final googleUser = await GoogleSignIn().signIn();
        final auth = await googleUser?.authentication;
        if (auth == null) return Response();
        final c = GoogleAuthProvider.credential(
          accessToken: auth.accessToken,
          idToken: auth.idToken,
        );
        return Response(
          status: Status.ok,
          data: Credential(
            accessToken: c.accessToken,
            idToken: c.idToken,
            credential: c,
          ),
        );
      }
    } catch (error) {
      return Response(status: Status.failure, error: error.toString());
    }
  }

  @override
  Future<Response<Credential>> signInWithApple() async {
    try {
      if (!(await Internet.connected)) {
        return Response(status: Status.networkError);
      }
      final auth = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final c = OAuthProvider("apple.com").credential(
        idToken: auth.identityToken,
        accessToken: auth.authorizationCode,
      );

      String? displayName;
      if (auth.givenName != null) {
        String last = '';
        if (auth.familyName != null) {
          last = ' ${auth.familyName}';
        }
        displayName = '${auth.givenName} $last';
      }

      return Response(
        status: Status.ok,
        data: Credential(
          displayName: displayName,
          email: auth.email,
          accessToken: c.accessToken,
          idToken: c.idToken,
          credential: c,
        ),
      );
    } catch (error) {
      return Response(status: Status.failure, error: error.toString());
    }
  }
}
