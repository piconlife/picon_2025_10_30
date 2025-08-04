import 'package:flutter_entity/entity.dart';

List<String> _keys = [
  BusinessKeys.i.id,
  BusinessKeys.i.timeMills,
  BusinessKeys.i.category,
  BusinessKeys.i.coverPhoto,
  BusinessKeys.i.description,
  BusinessKeys.i.email,
  BusinessKeys.i.latitude,
  BusinessKeys.i.longitude,
  BusinessKeys.i.name,
  BusinessKeys.i.phone,
  BusinessKeys.i.profilePath,
  BusinessKeys.i.profilePhoto,
  BusinessKeys.i.profileUrl,
  BusinessKeys.i.rating,
  BusinessKeys.i.website,
];

class BusinessKeys extends EntityKey {
  const BusinessKeys._();

  static BusinessKeys? _i;

  static BusinessKeys get i => _i ??= const BusinessKeys._();

  final category = "category";
  final coverPhoto = "cover_photo";
  final description = "description";
  final email = "email";
  final latitude = "latitude";
  final longitude = "longitude";
  final name = "name";
  final phone = "phone";
  final profilePath = "profile_path";
  final profilePhoto = "profile_photo";
  final profileUrl = "profile_url";
  final rating = "rating";
  final website = "website";
}

class Business extends Entity<BusinessKeys> {
  String? category;
  String? coverPhoto;
  String? description;
  String? email;
  double? latitude;
  double? longitude;
  String? name;
  String? phone;
  String? profilePath;
  String? profilePhoto;
  String? profileUrl;
  double? rating;
  String? website;

  Business({
    super.id = "",
    super.timeMills,
    this.category,
    this.coverPhoto,
    this.description,
    this.email,
    this.latitude,
    this.longitude,
    this.name,
    this.phone,
    this.profilePath,
    this.profilePhoto,
    this.profileUrl,
    this.rating,
    this.website,
  });

  Business copy({
    String? id,
    int? timeMills,
    String? category,
    String? coverPhoto,
    String? description,
    String? email,
    double? latitude,
    double? longitude,
    String? name,
    String? phone,
    String? profilePath,
    String? profilePhoto,
    String? profileUrl,
    double? rating,
    String? website,
  }) {
    return Business(
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      category: category ?? this.category,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      description: description ?? this.description,
      email: email ?? this.email,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profilePath: profilePath ?? this.profilePath,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      profileUrl: profileUrl ?? this.profileUrl,
      rating: rating ?? this.rating,
      website: website ?? this.website,
    );
  }

  factory Business.from(Object? source) {
    final key = BusinessKeys.i;
    return Business(
      id: source.entityValue(key.id),
      timeMills: source.entityValue(key.timeMills),
      category: source.entityValue(key.category),
      coverPhoto: source.entityValue(key.coverPhoto),
      description: source.entityValue(key.description),
      email: source.entityValue(key.email),
      latitude: source.entityValue(key.latitude),
      longitude: source.entityValue(key.longitude),
      name: source.entityValue(key.name),
      phone: source.entityValue(key.phone),
      profilePath: source.entityValue(key.profilePath),
      profilePhoto: source.entityValue(key.profilePhoto),
      profileUrl: source.entityValue(key.profileUrl),
      rating: source.entityValue(key.rating),
      website: source.entityValue(key.website),
    );
  }

  @override
  BusinessKeys makeKey() => BusinessKeys.i;

  @override
  bool isInsertable(String key, value) {
    return _keys.contains(key) && value != null;
  }
}
