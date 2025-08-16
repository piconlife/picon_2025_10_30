import 'package:data_management/data_management.dart';
import 'package:flutter_andomie/extensions/string.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_database/in_app_database.dart';

import '../../roots/helpers/connectivity.dart';
import '../enums/content.dart';
import '../models/feed.dart';
import '../sources/local/feed.dart';
import '../sources/remote/feed.dart';
import '../use_cases/user_avatar/get_by_id.dart';
import '../use_cases/user_cover/get_by_id.dart';

class FeedRepository extends RemoteDataRepository<Feed> {
  FeedRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static FeedRepository? _i;

  static FeedRepository get i => _i ??= FeedRepository(
    source: RemoteFeedDataSource(),
    backup: LocalFeedDataSource(database: InAppDatabase.i),
  );

  @override
  Future<Response<Feed>> modifier(
    Response<Feed> value,
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

  Future<Response<Feed>> _modify(Response<Feed> value) async {
    if (!value.isValid) return value;
    if (value.result.length == 1) {
      if (value.data == null) return value;
      return value.copy(data: await _value(value.data!));
    }
    final result = await Future.wait(value.result.map(_value));
    return value.copy(result: result);
  }

  Future<Feed> _value(Feed i) async {
    if (i.reference != null && i.reference!.isNotEmpty) {
      return _filter(i);
    }
    return i;
  }

  Future<Feed> _filter(Feed i) async {
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
