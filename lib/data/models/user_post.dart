import 'package:flutter_andomie/utils/path_replacer.dart';

import '../constants/content_types.dart';
import '../constants/paths.dart';
import '../enums/audience.dart';
import '../enums/content_state.dart';
import '../enums/feed_type.dart';
import '../enums/privacy.dart';
import 'content.dart';

class PostModel extends ContentModel {
  @override
  Iterable<String> get keys => [
    key.id,
    key.timeMills,
    key.contentType,
    key.publisherId,
    key.path,
    key.audience,
    key.privacy,
    key.type,
    key.title,
    key.description,
    key.tags,
    key.contentRef,
    key.photosRef,
    key.commentCountRef,
    key.likeCountRef,
    key.starCountRef,
  ];

  PostModel({
    super.id,
    super.timeMills,
    super.publisherId,
    super.path,
    super.audience,
    super.privacy,
    super.type,
    super.title,
    super.description,
    super.tags,
    super.photos,
    super.content,
    super.contentRef,
    super.commentCountRef,
    super.likeCountRef,
    super.starCountRef,
    super.uiState,
  }) : super(contentType: ContentType.userPost);

  PostModel.create({
    required String super.id,
    required super.timeMills,
    required String super.publisherId,
    required super.audience,
    required super.privacy,
    required super.type,
    required super.title,
    required super.description,
    required super.tags,
    super.photos,
    String? path,
  }) : super(
         contentType: ContentType.userPost,
         path:
             path ??
             PathReplacer.replaceByIterable(Paths.userPost, [publisherId, id]),
         uiState: ContentUiState.processing,
       );

  PostModel.createForAvatar({
    required String super.id,
    required super.timeMills,
    required String super.publisherId,
    required super.content,
    String? path,
  }) : super(
         type: FeedType.avatar,
         contentType: ContentType.userPost,
         path:
             path ??
             PathReplacer.replaceByIterable(Paths.userPost, [publisherId, id]),
         uiState: ContentUiState.processing,
       );

  PostModel.createForCover({
    required String super.id,
    required super.timeMills,
    required String super.publisherId,
    required super.content,
    String? path,
  }) : super(
         type: FeedType.cover,
         contentType: ContentType.userPost,
         path:
             path ??
             PathReplacer.replaceByIterable(Paths.userPost, [publisherId, id]),
         uiState: ContentUiState.processing,
       );

  factory PostModel.parse(Object? source) {
    final content =
        source is ContentModel ? source : ContentModel.parse(source);
    return PostModel(
      id: content.id,
      timeMills: content.timeMills,
      publisherId: content.publisherId,
      path: content.path,
      audience: content.audience,
      privacy: content.privacy,
      type: content.type,
      title: content.title,
      description: content.description,
      tags: content.tags,
      photos: content.photos,
      content: content.contentOrNull,
      contentRef: content.contentRef,
    );
  }

  PostModel copyWith({
    String? id,
    int? timeMills,
    String? publisherId,
    String? path,
    Audience? audience,
    Privacy? privacy,
    FeedType? type,
    String? title,
    String? description,
    ContentModel? content,
    String? contentRef,
    List<String>? tags,
    List<ContentModel>? photos,
    ContentUiState? uiState,
  }) {
    return PostModel(
      id: stringify(id, this.id),
      timeMills: stringify(timeMills, this.timeMills),
      publisherId: stringify(publisherId, this.publisherId),
      path: stringify(path, this.path),
      audience: stringify(audience, this.audience),
      privacy: stringify(privacy, this.privacy),
      type: stringify(type, this.type),
      title: stringify(title, this.title),
      description: stringify(description, this.description),
      tags: stringify(tags, this.tags),
      photos: stringify(photos, this.photos),
      content: stringify(content, contentOrNull),
      contentRef: stringify(contentRef, this.contentRef),
      uiState: stringify(uiState, this.uiState),
    );
  }
}
