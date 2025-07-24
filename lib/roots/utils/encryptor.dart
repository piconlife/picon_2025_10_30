import 'dart:developer';

import 'package:encrypt/encrypt.dart' as crypto;
import 'package:flutter/foundation.dart';
import 'package:flutter_andomie/utils.dart';

/// Utility class for encryption and decryption operations.
class InAppEncryptor {
  /// Encryption key.
  final String key;

  /// Initialization vector (IV) for encryption.
  final String iv;

  /// Passcode for encryption and decryption.
  final String passcode;

  final String version;

  /// Creates an instance of Encryptor with optional request and response builders.
  ///
  /// Example:
  ///
  /// ```dart
  /// Encryptor encryptor = Encryptor(request: myRequestBuilder, response: myResponseBuilder);
  /// ```
  const InAppEncryptor({
    this.key = "A79842D8A13A10A6DD27759BD700E292",
    this.iv = "9777298A5D7A8AFA",
    this.passcode = "",
    this.version = "v1",
  });

  static InAppEncryptor? _i;

  static InAppEncryptor get i {
    return _i ??= InAppEncryptor();
  }

  /// Gets the encryption key as a cryptographic key.
  crypto.Key get _key => crypto.Key.fromUtf8(key);

  /// Gets the initialization vector (IV) as a cryptographic IV.
  crypto.IV get _iv => crypto.IV.fromUtf8(iv);

  /// Gets the encrypter instance using AES encryption with CBC mode.
  crypto.Encrypter get _en {
    return crypto.Encrypter(crypto.AES(_key, mode: crypto.AESMode.cbc));
  }

  /// Encrypts the input data and returns the encrypted result as a Map.
  Future<String?> input(String? data) => compute(encode, data);

  /// Decrypts the input data and returns the decrypted result as a Map.
  Future<String?> output(String? data) => compute(decode, data);

  /// Encoder function for encrypting data.
  String? encode(
    String? data, {
    bool usePasscode = false,
    bool useVersion = false,
  }) {
    if (data == null || data.isEmpty) return null;
    try {
      final encrypted = _en.encrypt(data, iv: _iv);
      final en = encrypted.base64;
      return '${useVersion ? version : ''}${usePasscode ? passcode : ''}$en';
    } catch (error) {
      log("ENCODER ERROR: $error");
      return null;
    }
  }

  /// Decoder function for decrypting data.
  String? decode(String? source) {
    if (source == null || source.isEmpty) return null;
    try {
      if (source.contains(version)) source = source.replaceAll(version, '');
      if (source.contains(passcode)) source = source.replaceAll(passcode, '');
      final encrypted = crypto.Encrypted.fromBase64(source);
      final data = _en.decrypt(encrypted, iv: _iv);
      return data;
    } catch (error) {
      log("DECODER ERROR: $error");
      return null;
    }
  }

  /// Generates a random encryption key based on the specified byte type.
  ///
  /// Example:
  ///
  /// ```dart
  /// String generatedKey = Encryptor.generateKey(ByteType.x16);
  /// ```
  static String generateKey([KeyByteType type = KeyByteType.x16]) {
    return KeyGenerator.secretKey(type);
  }

  /// Generates a random initialization vector (IV) based on the specified byte type.
  ///
  /// Example:
  ///
  /// ```dart
  /// String generatedIV = Encryptor.generateIV(ByteType.x8);
  /// ```
  static String generateIV([KeyByteType type = KeyByteType.x8]) {
    return KeyGenerator.secretKey(type);
  }
}
