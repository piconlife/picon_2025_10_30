import 'package:flutter_entity/flutter_entity.dart';

class DataWriteRef {
  final String path;
  final Map<String, dynamic> create;
  final Map<String, dynamic> update;

  const DataWriteRef.create(this.path, this.create) : update = const {};

  const DataWriteRef.update(this.path, this.update) : create = const {};

  Map<String, dynamic> get metadata {
    return {
      "path": path,
      if (create.isNotEmpty) "create": create,
      if (update.isNotEmpty) "update": update,
    };
  }

  @override
  int get hashCode => path.hashCode ^ create.hashCode ^ update.hashCode;

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DataWriteRef) return false;
    return path == other.path &&
        create == other.create &&
        update == other.update;
  }

  @override
  String toString() {
    return '$DataWriteRef(path: $path, create: $create, update: $update)';
  }
}

class PublisherKeys extends EntityKey {
  const PublisherKeys._();

  static PublisherKeys? _i;

  static PublisherKeys get i => _i ??= PublisherKeys._();

  @override
  Iterable<String> get keys => [id, timeMills, name];
  final name = "name";
  final path = "path";
}

class Publisher extends Entity<PublisherKeys> {
  final String? name;
  final String? path;

  const Publisher({super.id, super.timeMills, this.name, this.path});

  factory Publisher.parse(Object? source) {
    return Publisher(
      id: source.entityValue(PublisherKeys.i.id),
      timeMills: source.entityValue(PublisherKeys.i.timeMills),
      name: source.entityValue(PublisherKeys.i.name),
    );
  }

  @override
  PublisherKeys makeKey() => PublisherKeys.i;

  @override
  Map<String, dynamic> get source {
    return {key.id: id, key.timeMills: timeMills, key.name: name};
  }

  Map<String, dynamic> get metadata {
    return {key.path: path, "create": source};
  }

  @override
  int get hashCode => source.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Publisher) return false;
    return source == other.source;
  }

  @override
  String toString() => "$Publisher#$hashCode($source)";
}

class Keys extends EntityKey {
  const Keys._();

  static Keys? _i;

  static Keys get i => _i ??= Keys._();

  final publisher = "publisher";
  final publisherId = "publisherId";
  final publisherRef = "@publisher";

  final path = "path";
  final description = "description";
  final photo = "photo";
  final privacy = "privacy";
}

class Content extends Entity<Keys> {
  Publisher? _publisher;
  String? _publisherId;

  Publisher get publisher => _publisher ?? Publisher();

  Content({
    super.id,
    super.timeMills,
    String? publisherId,
    Publisher? publisher,
  }) : _publisher = publisher,
       _publisherId = publisherId;

  factory Content.parse(Object? source) {
    return Content(
      id: source.entityValue(Keys.i.id),
      timeMills: source.entityValue(Keys.i.timeMills),
    );
  }

  Iterable<String> get keys => key.keys;

  @override
  bool isInsertable(String key, value) {
    return value != null && keys.contains(key);
  }

  @override
  Keys makeKey() => Keys.i;

  @override
  Map<String, dynamic> get source {
    return {
      key.id: id,
      key.timeMills: timeMills,
      key.publisherId: _publisherId,
      key.publisherRef: _publisher?.metadata,
    };
  }

  @override
  int get hashCode => id.hashCode ^ timeMills.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Content && other.id == id && other.timeMills == timeMills;
  }

  @override
  String toString() {
    return '$Content(id: $id, timeMills: $timeMills)';
  }
}
