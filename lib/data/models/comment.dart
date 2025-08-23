import '../constants/keys.dart';
import '../enums/privacy.dart';
import 'content.dart';

List<String> _keys = [
  // PUBLISHER
  Keys.i.publisher,
  Keys.i.publisherPhoto,
  Keys.i.publisherProfession,
  Keys.i.publisherName,
  Keys.i.publisherShortName,
  Keys.i.publisherTitle,
  Keys.i.publisherAge,
  Keys.i.publisherProfilePath,
  Keys.i.publisherProfileUrl,
  Keys.i.publisherReligion,
  Keys.i.publisherLatitude,
  Keys.i.publisherLongitude,
  Keys.i.publisherGender,

  // OTHER
  Keys.i.id,
  Keys.i.timeMills,
  Keys.i.parentId,
  Keys.i.parentPath,
  Keys.i.description,
  Keys.i.photoUrl,
  Keys.i.privacy,
];

class Comment extends Content {
  Comment({
    // PUBLISHER
    super.publisherId,
    super.publisherAge,
    super.publisherPhoto,
    super.publisherProfession,
    super.publisherProfilePath,
    super.publisherProfileUrl,
    super.publisherName,
    super.publisherShortName,
    super.publisherTitle,
    super.publisherReligion,
    super.publisherLatitude,
    super.publisherLongitude,
    super.publisherGender,

    // OTHER
    super.id,
    super.timeMills,
    super.parentId,
    super.parentPath,
    super.privacy,
    super.photoUrl,
    super.description,
  });

  Comment withComment({
    // PUBLISHER
    String? publisher,
    int? publisherAge,
    String? publisherPhoto,
    String? publisherProfession,
    String? publisherProfilePath,
    String? publisherProfileUrl,
    String? publisherName,
    String? publisherShortName,
    String? publisherTitle,
    String? publisherReligion,
    double? publisherLatitude,
    double? publisherLongitude,
    String? publisherGender,

    // OTHER
    String? id,
    int? timeMills,
    String? description,
    String? parentId,
    String? parentPath,
    String? photoUrl,
    Privacy? privacy,
  }) {
    return Comment(
      // PUBLISHER
      publisherId: publisher ?? this.publisherId,
      publisherAge: publisherAge ?? this.publisherAge,
      publisherPhoto: publisherPhoto ?? this.publisherPhoto,
      publisherProfession: publisherProfession ?? this.publisherProfession,
      publisherProfilePath: publisherProfilePath ?? this.publisherProfilePath,
      publisherProfileUrl: publisherProfileUrl ?? this.publisherProfileUrl,
      publisherName: publisherName ?? this.publisherName,
      publisherShortName: publisherShortName ?? this.publisherShortName,
      publisherTitle: publisherTitle ?? this.publisherTitle,
      publisherReligion: publisherReligion ?? this.publisherReligion,
      publisherLatitude: publisherLatitude ?? this.publisherLatitude,
      publisherLongitude: publisherLongitude ?? this.publisherLongitude,
      publisherGender: publisherGender ?? this.publisherGender.name,
      // OTHER
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      description: description ?? this.description,
      parentId: parentId ?? this.parentId,
      parentPath: parentPath ?? this.parentPath,
      photoUrl: photoUrl ?? this.photoUrl,
      privacy: privacy ?? this.privacy,
    );
  }

  factory Comment.from(dynamic source) {
    final data = Content.parse(source);
    return Comment(
      // PUBLISHER
      publisherId: data.publisherId,
      publisherAge: data.publisherAge,
      publisherPhoto: data.publisherPhoto,
      publisherProfession: data.publisherProfession,
      publisherProfilePath: data.publisherProfilePath,
      publisherProfileUrl: data.publisherProfileUrl,
      publisherName: data.publisherName,
      publisherShortName: data.publisherShortName,
      publisherTitle: data.publisherTitle,
      publisherReligion: data.publisherReligion,
      publisherLatitude: data.publisherLatitude,
      publisherLongitude: data.publisherLongitude,
      publisherGender: data.publisherGender.name,

      // OTHER
      id: data.id,
      timeMills: data.timeMills,
      description: data.description,
      parentId: data.parentId,
      parentPath: data.parentPath,
      photoUrl: data.photoUrl,
      privacy: data.privacy,
    );
  }

  @override
  Map<String, dynamic> get source {
    final data = super.source.entries.where((item) => _keys.contains(item.key));
    return Map.fromEntries(data);
  }
}
