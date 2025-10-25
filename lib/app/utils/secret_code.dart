import 'dart:math';

class ID {
  const ID._();

  static String code({
    int length = 8,
    String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
  }) {
    final r = Random.secure();
    final codes = Iterable.generate(length, (_) {
      return chars.codeUnitAt(r.nextInt(chars.length));
    });
    return String.fromCharCodes(codes);
  }

  static String filter(String text, {String? chars}) {
    chars ??= "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    return text.split('').where((e) {
      if (chars == null || chars.isEmpty) return true;
      return chars.contains(e);
    }).join();
  }
}

class SecretCode {
  final int _private;

  SecretCode._([String? key])
    : _private = (key ?? '').codeUnits.fold(0, (prev, e) => prev + e) % 256;

  SecretCode(String key) : this._(key);

  static SecretCode? _i;

  static SecretCode get i => _i ??= SecretCode._();

  static void init(String key) => _i = SecretCode._(key);

  String encode(String text, {String? public}) {
    public ??= "";
    final pub = public.codeUnits.fold(0, (p, e) => p + e) % 256;
    final key = (_private + pub % 256) % 256;
    final encoded = text.codeUnits.map((c) => (c + key) % 256).toList();
    return encoded.map((e) => e.toRadixString(36).padLeft(2, '0')).join();
  }

  String decode(String secret, {String? public}) {
    public ??= "";
    final pub = public.codeUnits.fold(0, (p, e) => p + e) % 256;
    final key = (_private + pub % 256) % 256;

    final parts =
        Iterable.generate(
          secret.length ~/ 2,
          (i) => int.parse(secret.substring(i * 2, i * 2 + 2), radix: 36),
        ).toList();

    final decoded = parts.map((c) => (c - key + 256) % 256).toList();
    return String.fromCharCodes(decoded);
  }
}

extension SecretCodeExtension on String {
  String encode({String? private, String? public}) {
    if (private == null || private.isEmpty) {
      return SecretCode.i.encode(this, public: public);
    }
    return SecretCode(private).encode(this, public: public);
  }

  String decode({String? private, String? public}) {
    if (private == null || private.isEmpty) {
      return SecretCode.i.decode(this, public: public);
    }
    return SecretCode(private).decode(this, public: public);
  }
}

extension SecretCodeExtensionNullable on String? {
  String? encode({String? private, String? public}) {
    final text = this;
    if (text == null || text.isEmpty) return null;
    return text.encode(private: private, public: public);
  }

  String? decode({String? private, String? public}) {
    final secret = this;
    if (secret == null || secret.isEmpty) return null;
    return secret.decode(private: private, public: public);
  }
}
