import 'package:data_management/data_management.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_database/in_app_database.dart';

import '../../roots/helpers/connectivity.dart';
import '../enums/content.dart';
import '../models/feed.dart';
import '../sources/local/feed.dart';
import '../sources/remote/feed.dart';
import '../use_cases/business_ad/get_by_id.dart';
import '../use_cases/business_sponsor/get_by_id.dart';
import '../use_cases/user_avatar/get_by_id.dart';
import '../use_cases/user_business/get_by_id.dart';
import '../use_cases/user_cover/get_by_id.dart';
import '../use_cases/user_memory/get_by_id.dart';
import '../use_cases/user_note/get_by_id.dart';
import '../use_cases/user_post/get_by_id.dart';
import '../use_cases/user_video/get_by_id.dart';

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
      final x = await _convert(value.data);
      if (x == null) return Response(status: Status.invalid);
      return Response(data: x);
    }
    final futures = value.result.map(_convert).toList();
    final x = await Future.wait(futures).then((value) {
      return value.whereType<Feed>().toList();
    });
    if (x.isEmpty) return Response(status: Status.notFound);
    return Response(result: x);
  }

  Future<Feed?> _convert(Feed? e) async {
    if (e == null) return null;
    final uid = e.publisher ?? '';
    final id = e.referenceId ?? '';
    final type = e.contentType;
    if (uid.isEmpty || id.isEmpty) return null;
    return _reference(type, uid, id).then((value) {
      if (!value.isValid) return null;
      return Feed.from(e.source..addAll(value.data?.source ?? {}));
    });
  }

  Future<Response<Entity>> _reference(ContentType type, String uid, String id) {
    switch (type) {
      case ContentType.ads:
        return GetBusinessAdUseCase.i(id: id, uid: uid);
      case ContentType.avatar:
        return GetUserAvatarUseCase.i(id: id, uid: uid);
      case ContentType.business:
        return GetUserBusinessUseCase.i(id: id, uid: uid);
      case ContentType.cover:
        return GetUserCoverUseCase.i(id: id, uid: uid);
      case ContentType.note:
        return GetUserNoteUseCase.i(id: id, uid: uid);
      case ContentType.sponsored:
        return GetBusinessSponsorUseCase.i(id: id, uid: uid);
      case ContentType.memory:
        return GetUserMemoryUseCase.i(id: id, uid: uid);
      case ContentType.photo:
      case ContentType.post:
        return GetUserPostUseCase.i(id: id, uid: uid);
      case ContentType.video:
        return GetUserVideoUseCase.i(id: id, uid: uid);
      case ContentType.none:
        return Future.value(Response(status: Status.invalid));
    }
  }
}
