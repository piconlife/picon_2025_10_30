import '../../app/contents/secrets.dart';
import '../utils/encryptor.dart';

class EncryptorHelper extends InAppEncryptor {
  const EncryptorHelper._();

  static InAppEncryptor? _encryptor(SecretData? secrets) {
    if (secrets == null) return null;
    final key = secrets.key ?? "";
    final iv = secrets.iv ?? "";
    final secret = secrets.secret ?? "";
    final version = secrets.version ?? "";
    if (key.isEmpty || iv.isEmpty || secret.isEmpty || version.isEmpty) {
      return null;
    }
    return InAppEncryptor(
      key: key,
      iv: iv,
      passcode: secret,
      version: "$version:",
    );
  }

  static String? findVersion(String? encryptedValue) {
    final x = encryptedValue?.split(":").firstOrNull;
    return x;
  }

  static SecretData? _version(String? version, Secret? secret) {
    version = version?.replaceAll("local.", "");
    if (version == null || version.isEmpty || secret == null) return null;
    return secret.versions[version];
  }

  static InAppEncryptor? object([String? version]) {
    version ??= Secrets.get.object?.active;
    return _encryptor(_version(version, Secrets.get.object));
  }

  static InAppEncryptor? password([String? version]) {
    version ??= Secrets.get.password?.active;
    return _encryptor(_version(version, Secrets.get.password));
  }
}
