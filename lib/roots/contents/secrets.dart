import 'package:equatable/equatable.dart';
import 'package:in_app_configs/configs.dart';

const _kSecrets = "secrets";
const _kObject = 'object';
const _kPassword = 'password';
const _kActive = 'active';
const _kFallback = 'fallback';
const _kVersions = 'versions';
const _kIV = 'iv';
const _kKey = 'key';
const _kSecret = 'secret';
const _kVersion = 'version';

class Secrets extends Equatable {
  final Secret? object;
  final Secret? password;

  const Secrets({this.object, this.password});

  static Secrets get get {
    final x = Configs.getByName(_kSecrets, parser: Secrets.parse);
    return x ?? Secrets();
  }

  factory Secrets.parse(Object? source, {Secrets? defaultValue}) {
    if (source is! Map) return defaultValue ?? Secrets();
    final object = source[_kObject];
    final password = source[_kPassword];
    return Secrets(
      object: Secret.parse(object, defaultValue: defaultValue?.object),
      password: Secret.parse(password, defaultValue: defaultValue?.password),
    );
  }

  @override
  List<Object?> get props => [object, password];

  @override
  String toString() => "$Secrets($_kObject: $object, $_kPassword: $password)";
}

class Secret extends Equatable {
  final String? active;
  final SecretData? fallback;
  final Map<String, SecretData> versions;

  SecretData get data => versions[active] ?? fallback ?? SecretData();

  const Secret({this.active, this.fallback, this.versions = const {}});

  factory Secret.parse(Object? source, {Secret? defaultValue}) {
    if (source is! Map) return defaultValue ?? Secret();
    final active = source[_kActive];
    final fallback = source[_kFallback];
    final versions = source[_kVersions];
    final mFallback = SecretData.parse(
      _kFallback,
      fallback,
      defaultValue: defaultValue?.fallback,
    );
    final entries =
        versions is Map && versions.isNotEmpty
            ? versions.entries.map((e) {
              if (e.value is! Map) return null;
              return MapEntry(
                e.key.toString(),
                SecretData.parse(e.key, e.value, defaultValue: mFallback),
              );
            }).whereType<MapEntry<String, SecretData>>()
            : null;

    return Secret(
      active:
          active is String && active.isNotEmpty ? active : defaultValue?.active,
      fallback: mFallback,
      versions:
          entries != null && entries.isNotEmpty
              ? Map.fromEntries(entries)
              : defaultValue?.versions ?? {},
    );
  }

  @override
  List<Object?> get props => [active, fallback, versions];

  @override
  String toString() => "$Secret($_kActive: $active, $_kVersions: $versions)";
}

class SecretData extends Equatable {
  final String? iv;
  final String? key;
  final String? secret;
  final String? version;

  const SecretData({this.iv, this.key, this.secret, this.version});

  factory SecretData.parse(
    String version,
    Object? source, {
    SecretData? defaultValue,
  }) {
    if (source is! Map) return defaultValue ?? SecretData();
    String? iv = source[_kIV];
    String? key = source[_kKey];
    String? secret = source[_kSecret];
    return SecretData(
      version: version,
      iv: iv is String && iv.isNotEmpty ? iv : defaultValue?.iv,
      key: key is String && key.isNotEmpty ? key : defaultValue?.key,
      secret:
          secret is String && secret.isNotEmpty ? secret : defaultValue?.secret,
    );
  }

  @override
  List<Object?> get props => [iv, key, secret, version];

  @override
  String toString() {
    return "$SecretData($_kIV: $iv, $_kKey: $key, $_kSecret: $secret, $_kVersion: $version)";
  }
}
