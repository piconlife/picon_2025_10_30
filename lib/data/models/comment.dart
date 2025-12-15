import 'package:flutter_andomie/utils/path_replacer.dart';
import 'package:flutter_entity/entity.dart';

import '../../app/helpers/user.dart';
import '../../roots/services/path_provider.dart';
import '../constants/paths.dart';
import '../enums/comment_type.dart';
import '../enums/privacy.dart';

class CommentKeys extends EntityKey {
  const CommentKeys._();

  static const CommentKeys i = CommentKeys._();

  final content = "content";
  final path = "path";
  final pid = "pid";
  final privacy = "privacy";
  final parentPath = "parentPath";
  final type = "type";

  @override
  Iterable<String> get keys => [
    id,
    timeMills,
    content,
    path,
    pid,
    privacy,
    parentPath,
    type,
  ];
}

class CommentModel extends Entity<CommentKeys> {
  String? content;
  String? path;
  String? publisher;
  Privacy? _privacy;
  String? parentPath;
  CommentType? _type;

  Privacy get privacy => _privacy ?? Privacy.everyone;

  CommentType get type => _type ?? CommentType.none;

  CommentModel.empty();

  CommentModel._({
    super.id,
    super.timeMills,
    this.content,
    this.path,
    this.publisher,
    this.parentPath,
    CommentType? type,
    Privacy? privacy,
  }) : _type = type,
       _privacy = privacy;

  CommentModel.create({
    required String super.id,
    required String this.parentPath,
    required this.content,
    super.timeMills,
    String? path,
    String? publisher,
    CommentType? type,
    Privacy? privacy,
  }) : publisher = publisher ?? UserHelper.uid,
       _type = type,
       _privacy = privacy,
       path = PathReplacer.replaceByIterable(
         PathProvider.generatePath(Paths.refComments, id),
         [parentPath],
       ),
       super.auto();

  factory CommentModel.parse(Object? source) {
    if (source is! Map) return CommentModel.empty();
    final key = CommentKeys.i;
    return CommentModel._(
      id: source.entityValue(key.id),
      timeMills: source.entityValue(key.timeMills),
      content: source.entityValue(key.content),
      path: source.entityValue(key.path),
      publisher: source.entityValue(key.pid),
      parentPath: source.entityValue(key.parentPath),
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
      key.content: content,
      key.path: path,
      key.pid: publisher,
      key.parentPath: parentPath,
      key.privacy: privacy.name,
      key.type: type.name,
    };
  }

  @override
  int get hashCode =>
      id.hashCode ^
      timeMills.hashCode ^
      content.hashCode ^
      path.hashCode ^
      publisher.hashCode ^
      parentPath.hashCode ^
      privacy.hashCode ^
      type.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CommentModel) return false;
    return id == other.id &&
        timeMills == other.timeMills &&
        content == other.content &&
        path == other.path &&
        publisher == other.publisher &&
        parentPath == other.parentPath &&
        privacy == other.privacy &&
        type == other.type;
  }

  @override
  String toString() => "$CommentModel#$hashCode($filtered)";
}
