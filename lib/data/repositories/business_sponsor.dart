import 'package:data_management/data_management.dart';
import 'package:flutter_andomie/extensions.dart';
import 'package:flutter_entity/entity.dart';

import '../../roots/helpers/connectivity.dart';
import '../models/business_sponsor.dart';
import '../sources/local/business_sponsor.dart';
import '../sources/remote/business_sponsor.dart';
import '../use_cases/feed_video/get.dart';
import '../use_cases/photo/get.dart';

class BusinessSponsorRepository extends RemoteDataRepository<BusinessSponsor> {
  BusinessSponsorRepository({
    required super.source,
    super.backup,
    super.connectivity = ConnectivityHelper.connected,
  });

  static BusinessSponsorRepository? _i;

  static BusinessSponsorRepository get i =>
      _i ??= BusinessSponsorRepository(
        source: RemoteBusinessSponsorDataSource(),
        backup: LocalBusinessSponsorDataSource(),
      );

  @override
  Future<Response<BusinessSponsor>> modifier(
    Response<BusinessSponsor> value,
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
      case DataModifiers.count:
        // TODO: Handle this case.
        throw UnimplementedError();
      case DataModifiers.listenCount:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  Future<Response<BusinessSponsor>> _modify(
    Response<BusinessSponsor> value,
  ) async {
    if (value.isValid) {
      if (value.result.length == 1) {
        return value.copyWith(data: await _value(value.data));
      } else {
        List<BusinessSponsor> list = [];
        for (var i in value.result) {
          final data = await _value(i);
          if (data != null) list.add(data);
        }
        return value.copyWith(result: list);
      }
    } else {
      return value;
    }
  }

  Future<BusinessSponsor?> _value(BusinessSponsor? i) async {
    if (i != null) {
      final photos = await GetPhotosUseCase.i(i.path.use).then((value) {
        return value.result;
      });
      final videos = await GetVideosUseCase.i(i.path.use).then((value) {
        return value.result;
      });
      return i.withBusinessSponsor(photos: photos, videos: videos);
    }
    return i;
  }
}
