import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../utils/file_details.dart';

class DownloadHelper {
  const DownloadHelper._();

  static Future<File?> downloadFile(String url, [String? directoryPath]) async {
    if (url.isEmpty) return null;

    final directory = directoryPath ?? (await getTemporaryDirectory()).path;

    try {
      final response = await http.get(Uri.parse(url));
      url = url.split("?alt=").firstOrNull ?? url;
      String fileName = path.basename(url);
      final file = File('$directory/$fileName');
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } catch (_) {
      return null;
    }
  }

  static Future<List<File?>> downloadFiles(List<String> urls) async {
    if (urls.isEmpty) return [];
    List<File?> converted = [];
    final directory = await getTemporaryDirectory();
    for (String url in urls) {
      final data = await downloadFile(url, directory.path);
      converted.add(data);
    }
    return converted;
  }

  static Future<List<File>> downloadFilesOnly(List<String> urls) async {
    return downloadFiles(urls).then((value) {
      return value.whereType<File>().toList();
    });
  }

  static Future<FileDetails?> downloadInfo(String url) async {
    try {
      final response = await http.head(Uri.parse(url));

      if (response.statusCode == 200) {
        final mimeType = response.headers['content-type'];
        String? extension;

        if (mimeType != null) {
          extension =
              {
                'image/jpeg': '.jpg',
                'image/png': '.png',
                'image/gif': '.gif',
                'image/webp': '.webp',
                'image/svg+xml': '.svg',
                'image/bmp': '.bmp',
                'image/tiff': '.tiff',
              }[mimeType] ??
              path.extension(url);
        } else {
          extension = path.extension(url);
        }

        final imageResponse = await http.get(Uri.parse(url));
        final imageBytes = imageResponse.bodyBytes;

        return FileDetails(
          extension: extension,
          mimeType: mimeType,
          bytes: imageBytes,
        );
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  static Future<List<FileDetails?>> downloadInfos(List<String> urls) async {
    if (urls.isEmpty) return [];
    List<FileDetails?> converted = [];
    for (String url in urls) {
      final data = await downloadInfo(url);
      converted.add(data);
    }
    return converted;
  }

  static Future<List<FileDetails>> downloadInfosOnly(List<String> urls) async {
    return downloadInfos(urls).then((value) {
      return value.whereType<FileDetails>().toList();
    });
  }
}
