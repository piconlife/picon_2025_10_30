import 'package:flutter_entity/entity.dart';

import '../../app/helpers/user.dart';
import '../constants/keys.dart';
import 'content.dart';

class BookmarkModel extends ContentModel {
  @override
  Iterable<String> get keys => [
    Keys.i.id,
    Keys.i.timeMills,
    Keys.i.publisherId,
    Keys.i.path,
    Keys.i.contentType,
  ];

  BookmarkModel({
    super.id,
    super.timeMills,
    super.publisherId,
    super.path,
    super.contentType,
  });

  BookmarkModel.create({
    String? id,
    int? timeMills,
    String? publisherId,
    required super.path,
    required super.contentType,
  }) : super(
         id: id ?? Entity.generateID,
         timeMills: timeMills ?? Entity.generateTimeMills,
         publisherId: publisherId ?? UserHelper.uid,
       );

  factory BookmarkModel.parse(Object? source) {
    final content = ContentModel.parse(source);
    return BookmarkModel(
      id: content.id,
      timeMills: content.timeMills,
      publisherId: content.publisherId,
      path: content.path,
      contentType: content.contentType,
    );
  }

  BookmarkModel copyWith({
    String? id,
    int? timeMills,
    String? publisherId,
    String? path,
    String? contentType,
  }) {
    return BookmarkModel(
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      publisherId: publisherId ?? this.publisherId,
      path: path ?? this.path,
      contentType: contentType ?? this.contentType,
    );
  }

  @override
  String toString() => "$BookmarkModel#$hashCode($idOrNull)";
}
