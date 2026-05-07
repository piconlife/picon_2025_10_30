import 'dart:convert' show utf8, base64Encode, base64Decode;
import 'dart:js_interop'
    show
        JSObject,
        ByteBufferToJSArrayBuffer,
        JSArrayBuffer,
        NullableObjectUtilExtension,
        StringToJSString,
        ListToJSArray,
        JSPromiseToFuture,
        JSArrayBufferToByteBuffer;
import 'dart:typed_data' show Uint8List;

import 'package:web/web.dart' as web;

import '_encryptor_stub.dart' show AesBackend;

class _WebAesBackend implements AesBackend {
  const _WebAesBackend();

  Uint8List _toBytes(String s) => Uint8List.fromList(utf8.encode(s));

  Future<web.CryptoKey> _importKey(String key) async {
    final keyBytes = _toBytes(key);
    final cryptoKey =
        await web.window.crypto.subtle
            .importKey(
              'raw',
              keyBytes.buffer.toJS,
              {'name': 'AES-CBC'}.jsify() as JSObject,
              false,
              ['encrypt', 'decrypt'].map((e) => e.toJS).toList().toJS,
            )
            .toDart;
    return cryptoKey;
  }

  JSObject _aesCbc(Uint8List iv) =>
      {'name': 'AES-CBC', 'iv': iv.buffer.toJS}.jsify() as JSObject;

  @override
  Future<String> encrypt(String plainText, String key, String iv) async {
    final cryptoKey = await _importKey(key);
    final dataBytes = _toBytes(plainText);

    final encrypted =
        await web.window.crypto.subtle
            .encrypt(_aesCbc(_toBytes(iv)), cryptoKey, dataBytes.buffer.toJS)
            .toDart;

    return base64Encode((encrypted as JSArrayBuffer).toDart.asUint8List());
  }

  @override
  Future<String> decrypt(String cipherBase64, String key, String iv) async {
    final cryptoKey = await _importKey(key);
    final cipherBytes = base64Decode(cipherBase64);

    final decrypted =
        await web.window.crypto.subtle
            .decrypt(_aesCbc(_toBytes(iv)), cryptoKey, cipherBytes.buffer.toJS)
            .toDart;

    return utf8.decode((decrypted as JSArrayBuffer).toDart.asUint8List());
  }
}

AesBackend createBackend() => const _WebAesBackend();
