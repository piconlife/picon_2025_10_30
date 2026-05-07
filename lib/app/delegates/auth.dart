import '../imports/auth_management.dart'
    show AuthDelegate, Credential, AuthException;
import '../imports/firebase_auth.dart' hide AuthProvider;
import '../imports/flutter_entity.dart' show Response, Status;
import '../imports/local_auth.dart' show LocalAuthentication;

String? _toMail(String prefix, String suffix, [String type = "com"]) {
  return "$prefix@$suffix.$type";
}

class InAppAuthDelegate extends AuthDelegate {
  final firebaseAuth = FirebaseAuth.instance;
  final localAuth = LocalAuthentication();

  InAppAuthDelegate();

  User? get user => FirebaseAuth.instance.currentUser;

  @override
  bool get isAnonymous => user?.isAnonymous ?? false;

  @override
  bool get isAuthenticated => user?.uid != null;

  @override
  Future<String?> get rawUid async => user?.uid;

  @override
  Future<Response<void>> delete() async {
    if (user != null) {
      try {
        return user!.delete().then((value) {
          return Response(
            status: Status.ok,
            message: "Account delete successful!",
          );
        });
      } on FirebaseAuthException catch (error) {
        return Response(status: Status.failure, error: error.message);
      }
    } else {
      return Response(status: Status.invalid, error: "User isn't valid!");
    }
  }

  @override
  Future<bool> isSignIn() async {
    return firebaseAuth.currentUser != null;
  }

  @override
  Future<Response<Credential>> signInAnonymously() async {
    try {
      final result = await firebaseAuth.signInAnonymously();
      return Response(
        status: Status.ok,
        data: result._credential,
        message: "Sign in successful!",
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "operation-not-allowed") {
        return Response(
          status: Status.notSupported,
          error: "Anonymous auth hasn't been enabled for this project.",
        );
      }
      return Response(status: Status.failure, error: e.message);
    }
  }

  @override
  Future<Response<void>> signInWithBiometric() async {
    try {
      final bool check = await localAuth.canCheckBiometrics;
      final bool isSupportable = check || await localAuth.isDeviceSupported();
      if (!isSupportable) {
        return Response(
          error: "Biometric not supported",
          status: Status.notSupported,
        );
      } else {
        if (check) {
          final authenticated = await localAuth.authenticate(
            localizedReason: "Please authenticate to continue",
          );
          if (authenticated) {
            return Response(status: Status.ok);
          } else {
            return Response(
              error: "Authentication failed",
              status: Status.notFound,
            );
          }
        } else {
          return Response(
            error: "Biometric not supported",
            status: Status.undetected,
          );
        }
      }
    } catch (error) {
      return Response(error: error.toString(), status: Status.failure);
    }
  }

  @override
  Future<Response<Credential>> signInWithCredential(Object credential) async {
    if (credential is! AuthCredential) {
      return Response(error: "Credential exception!");
    }
    try {
      final result = await firebaseAuth.signInWithCredential(credential);
      return Response(
        status: Status.ok,
        data: result._credential,
        message: "Sign in successful!",
      );
    } on FirebaseAuthException catch (error) {
      return Response(status: Status.failure, error: error.message);
    }
  }

  @override
  Future<Response<Credential>> signInWithOtp(String verId, String smsCode) {
    final credential = PhoneAuthProvider.credential(
      verificationId: verId,
      smsCode: smsCode,
    );
    return signInWithCredential(credential);
  }

  @override
  Future<Response<Credential>> signInWithEmailNPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Response(
        status: Status.ok,
        data: result._credential,
        message: "Sign in successful!",
      );
    } on FirebaseAuthException catch (error) {
      return Response(status: Status.failure, error: error.message);
    }
  }

  @override
  Future<Response<Credential>> signInWithUsernameNPassword(
    String username,
    String password,
  ) async {
    var mail = _toMail(username, "user", "org");
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
        email: mail ?? "example@user.org",
        password: password,
      );
      return Response(
        status: Status.ok,
        data: result._credential,
        message: "Sign in successful!",
      );
    } on FirebaseAuthException catch (error) {
      return Response(error: error.message, status: Status.failure);
    }
  }

  @override
  Future<Response<Credential>> signUpWithEmailNPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Response(
        status: Status.ok,
        data: result._credential,
        message: "Sign up successful!",
      );
    } on FirebaseAuthException catch (error) {
      return Response(status: Status.failure, error: error.message);
    }
  }

  @override
  Future<Response<Credential>> signUpWithUsernameNPassword(
    String username,
    String password,
  ) async {
    var mail = _toMail(username, "user", "org");
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: mail ?? "example@user.org",
        password: password,
      );
      return Response(
        status: Status.ok,
        data: result._credential,
        message: "Sign up successful!",
      );
    } on FirebaseAuthException catch (error) {
      return Response(status: Status.failure, error: error.message);
    }
  }

  @override
  Future<Response<void>> signOut() async {
    try {
      await firebaseAuth.signOut();
      return Response(status: Status.ok);
    } catch (error) {
      return Response(status: Status.failure, error: error.toString());
    }
  }

  @override
  Future<void> verifyPhoneNumber({
    String? phoneNumber,
    int? forceResendingToken,
    Object? multiFactorInfo,
    Object? multiFactorSession,
    Duration timeout = const Duration(seconds: 30),
    required void Function(Credential credential) onComplete,
    required void Function(AuthException exception) onFailed,
    required void Function(String verId, int? forceResendingToken) onCodeSent,
    required void Function(String verId) onCodeAutoRetrievalTimeout,
  }) async {
    try {
      firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        forceResendingToken: forceResendingToken,
        multiFactorInfo:
            multiFactorInfo is PhoneMultiFactorInfo ? multiFactorInfo : null,
        multiFactorSession:
            multiFactorSession is MultiFactorSession
                ? multiFactorSession
                : null,
        timeout: timeout,
        verificationCompleted: (credential) {
          onComplete(
            Credential(
              verificationId: credential.verificationId,
              smsCode: credential.smsCode,
            ),
          );
        },
        verificationFailed: (e) {
          onFailed(AuthException(e.message ?? "", e.code));
        },
        codeSent: onCodeSent,
        codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
      );
    } catch (error) {
      throw AuthException(error.toString());
    }
  }
}

extension on UserCredential {
  Credential get _credential {
    return Credential(
      credential: credential,
      displayName: user?.displayName,
      email: user?.email,
      phoneNumber: user?.phoneNumber,
      photoURL: user?.photoURL,
      uid: user?.uid ?? '',
    );
  }
}
