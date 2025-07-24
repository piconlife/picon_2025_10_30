import 'package:data_management/core.dart';

class RootEncryptor extends DataEncryptor {
  static Map<String, dynamic> _request(String a, String b) {
    return {};
  }

  static dynamic _response(Map<String, dynamic> source) {
    return {};
  }

  RootEncryptor._() : super(request: _request, response: _response);

  static RootEncryptor? _i;

  static RootEncryptor get i => _i ??= RootEncryptor._();
}
