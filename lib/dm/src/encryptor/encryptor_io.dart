import 'package:encrypt/encrypt.dart'
    as crypto
    show Encrypter, AESMode, Key, AES, IV, Encrypted;

import 'encryptor_stub.dart' show AesBackend;

class _IoAesBackend implements AesBackend {
  const _IoAesBackend();

  crypto.Encrypter _encrypter(String key) => crypto.Encrypter(
    crypto.AES(crypto.Key.fromUtf8(key), mode: crypto.AESMode.cbc),
  );

  @override
  Future<String> encrypt(String plainText, String key, String iv) async {
    final encrypted = _encrypter(
      key,
    ).encrypt(plainText, iv: crypto.IV.fromUtf8(iv));
    return encrypted.base64;
  }

  @override
  Future<String> decrypt(String cipherBase64, String key, String iv) async {
    return _encrypter(key).decrypt(
      crypto.Encrypted.fromBase64(cipherBase64),
      iv: crypto.IV.fromUtf8(iv),
    );
  }
}

AesBackend createBackend() => const _IoAesBackend();
