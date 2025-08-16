import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class LocationHelper {
  LocationHelper._();

  DateTime? lastFetchingTime;
  LocationInfo? _info;

  LocationInfo get info {
    if (_info != null && _info!.isNotEmpty) {
      if (lastFetchingTime != null &&
          DateTime.now().difference(lastFetchingTime!).inMinutes.abs() > 10) {
        get();
      }
      return _info!;
    }
    get();
    return LocationInfo._();
  }

  static LocationHelper? _i;

  static LocationHelper get i => _i ??= LocationHelper._();

  static Future<void> init() async {
    i._info = await get();
  }

  static Future<LocationInfo> get() async {
    try {
      final response = await http.post(
        Uri.parse("http://ip-api.com/json"),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );
      if (response.statusCode != 200 && response.body.isEmpty) {
        return LocationInfo._();
      }
      final data = jsonDecode(response.body);
      return update(LocationInfo.parse(data));
    } catch (e) {
      log(e.toString());
      return LocationInfo._();
    }
  }

  static LocationInfo update(LocationInfo info) {
    i.lastFetchingTime = DateTime.now();
    i._info = (i._info ?? LocationInfo._()).copyWith(
      status: info.status,
      country: info.country,
      countryCode: info.countryCode,
      region: info.region,
      regionName: info.regionName,
      city: info.city,
      zip: info.zip,
      lat: info.lat,
      lon: info.lon,
      timezone: info.timezone,
      isp: info.isp,
      org: info.org,
      as: info.as,
      query: info.query,
    );
    return i.info;
  }
}

class LocationInfo {
  final String? status;
  final String? country;
  final String? countryCode;
  final String? region;
  final String? regionName;
  final String? city;
  final int? zip;
  final double? lat;
  final double? lon;
  final String? timezone;
  final String? isp;
  final String? org;
  final String? as;
  final String? query;

  bool get isNotEmpty {
    if (status != null) return true;
    if (country != null && country!.isNotEmpty) return true;
    if (countryCode != null && countryCode!.isNotEmpty) return true;
    if (region != null && region!.isNotEmpty) return true;
    if (regionName != null && regionName!.isNotEmpty) return true;
    if (city != null && city!.isNotEmpty) return true;
    if (zip != null) return true;
    if (lat != null) return true;
    if (lon != null) return true;
    if (timezone != null && timezone!.isNotEmpty) return true;
    if (isp != null && isp!.isNotEmpty) return true;
    if (org != null && org!.isNotEmpty) return true;
    if (as != null && as!.isNotEmpty) return true;
    if (query != null && query!.isNotEmpty) return true;
    return false;
  }

  const LocationInfo._({
    this.status,
    this.country,
    this.countryCode,
    this.region,
    this.regionName,
    this.city,
    this.zip,
    this.lat,
    this.lon,
    this.timezone,
    this.isp,
    this.org,
    this.as,
    this.query,
  });

  static LocationInfo get i => LocationHelper.i.info;

  factory LocationInfo.parse(Object? source) {
    if (source is! Map) return LocationInfo._();
    final status = source['status'];
    final country = source['country'];
    final countryCode = source['countryCode'];
    final region = source['region'];
    final regionName = source['regionName'];
    final city = source['city'];
    final zip = source['zip'];
    final lat = source['lat'];
    final lon = source['lon'];
    final timezone = source['timezone'];
    final isp = source['isp'];
    final org = source['org'];
    final mAs = source['as'];
    final query = source['query'];
    return LocationInfo._(
      status: status is String ? status : null,
      country: country is String ? country : null,
      countryCode: countryCode is String ? countryCode : null,
      region: region is String ? region : null,
      regionName: regionName is String ? regionName : null,
      city: city is String ? city : null,
      zip: zip is num ? zip.toInt() : null,
      lat: lat is num ? lat.toDouble() : null,
      lon: lon is num ? lon.toDouble() : null,
      timezone: timezone is String ? timezone : null,
      isp: isp is String ? isp : null,
      org: org is String ? org : null,
      as: mAs is String ? mAs : null,
      query: query is String ? query : null,
    );
  }

  LocationInfo copyWith({
    String? status,
    String? country,
    String? countryCode,
    String? region,
    String? regionName,
    String? city,
    int? zip,
    double? lat,
    double? lon,
    String? timezone,
    String? isp,
    String? org,
    String? as,
    String? query,
  }) {
    return LocationInfo._(
      status: status ?? this.status,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      region: region ?? this.region,
      regionName: regionName ?? this.regionName,
      city: city ?? this.city,
      zip: zip ?? this.zip,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      timezone: timezone ?? this.timezone,
      isp: isp ?? this.isp,
      org: org ?? this.org,
      as: as ?? this.as,
      query: query ?? this.query,
    );
  }

  Map<String, dynamic> get json {
    return {
      'status': status,
      'country': country,
      'countryCode': countryCode,
      'region': region,
      'regionName': regionName,
      'city': city,
      'zip': zip,
      'lat': lat,
      'lon': lon,
      'timezone': timezone,
      'isp': isp,
      'org': org,
      'as': as,
      'query': query,
    };
  }
}
