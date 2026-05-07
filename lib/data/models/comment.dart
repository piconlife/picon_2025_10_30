import 'package:flutter_andomie/utils/path_replacer.dart';
import 'package:flutter_entity/entity.dart';

import '../../app/helpers/user.dart';
import '../../features/social/view/widgets/emotion_button.dart';
import '../../roots/services/path_provider.dart';
import '../constants/paths.dart';
import '../enums/comment_type.dart';
import '../enums/privacy.dart';

class CommentKeys extends EntityKey {
  const CommentKeys._();

  static const CommentKeys i = CommentKeys._();

  final text = "text";
  final content = "content";
  final path = "path";
  final pid = "pid";
  final privacy = "privacy";
  final parentPath = "parentPath";
  final type = "type";
  final reacts = "reacts";

  @override
  Iterable<String> get keys => [
    id,
    timeMills,
    text,
    content,
    path,
    pid,
    privacy,
    parentPath,
    type,
    reacts,
  ];
}

class CommentModel extends Entity<CommentKeys> {
  String? text;
  String? content;
  String? path;
  String? publisher;
  Privacy? _privacy;
  String? parentPath;
  CommentType? _type;
  List<String>? reacts;

  bool get isEmpty {
    if ((idOrNull ?? '').isEmpty) return true;
    if ((timeMillsOrNull ?? 0) <= 0) return true;
    if ((text ?? '').isEmpty) return true;
    if ((content ?? '').isEmpty) return true;
    return false;
  }

  bool get isNotEmpty => !isEmpty;

  Privacy get privacy => _privacy ?? Privacy.everyone;

  CommentType get type => _type ?? CommentType.none;

  int get reactCount => reacts?.length ?? 0;

  List<Emotions> get emotions {
    return reactsUidAndSymbol.values
        .map(Emotions.tryParse)
        .whereType<Emotions>()
        .toList();
  }

  Map<String, String> get reactsUidAndSymbol {
    if (reacts == null || reacts!.isEmpty) return {};
    final entries =
        reacts!.map((e) {
          final parts = e.split(":");
          if (parts.length != 2) return null;
          final key = parts[0];
          final value = parts[1];
          return MapEntry(key, value);
        }).whereType<MapEntry<String, String>>();
    return Map.fromEntries(entries);
  }

  Object? get emotionByMe => reactsUidAndSymbol[UserHelper.uid];

  CommentModel.empty();

  CommentModel._({
    super.id,
    super.timeMills,
    this.text,
    this.content,
    this.path,
    this.publisher,
    this.parentPath,
    this.reacts,
    CommentType? type,
    Privacy? privacy,
  }) : _type = type,
       _privacy = privacy;

  CommentModel.create({
    required String super.id,
    required String this.parentPath,
    this.content,
    this.text,
    super.timeMills,
    String? path,
    String? publisher,
    CommentType? type,
    Privacy? privacy,
  }) : assert(content != null || text != null),
       publisher = publisher ?? UserHelper.uid,
       _type = type,
       _privacy = privacy,
       path = PathReplacer.replaceByIterable(
         PathProvider.generatePath(Paths.refComments, id),
         [parentPath],
       ),
       super.auto();

  factory CommentModel.parse(Object? source) {
    if (source is CommentModel) return source;
    if (source is! Map) return CommentModel.empty();
    final key = CommentKeys.i;
    return CommentModel._(
      id: source.entityValue(key.id),
      timeMills: source.entityValue(key.timeMills),
      text: source.entityValue(key.text),
      content: source.entityValue(key.content),
      path: source.entityValue(key.path),
      publisher: source.entityValue(key.pid),
      parentPath: source.entityValue(key.parentPath),
      reacts: source.entityValues(key.reacts),
      privacy: source.entityValue(key.privacy, Privacy.parse),
      type: source.entityValue(key.type, CommentType.parse),
    );
  }

  @override
  CommentKeys makeKey() => CommentKeys.i;

  @override
  Map<String, dynamic> get source {
    return {
      key.id: id,
      key.timeMills: timeMills,
      key.text: text,
      key.content: content,
      key.path: path,
      key.pid: publisher,
      key.parentPath: parentPath,
      key.privacy: privacy.name,
      key.type: type.name,
      key.reacts: reacts,
    };
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      timeMills,
      content,
      text,
      publisher,
      path,
      parentPath,
      hash(reacts),
      _privacy?.index,
      _type?.index,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    if (other is! CommentModel) return false;
    return id == other.id &&
        timeMills == other.timeMills &&
        text == other.text &&
        content == other.content &&
        path == other.path &&
        publisher == other.publisher &&
        parentPath == other.parentPath &&
        equals(reacts, other.reacts) &&
        _privacy == other._privacy &&
        _type == other._type;
  }

  @override
  String toString() => "$CommentModel#$hashCode";
}
