part of 'base.dart';

mixin _SourceEncryptionMixin<T extends Entity> {
  DataEncryptor? get encryptor;

  bool get isEncryptor => encryptor != null;

  Future<Map<String, dynamic>> decryptDoc(Map<String, dynamic> doc) async {
    if (!isEncryptor) return doc;
    final out = await encryptor!.output(doc);
    return out;
  }

  Future<Map<String, dynamic>?> encryptDoc(Map<String, dynamic> data) async {
    if (!isEncryptor) return null;
    return encryptor!.input(data);
  }
}
