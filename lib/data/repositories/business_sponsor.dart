import 'package:data_management/core.dart';
import 'package:flutter_andomie/extensions.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_database/in_app_database.dart';

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
    super.connectivity = ConnectivityHelper.connection,
  });

  static BusinessSponsorRepository? _i;

  static BusinessSponsorRepository get i => _i ??= BusinessSponsorRepository(
    source: RemoteBusinessSponsorDataSource(),
    backup: LocalBusinessSponsorDataSource(database: InAppDatabase.i),
  );

  @override
  Future<Response<BusinessSponsor>> get({
    DataFieldParams? params,
    Object? args,
    bool? lazy,
    bool? cached,
  }) {
    return super.get(cached: cached, params: params).then(_modify);
  }

  @override
  Future<Response<BusinessSponsor>> getById(
    String id, {
    DataFieldParams? params,
    Object? args,
    bool? lazy,
    bool? cached,
  }) {
    return super
        .getById(id, cached: cached, params: params)
        .then((v) => _modify(v, true));
  }

  @override
  Future<Response<BusinessSponsor>> getByIds(
    List<String> ids, {
    DataFieldParams? params,
    Object? args,
    bool? lazy,
    bool? cached,
  }) {
    return super.getByIds(ids, cached: cached, params: params).then(_modify);
  }

  @override
  Future<Response<BusinessSponsor>> getByQuery({
    DataFieldParams? params,
    List<DataQuery> queries = const [],
    List<DataSelection> selections = const [],
    List<DataSorting> sorts = const [],
    DataPagingOptions options = const DataPagingOptions(),
    Object? args,
    bool? lazy,
    bool? cached,
  }) {
    return super
        .getByQuery(
          cached: cached,
          params: params,
          queries: queries,
          selections: selections,
          sorts: sorts,
          options: options,
        )
        .then(_modify);
  }

  Future<Response<BusinessSponsor>> _modify(
    Response<BusinessSponsor> value, [
    bool singleMode = false,
  ]) async {
    if (value.isSuccessful) {
      if (singleMode) {
        return value.copy(data: await _value(value.data));
      } else {
        List<BusinessSponsor> list = [];
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
