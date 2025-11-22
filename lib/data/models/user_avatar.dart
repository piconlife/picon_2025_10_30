import 'package:flutter_andomie/utils/path_replacer.dart';

import '../../app/helpers/user.dart';
import '../../roots/services/path_provider.dart';
import '../constants/paths.dart';
import '../enums/content_state.dart';
import '../enums/privacy.dart';
import 'content.dart';

class AvatarModel extends ContentModel {
  @override
  Iterable<String> get keys => [
    key.id,
    key.timeMills,
    key.publisherId,
    key.path,
    key.description,
    key.photoUrl,
    key.privacy,
  ];

  AvatarModel({
    super.id,
    super.timeMills,
    super.path,
    super.privacy,
    super.publisherId,
    super.photoUrl,
    super.description,
    super.uiState,
  });

  AvatarModel.create({
    required String super.id,
    required super.timeMills,
    required super.privacy,
    required super.description,
    required super.photoUrl,
  }) : super(
         uiState: ContentUiState.processing,
         publisherId: UserHelper.uid,
         path: PathReplacer.replaceByIterable(
           PathProvider.generatePath(Paths.userAvatars, id),
           [UserHelper.uid],
         ),
       );

  factory AvatarModel.parse(Object? source) {
    final content =
        source is ContentModel ? source : ContentModel.parse(source);
    return AvatarModel(
      id: content.id,
      timeMills: content.timeMills,
      path: content.path,
      privacy: content.privacy,
      publisherId: content.publisherId,
      description: content.description,
      photoUrl: content.photoUrl,
    );
  }

  AvatarModel copyWith({
    String? id,
    int? timeMills,
    String? publisherId,
    String? path,
    Privacy? privacy,
    String? description,
    String? photoUrl,
    ContentUiState? uiState,
  }) {
    return AvatarModel(
      id: stringify(id, this.id),
      timeMills: stringify(timeMills, this.timeMills),
      publisherId: stringify(publisherId, this.publisherId),
      path: stringify(path, this.path),
      privacy: stringify(privacy, this.privacy),
      description: stringify(description, this.description),
      photoUrl: stringify(photoUrl, this.photoUrl),
      uiState: stringify(uiState, this.uiState),
    );
  }
}
