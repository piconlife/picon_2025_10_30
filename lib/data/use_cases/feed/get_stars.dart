import 'package:data_management/data_management.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_configs/configs.dart';

import '../../../app/helpers/user.dart';
import '../../../app/utils/geo_pointer.dart';
import '../../constants/keys.dart';
import '../../models/feed.dart';
import 'base.dart';

const kStaredNearbyFeedRadius = "stared_nearby_feed_radius";

class StaredFeedPaginationUseCase extends FeedBaseUseCase {
  StaredFeedPaginationUseCase._();

  static StaredFeedPaginationUseCase? _i;

  static StaredFeedPaginationUseCase get i =>
      _i ??= StaredFeedPaginationUseCase._();

  Future<Response<FeedModel>> _filter({
    double? lat,
    double? lon,
    double? radiusKm,
    required Future<Response<FeedModel>> Function(double minLat, double maxLat)
    callback,
  }) async {
    lat ??= UserHelper.user.latitude ?? 0;
    lon ??= UserHelper.user.longitude ?? 0;
    radiusKm ??= Configs.get(kStaredNearbyFeedRadius, defaultValue: 0) ?? 0;
    if (radiusKm <= 0) return callback(0, 0);
    Response<FeedModel> response = Response();
    final filtered = await GeoPointer(lat, lon).future(
      radiusKm: radiusKm,
      pointer: (e) => GeoPoint(e.latitude ?? 0, e.longitude ?? 0),
      callback: (minLat, maxLat) async {
        response = await callback(minLat, maxLat);
        return response.result;
      },
    );
    return response.copyWith(result: filtered);
  }

  Future<Response<FeedModel>> call({
    bool nearbyMode = false,
    int? initialSize,
    int fetchingSize = 10,
    Object? snapshot,
  }) {
    return _filter(
      radiusKm: nearbyMode ? null : 0,
      callback: (minLat, maxLat) {
        return repository.getByQuery(
          resolveRefs: true,
          queries: [
            // final publisherAge = "pAge";
            // final publisherGender = "pGender";
            // final publisherProfession = "pProfession";
            // final publisherReligion = "pReligion";
            // final publisherRating = "pRating";
            //     final publisherTitle = "pTitle";
            DataQuery(Keys.i.publisherRating, isGreaterThanOrEqualTo: 2),
            if (minLat > 0 && maxLat > 0) ...[
              DataQuery(Keys.i.latitude, isGreaterThanOrEqualTo: minLat),
              DataQuery(Keys.i.latitude, isLessThanOrEqualTo: maxLat),
            ],
          ],
          selections: [
            if (snapshot is List)
              DataSelection.startAfterDocument(snapshot.firstOrNull),
          ],
          sorts: [
            DataSorting(Keys.i.timeMills, descending: true),
            DataSorting(Keys.i.publisherRating, descending: true),
          ],
          options: DataPagingOptions(
            initialFetchSize: initialSize,
            fetchingSize: fetchingSize,
          ),
        );
      },
    );
  }
}
