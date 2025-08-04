import '../constants/keys.dart';
import '../enums/privacy.dart';
import 'content.dart';

List<String> _keys = [
  Keys.i.publisher,
  Keys.i.id,
  Keys.i.timeMills,
  Keys.i.description,
  Keys.i.photoUrl,
  Keys.i.privacy,
];

class UserCover extends Content {
  UserCover({
    super.publisher,
    super.id,
    super.timeMills,
    super.description,
    super.photoUrl,
    super.privacy,
  });

  UserCover withCover({
    String? publisher,
    String? id,
    int? timeMills,
    String? description,
    String? photoUrl,
    Privacy? privacy,
  }) {
    return UserCover(
      publisher: publisher ?? this.publisher,
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      privacy: privacy ?? this.privacy,
    );
  }

  factory UserCover.from(Object? source) {
    final data = Content.from(source);
    return UserCover(
      publisher: data.publisher,
      id: data.id,
      timeMills: data.timeMills,
      description: data.description,
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
