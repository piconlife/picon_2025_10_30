import 'package:data_management/data_management.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_database/in_app_database.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/business_ad.dart';
import '../sources/local/business_ad.dart';
import '../sources/remote/business_ad.dart';
import '../use_cases/feed_video/get.dart';
import '../use_cases/photo/get.dart';

class BusinessAdRepository extends RemoteDataRepository<BusinessAd> {
  BusinessAdRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connection,
  });

  static BusinessAdRepository? _i;

  static BusinessAdRepository get i => _i ??= BusinessAdRepository(
    source: RemoteBusinessAdDataSource(),
    backup: LocalBusinessAdDataSource(database: InAppDatabase.i),
  );

  @override
  Future<Response<BusinessAd>> modifier(
    Response<BusinessAd> value,
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

  Future<Response<BusinessAd>> _modify(Response<BusinessAd> value) async {
    if (value.isValid) {
      if (value.result.length == 1) {
        return value.copy(data: await _value(value.data));
      } else {
        List<BusinessAd> list = [];
        for (var i in value.result) {
          final data = await _value(i);
          if (data != null) list.add(data);
        }
        return value.copy(result: list);
      }
    } else {
      return value;
    }
  }

  Future<BusinessAd?> _value(BusinessAd? i) async {
    if (i != null) {
      final photos = await GetPhotosUseCase.i(i.path.use).then((value) {
        return value.result;
      });
      final videos = await GetVideosUseCase.i(i.path.use).then((value) {
        return value.result;
      });
      return i.withBusinessAd(photos: photos, videos: videos);
    }
    return i;
  }
}
