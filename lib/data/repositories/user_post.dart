import 'package:data_management/data_management.dart';
import 'package:flutter_andomie/extensions/string.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_database/in_app_database.dart';
import 'package:picon/data/enums/content.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/user_post.dart';
import '../sources/local/user_post.dart';
import '../sources/remote/user_post.dart';
import '../use_cases/user_avatar/get_by_id.dart';
import '../use_cases/user_cover/get_by_id.dart';

class UserPostRepository extends RemoteDataRepository<UserPost> {
  UserPostRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static UserPostRepository? _i;

  static UserPostRepository get i => _i ??= UserPostRepository(
    source: RemoteUserPostDataSource(),
    backup: LocalUserPostDataSource(database: InAppDatabase.i),
  );

  @override
  Future<Response<UserPost>> modifier(
    Response<UserPost> value,
    DataModifiers modifier,
  ) async {
    switch (modifier) {
      case DataModifiers.get:
      case DataModifiers.getById:
      case DataModifiers.getByIds:
      case DataModifiers.getByQuery:
      case DataModifiers.listen:
      case DataModifiers.listenById:
      case DataModifiers.listenByIds:
      case DataModifiers.listenByQuery:
        return _modify(value);
      case DataModifiers.checkById:
      case DataModifiers.clear:
      case DataModifiers.create:
      case DataModifiers.creates:
      case DataModifiers.deleteById:
      case DataModifiers.deleteByIds:
      case DataModifiers.search:
      case DataModifiers.updateById:
      case DataModifiers.updateByIds:
        return value;
    }
  }

  Future<Response<UserPost>> _modify(Response<UserPost> value) async {
    if (!value.isValid) return value;
    if (value.result.length == 1) {
      if (value.data == null) return value;
      return value.copy(data: await _value(value.data!));
    }
    final result = await Future.wait(value.result.map(_value));
    return value.copy(result: result);
  }

  Future<UserPost> _value(UserPost i) async {
    if (i.reference != null && i.reference!.isNotEmpty) {
      return _filter(i);
    }
    return i;
  }

  Future<UserPost> _filter(UserPost i) async {
    switch (i.contentType) {
      case ContentType.avatar:
        final feedback = await GetUserAvatarUseCase.i(
          id: i.id,
          uid: i.publisher,
        );
        final data = feedback.data;
        if (data == null || data.isEmpty) return i;
        return i
          ..description = data.description
          ..photoUrls = data.photoUrl.isValid ? [data.photoUrl!] : []
          ..privacy = data.privacy;
      case ContentType.cover:
        final feedback = await GetUserCoverUseCase.i(
          id: i.id,
          uid: i.publisher,
        );
        final data = feedback.data;
        if (data == null) return i;
        return i
          ..description = data.description
          ..photoUrls = data.photoUrl.isValid ? [data.photoUrl!] : []
          ..privacy = data.privacy;
      case ContentType.none:
      case ContentType.ads:
      case ContentType.business:
      case ContentType.note:
      case ContentType.photo:
      case ContentType.sponsored:
      case ContentType.memory:
      case ContentType.post:
      case ContentType.video:
        return i;
    }
  }
}
