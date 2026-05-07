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

  crypto.Encrypter get _en =>
      crypto.Encrypter(crypto.AES(_key, mode: crypto.AESMode.cbc));

  Future<Map<String, dynamic>> input(dynamic data) async {
    if (data is! Map<String, dynamic>) return {};
    try {
      final encrypted = _en.encrypt(jsonEncode(data), iv: _iv);
      return request(encrypted.base64, passcode);
    } catch (e, st) {
      debugPrint('DataEncryptor.input error: $e\n$st');
      return {};
    }
  }

  Future<Map<String, dynamic>> output(dynamic data) async {
    if (data is! Map<String, dynamic>) return {};
    try {
      final value = response(data);
      if (value is! String) return {};
      final encrypted = crypto.Encrypted.fromBase64(value);
      final decoded = _en.decrypt(encrypted, iv: _iv);
      return jsonDecode(decoded);
    } catch (e, st) {
      debugPrint('DataEncryptor.output error: $e\n$st');
      return {};
    }
  }

  static String generateKey([DataByteType type = DataByteType.x16]) =>
      DataIdGenerator.generate(type).secretKey;

  static String generateIV([DataByteType type = DataByteType.x8]) =>
      DataIdGenerator.generate(type).secretIV;
}

extension DataEncryptorHelper on DataEncryptor? {
  bool get isValid => this != null;

  Future<Map<String, dynamic>> input(dynamic data) async =>
      isValid ? await this!.input(data) : {};

  Future<Map<String, dynamic>> output(dynamic data) async =>
      isValid ? await this!.output(data) : {};
}