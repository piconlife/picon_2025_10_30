abstract class AesBackend {
  Future<String> encrypt(String plainText, String key, String iv);

  Future<String> decrypt(String cipherBase64, String key, String iv);
}

AesBackend createBackend() {
  throw UnsupportedError('No AesBackend implementation found');
}
