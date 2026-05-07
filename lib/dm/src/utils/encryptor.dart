import 'dart:convert';

import 'package:encrypt/encrypt.dart' as crypto;
import 'package:flutter/foundation.dart';

import 'configs.dart';

typedef EncryptorRequestBuilder =
Map<String, dynamic> Function(String request, String passcode);

typedef EncryptorResponseBuilder = dynamic Function(Map<String, dynamic> data);

class DataEncryptor {
  final String key;
  final String iv;
  final String passcode;

  final EncryptorRequestBuilder? _request;
  final EncryptorResponseBuilder? _response;

  EncryptorResponseBuilder get response => _response ?? (a) => a["data"];
  EncryptorRequestBuilder get request => _request ?? (a, b) => {"data": a};

  const DataEncryptor({
    required this.key,
    required this.iv,
    required this.passcode,
    EncryptorRequestBuilder? request,
    EncryptorResponseBuilder? response,
  }) : _request = request,
       _response = response;

  crypto.Key get _key => crypto.Key.fromUtf8(key);
  crypto.IV get _iv => crypto.IV.fromUtf8(iv);

  crypto.Encrypter get _en {
    return crypto.Encrypter(crypto.AES(_key, mode: crypto.AESMode.cbc));
  }

  Future<Map<String, dynamic>> input(dynamic data) => compute(_encode, data);

  Future<Map<String, dynamic>> output(dynamic data) => compute(_decode, data);

  Future<Map<String, dynamic>> _encode(dynamic data) async {
    try {
      if (data is Map<String, dynamic>) {
        final encrypted = _en.encrypt(jsonEncode(data), iv: _iv);
        return request(encrypted.base64, passcode);
      }
      return {};
    } catch (e, st) {
      debugPrint('DataEncryptor.encode error: $e\n$st');
      return {};
    }
  }

  Future<Map<String, dynamic>> _decode(dynamic source) async {
    try {
      if (source is Map<String, dynamic>) {
        final value = await response(source);
        if (value is String) {
          final encrypted = crypto.Encrypted.fromBase64(value);
          final data = _en.decrypt(encrypted, iv: _iv);
          return jsonDecode(data);
        }
      }
      return {};
    } catch (e, st) {
      debugPrint('DataEncryptor.decode error: $e\n$st');
      return {};
    }
  }

  static String generateKey([DataByteType type = DataByteType.x16]) {
    return DataIdGenerator.generate(type).secretKey;
  }

  static String generateIV([DataByteType type = DataByteType.x8]) {
    return DataIdGenerator.generate(type).secretIV;
  }
}

extension DataEncryptorHelper on DataEncryptor? {
  bool get isValid => this != null;

  Future<Map<String, dynamic>> input(dynamic data) async {
    return isValid ? await this!.input(data) : {};
  }

  Future<Map<String, dynamic>> output(dynamic data) async {
    return isValid ? await this!.output(data) : {};
  }
}