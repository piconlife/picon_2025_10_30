import 'dart:convert';

import 'package:http/http.dart' as http;

class DeviceLocation {
  DeviceLocation._();

  LocationInfo? info;

  static DeviceLocation? _i;

  static DeviceLocation get i => _i ??= DeviceLocation._();

  static Future<void> init() async {
    i.info = await location();
  }

  static Future<LocationInfo> location() async {
    try {
      final response = await http.post(
        Uri.parse("http://ip-api.com/json"),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );
      if (response.statusCode != 200 && response.body.isEmpty) {
        return LocationInfo();
      }
      final data = jsonDecode(response.body);
      return LocationInfo.from(data);
    } catch (_) {
      return LocationInfo();
    }
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

  const LocationInfo({
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

  factory LocationInfo.from(Object? source) {
    if (source is! Map) return LocationInfo();
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
    return LocationInfo(
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
