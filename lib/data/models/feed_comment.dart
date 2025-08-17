import 'package:flutter_entity/entity.dart';

import '../enums/comment_type.dart';
import '../enums/privacy.dart';

class FeedCommentKeys extends EntityKey {
  const FeedCommentKeys._();

  static const FeedCommentKeys i = FeedCommentKeys._();

  final content = "content";
  final path = "path";
  final pid = "pid";
  final privacy = "privacy";
  final ref = "ref";
  final type = "type";
}

class FeedComment extends Entity<FeedCommentKeys> {
  String? content;
  String? path;
  String? publisher;
  Privacy? _privacy;
  String? reference;
  CommentType? _type;

  Privacy get privacy => _privacy ?? Privacy.everyone;

  CommentType get type => _type ?? CommentType.none;

  FeedComment.empty();

  FeedComment._({
    super.id,
    super.timeMills,
    this.content,
    this.path,
    this.publisher,
    this.reference,
    CommentType? type,
    Privacy? privacy,
  }) : _type = type,
       _privacy = privacy;

  FeedComment.create({
    required super.id,
    required super.timeMills,
    required this.content,
    required this.path,
    required this.publisher,
    required this.reference,
    required CommentType type,
    required Privacy privacy,
  });

  factory FeedComment.parse(Object? source) {
    if (source is! Map) return FeedComment.empty();
    final key = FeedCommentKeys.i;
    return FeedComment._(
      id: source.entityValue(key.id),
      timeMills: source.entityValue(key.timeMills),
      content: source.entityValue(key.content),
      path: source.entityValue(key.path),
      publisher: source.entityValue(key.pid),
      reference: source.entityValue(key.ref),
      privacy: source.entityValue(key.privacy, Privacy.parse),
      type: source.entityValue(key.type, CommentType.parse),
    );
  }

  @override
  FeedCommentKeys makeKey() => FeedCommentKeys.i;

  @override
  Map<String, dynamic> get source {
    return {
      key.id: id,
      key.timeMills: timeMills,
      key.content: content,
      key.path: path,
      key.pid: publisher,
      key.ref: reference,
      key.privacy: privacy,
      key.type: type,
    };
  }

  @override
  int get hashCode =>
      id.hashCode ^
      timeMills.hashCode ^
      content.hashCode ^
      path.hashCode ^
      publisher.hashCode ^
      reference.hashCode ^
      privacy.hashCode ^
      type.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FeedComment) return false;
    return id == other.id &&
        timeMills == other.timeMills &&
        content == other.content &&
        path == other.path &&
        publisher == other.publisher &&
        reference == other.reference &&
        privacy == other.privacy &&
        type == other.type;
  }

  @override
  String toString() => "$FeedComment#$hashCode($filtered)";
}
