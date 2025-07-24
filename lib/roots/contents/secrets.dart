import 'package:equatable/equatable.dart';
import 'package:flutter_andomie/utils/settings.dart';

class Secrets extends Equatable {
  final Secret? object;
  final Secret? password;

  static Secrets get get => Secrets.from(Settings.get("secrets", {}));

  const Secrets({this.object, this.password});

  factory Secrets.from(Object? source) {
    if (source is! Map) return Secrets();
    final object = source["object"];
    final password = source["password"];
    return Secrets(
      object: object is Map ? Secret.json(object) : null,
      password: password is Map ? Secret.json(password) : null,
    );
  }

  @override
  List<Object?> get props => [object, password];
}

class Secret extends Equatable {
  final String? active;
  final Map<String, EncryptionSecrets>? versions;

  const Secret._({this.active, this.versions});

  factory Secret.json(Object? source) {
    if (source is! Map) return Secret._();
    final active = source["active"];
    final versions = source["versions"];
    final entries = versions is Map
        ? versions.entries.map((e) {
            if (e.value is! Map) return null;
            return MapEntry(e.key.toString(), EncryptionSecrets.json(e.value));
          }).whereType<MapEntry<String, EncryptionSecrets>>()
        : null;
    return Secret._(
      active: active is String ? active : null,
      versions: entries != null && entries.isNotEmpty
          ? Map.fromEntries(entries)
          : null,
    );
  }

  @override
  List<Object?> get props => [active, versions];
}

class EncryptionSecrets extends Equatable {
  final String? iv;
  final String? key;
  final String? secret;
  final String? version;

  const EncryptionSecrets._({this.iv, this.key, this.secret, this.version});

  factory EncryptionSecrets.json(Object? source) {
    if (source is! Map) return EncryptionSecrets._();
    String? iv = source["iv"];
    String? key = source["key"];
    String? secret = source["secret"];
    String? version = source["version"];
    return EncryptionSecrets._(
      iv: iv is String ? iv : null,
      key: key is String ? key : null,
      secret: secret is String ? secret : null,
      version: version is String ? version : null,
    );
  }

  @override
  List<Object?> get props => [iv, key, secret, version];
}
