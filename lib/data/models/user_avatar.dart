import '../constants/keys.dart';
import '../enums/privacy.dart';
import 'content.dart';

List<String> _keys = [
  Keys.i.publisher,
  Keys.i.id,
  Keys.i.path,
  Keys.i.timeMills,
  Keys.i.description,
  Keys.i.photoUrl,
  Keys.i.privacy,
];

class UserAvatar extends Content {
  UserAvatar({
    super.publisher,
    super.id,
    super.timeMills,
    super.description,
    super.path,
    super.photoUrl,
    super.privacy,
  });

  UserAvatar withAvatar({
    String? publisher,
    String? id,
    int? timeMills,
    String? description,
    String? path,
    String? photoUrl,
    Privacy? privacy,
  }) {
    return UserAvatar(
      publisher: publisher ?? this.publisher,
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      description: description ?? this.description,
      path: path ?? this.path,
      photoUrl: photoUrl ?? this.photoUrl,
      privacy: privacy ?? this.privacy,
    );
  }

  factory UserAvatar.from(Object? source) {
    final data = Content.from(source);
    return UserAvatar(
      publisher: data.publisher,
      id: data.id,
      timeMills: data.timeMills,
      description: data.description,
      path: data.path,
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
