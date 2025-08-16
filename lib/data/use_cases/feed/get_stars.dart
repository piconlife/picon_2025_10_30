import 'package:data_management/data_management.dart';
import 'package:flutter_andomie/utils/configs.dart';
import 'package:flutter_entity/entity.dart';

import '../../../app/helpers/user.dart';
import '../../../app/utils/geo_pointer.dart';
import '../../models/feed.dart';
import 'base.dart';

const kStaredNearbyFeedRadius = "stared_nearby_feed_radius";

class GetStarFeedsByPaginationUseCase extends BaseFeedUseCase {
  GetStarFeedsByPaginationUseCase._();

  static GetStarFeedsByPaginationUseCase? _i;

  static GetStarFeedsByPaginationUseCase get i =>
      _i ??= GetStarFeedsByPaginationUseCase._();

  Future<Response<Feed>> _filter({
    double? lat,
    double? lon,
    double? radiusKm,
    required Future<Response<Feed>> Function(double minLat, double maxLat)
    callback,
  }) async {
    lat ??= UserHelper.user.latitude ?? 0;
    lon ??= UserHelper.user.longitude ?? 0;
    radiusKm ??= Configs.get(kStaredNearbyFeedRadius, defaultValue: 0) ?? 0;
    if (radiusKm <= 0) return callback(0, 0);
    Response<Feed> response = Response();
    final filtered = await GeoPointer(lat, lon).future(
      radiusKm: radiusKm,
      pointer: (e) => GeoPoint(e.lat ?? 0, e.lon ?? 0),
      callback: (minLat, maxLat) async {
        response = await callback(minLat, maxLat);
        return response.result;
      },
    );
    return response.copy(result: filtered);
  }

  Future<Response<Feed>> call({
    bool nearbyMode = false,
    int? initialSize,
    int fetchingSize = 10,
    Object? snapshot,
  }) {
    return _filter(
      radiusKm: nearbyMode ? null : 0,
      callback: (minLat, maxLat) {
        return repository.getByQuery(
          queries: [
            // final publisherAge = "pAge";
            // final publisherGender = "pGender";
            // final publisherProfession = "pProfession";
            // final publisherReligion = "pReligion";
            // final publisherRating = "pRating";
            //     final publisherTitle = "pTitle";
            DataQuery(FeedKeys.i.publisherRating, isGreaterThanOrEqualTo: 2),
            if (minLat > 0 && maxLat > 0) ...[
              DataQuery(FeedKeys.i.lat, isGreaterThanOrEqualTo: minLat),
              DataQuery(FeedKeys.i.lat, isLessThanOrEqualTo: maxLat),
            ],
          ],
          selections: [
            if (snapshot is List)
              DataSelection.startAfterDocument(snapshot.firstOrNull),
          ],
          sorts: [
            DataSorting(FeedKeys.i.timeMills, descending: true),
            DataSorting(FeedKeys.i.publisherRating, descending: true),
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
