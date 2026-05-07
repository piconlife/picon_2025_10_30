import 'dart:convert' show jsonEncode, jsonDecode;

import 'package:flutter/foundation.dart' show debugPrint;

import '../utils/id_generator.dart' show DataByteType, DataIdGenerator;
import 'encryptor_stub.dart'
    if (dart.library.io) 'encryptor_io.dart'
if (dart.library.js_interop) 'encryptor_web.dart';

typedef EncryptorRequestBuilder =
Map<String, dynamic> Function(String request, String passcode);

typedef EncryptorResponseBuilder = dynamic Function(Map<String, dynamic> data);

class DataEncryptor {
  final String key;
  final String iv;
  final String passcode;
  final AesBackend _backend;

  final EncryptorRequestBuilder? _request;
  final EncryptorResponseBuilder? _response;

  EncryptorResponseBuilder get response => _response ?? (a) => a['data'];

  EncryptorRequestBuilder get request => _request ?? (a, b) => {'data': a};

  DataEncryptor({
    required this.key,
    required this.iv,
    required this.passcode,
    EncryptorRequestBuilder? request,
    EncryptorResponseBuilder? response,
  }) : _request = request,
       _response = response,
       _backend = createBackend();

  Future<Map<String, dynamic>> input(dynamic data) async {
    if (data is! Map<String, dynamic>) return {};
    try {
      final encrypted = await _backend.encrypt(jsonEncode(data), key, iv);
      return request(encrypted, passcode);
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
      final decrypted = await _backend.decrypt(value, key, iv);
      final decoded = jsonDecode(decrypted);
      if (decoded is! Map<String, dynamic>) return {};
      return decoded;
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