import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class UniqueIdService {
  const UniqueIdService._();

  static UniqueIdService? _i;

  static UniqueIdService get _ii => _i ?? const UniqueIdService._();

  final _secureStorage = const FlutterSecureStorage();
  final _key = '__unique_id__';

  static String? idOrNull;

  static String get id => idOrNull ?? '';

  static Future<String> init() async {
    idOrNull = await _ii._secureStorage.read(key: _ii._key);
    if (idOrNull == null) {
      idOrNull = "UID-${Uuid().v4()}";
      _ii._secureStorage.write(key: _ii._key, value: idOrNull);
    }
    return id;
  }
}
