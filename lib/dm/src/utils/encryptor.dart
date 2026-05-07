import 'dart:convert';

import 'package:encrypt/encrypt.dart' as crypto;
import 'package:flutter/foundation.dart';

import 'configs.dart';

typedef EncryptorRequestBuilder =
    Map<String, dynamic> Function(String request, String passcode);

typedef EncryptorResponseBuilder = dynamic Function(Map<String, dynamic> data);

class _EncodePayload {
  final Map<String, dynamic> data;
  final String key;
  final String iv;
  final String passcode;
  final EncryptorRequestBuilder request;

  const _EncodePayload({
    required this.data,
    required this.key,
    required this.iv,
    required this.passcode,
    required this.request,
  });
}

class _DecodePayload {
  final Map<String, dynamic> source;
  final String key;
  final String iv;
  final EncryptorResponseBuilder response;

  const _DecodePayload({
    required this.source,
    required this.key,
    required this.iv,
    required this.response,
  });
}

Future<Map<String, dynamic>> _encode(_EncodePayload p) async {
  try {
    final k = crypto.Key.fromUtf8(p.key);
    final iv = crypto.IV.fromUtf8(p.iv);
    final en = crypto.Encrypter(crypto.AES(k, mode: crypto.AESMode.cbc));
    final encrypted = en.encrypt(jsonEncode(p.data), iv: iv);
    return p.request(encrypted.base64, p.passcode);
  } catch (e, st) {
    debugPrint('DataEncryptor.encode error: $e\n$st');
    return {};
  }
}

Future<Map<String, dynamic>> _decode(_DecodePayload p) async {
  try {
    final value = p.response(p.source);
    if (value is String) {
      final k = crypto.Key.fromUtf8(p.key);
      final iv = crypto.IV.fromUtf8(p.iv);
      final en = crypto.Encrypter(crypto.AES(k, mode: crypto.AESMode.cbc));
      final encrypted = crypto.Encrypted.fromBase64(value);
      final data = en.decrypt(encrypted, iv: iv);
      return jsonDecode(data);
    }
    return {};
  } catch (e, st) {
    debugPrint('DataEncryptor.decode error: $e\n$st');
    return {};
  }
}

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

  Future<Map<String, dynamic>> input(dynamic data) {
    if (data is! Map<String, dynamic>) return Future.value({});
    return compute(
      _encode,
      _EncodePayload(
        data: data,
        key: key,
        iv: iv,
        passcode: passcode,
        request: request,
      ),
    );
  }

  Future<Map<String, dynamic>> output(dynamic data) {
    if (data is! Map<String, dynamic>) return Future.value({});
    return compute(
      _decode,
      _DecodePayload(source: data, key: key, iv: iv, response: response),
    );
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
