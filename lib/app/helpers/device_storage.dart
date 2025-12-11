import 'dart:typed_data';

import 'package:device_storage/device_storage.dart';
import 'package:path/path.dart' as path;

import '../../roots/helpers/download_helper.dart';

enum DeviceStorageContentType {
  pictures('Pictures', 'jpg'),
  videos('Videos', 'mp4');

  final String label;
  final String extension;

  const DeviceStorageContentType(this.label, this.extension);
}

class DeviceStorageHelper {
  static DeviceStorage get storage => DeviceStorage();

  static Future<bool> requestPermission() async {
    try {
      bool status = await storage.hasRootAccess();
      if (!status) {
        await storage.requestPermissions(toRootAccess: true);
        status = await storage.hasRootAccess();
      }
      return status;
    } catch (_) {
      return false;
    }
  }

  static String? fileName(String url) {
    try {
      url = url.split("?alt=").firstOrNull ?? url;
      String fileName = path.basename(url);
      if (fileName.isEmpty) return null;
      return fileName;
    } catch (_) {
      return null;
    }
  }

  static String simpleFilename([String? extension]) {
    final date = DateTime.now();
    final name =
        "${date.year.toString().padLeft(4, '0')}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}${date.hour.toString().padLeft(2, '0')}${date.minute.toString().padLeft(2, '0')}${date.second.toString().padLeft(2, '0')}${date.millisecond.toString().padLeft(3, '0')}";
    if ((extension ?? '').isNotEmpty) {
      return "$name.$extension";
    }
    return name;
  }

  static Future<String?> saveToDevice(
    Uint8List bytes,
    String fileName,
    DeviceStorageContentType type,
  ) async {
    try {
      final status = await requestPermission();
      if (!status) return null;
      final s = await storage.saveToRoot(
        bytes: bytes,
        fileName: fileName,
        folderPath: "PicON/${type.label}",
      );
      return s;
    } catch (_) {
      return null;
    }
  }

  static Future<String?> saveToDeviceByUrl(
    String url,
    DeviceStorageContentType type, {
    String? fileName,
  }) async {
    try {
      final status = await requestPermission();
      if (!status) return null;
      final bytes = await DownloadHelper.download(url);
      if (bytes == null) return null;
      // fileName ??= DeviceStorageHelper.fileName(url);
      fileName ??= simpleFilename(type.extension);
      final s = await storage.saveToRoot(
        bytes: bytes,
        fileName: fileName,
        folderPath: "PicON/${type.label}",
      );
      return s;
    } catch (_) {
      return null;
    }
  }
}
