import 'package:http/http.dart' as http;

class ImageValidator {
  const ImageValidator._();

  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute &&
          (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https'));
    } catch (e) {
      return false;
    }
  }

  static bool hasImageExtension(String url) {
    final validExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return validExtensions.any((ext) => url.toLowerCase().endsWith(ext));
  }

  static Future<bool> isImageUrl(String url) async {
    if (!isValidUrl(url) || !hasImageExtension(url)) return false;

    try {
      final response = await http.head(Uri.parse(url));
      final contentType = response.headers['content-type'];
      return response.statusCode == 200 &&
          contentType != null &&
          contentType.startsWith('image/');
    } catch (e) {
      return false;
    }
  }
}
