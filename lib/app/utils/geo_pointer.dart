import 'dart:math';

class BoundingBox {
  final double minLat;
  final double maxLat;
  final double minLon;
  final double maxLon;

  const BoundingBox({
    required this.minLat,
    required this.maxLat,
    required this.minLon,
    required this.maxLon,
  });
}

class GeoPoint {
  final double lat;
  final double lon;

  bool get zero => (lat + lon) == 0;

  const GeoPoint(this.lat, this.lon);
}

class GeoPointer {
  final double lat;
  final double lon;

  const GeoPointer(this.lat, this.lon);

  BoundingBox getBoundingBox(double radiusKm) {
    double latDegree = radiusKm / 111.32;
    double lonDegree = radiusKm / (111.32 * cos(lat * pi / 180));
    return BoundingBox(
      minLat: lat - latDegree,
      maxLat: lat + latDegree,
      minLon: lon - lonDegree,
      maxLon: lon + lonDegree,
    );
  }

  double haversine(double lat, double lon) {
    const R = 6371;
    double dLat = (lat - this.lat) * pi / 180;
    double dLon = (lon - this.lon) * pi / 180;
    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(this.lat * pi / 180) *
            cos(lat * pi / 180) *
            sin(dLon / 2) *
            sin(dLon / 2);
    return R * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  List<T> filter<T extends Object?>({
    required double minLon,
    required double maxLon,
    required double radiusKm,
    required Iterable<T> source,
    required GeoPoint Function(T) pointer,
  }) {
    List<T> results = source
        .where((e) {
          final point = pointer(e);
          if (point.zero) return false;
          return point.lon >= minLon && point.lon <= maxLon;
        })
        .where((e) {
          final point = pointer(e);
          if (point.zero) return false;
          double d = haversine(point.lat, point.lon);
          return d <= radiusKm;
        })
        .toList();
    return results;
  }

  Future<List<T>> future<T extends Object?>({
    required double radiusKm,
    required GeoPoint Function(T) pointer,
    required Future<List<T>> Function(double minLat, double maxLat) callback,
  }) {
    final bounds = getBoundingBox(radiusKm);
    return callback(bounds.minLat, bounds.maxLat).then((source) {
      return filter(
        minLon: bounds.minLon,
        maxLon: bounds.maxLon,
        radiusKm: radiusKm,
        source: source,
        pointer: pointer,
      );
    });
  }

  Stream<List<T>> stream<T extends Object?>({
    required double radiusKm,
    required GeoPoint Function(T) pointer,
    required Stream<List<T>> Function(double minLat, double maxLat) callback,
  }) {
    final bounds = getBoundingBox(radiusKm);
    return callback(bounds.minLat, bounds.maxLat).map((source) {
      return filter(
        minLon: bounds.minLon,
        maxLon: bounds.maxLon,
        radiusKm: radiusKm,
        source: source,
        pointer: pointer,
      );
    });
  }
}
