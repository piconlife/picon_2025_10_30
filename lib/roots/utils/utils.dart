import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:picon/roots/utils/platform.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/constants/app.dart';
import '../helpers/download_helper.dart';

class Utils {
  const Utils._();

  static Future sendEmail(
    BuildContext context, {
    void Function(String error)? onError,
  }) async {
    final size = MediaQuery.sizeOf(context);
    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;
    String query;
    if (isAndroid) {
      final info = await deviceInfo.androidInfo;
      query =
          'subject=Problem/Recommendation&body=Please do not remove this information. This will help us to find the solution faster(App: ${AppConstants.bundleId}:$version,Model: ${info.model},DP: ${size.width.toInt()}x${size.height.toInt()},Android: ${info.version.release}_${info.version.sdkInt})\n\nDescribe Problem:';
    } else {
      final info = await deviceInfo.iosInfo;
      query =
          'subject=Problem/Recommendation&body=Please do not remove this information. This will help us to find the solution faster(App: ${AppConstants.appId}:$version,Model: ${info.model},DP: ${size.width.toInt()}x${size.height.toInt()},${info.utsname.machine}: ${info.systemVersion})\n\nDescribe Problem:';
    }
    Uri url = Uri(scheme: 'mailto', path: AppConstants.email, query: query);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      onError?.call("Couldn't open email");
    }
  }

  static void launchLink({
    required String link,
    LaunchMode? mode,
    void Function(String error)? onError,
  }) async {
    Uri url = Uri.parse(link);
    if (await canLaunchUrl(url)) {
      try {
        await launchUrl(url, mode: mode ?? LaunchMode.externalApplication);
      } catch (error) {
        onError?.call(error.toString());
      }
    } else {
      onError?.call("Couldn't open link");
    }
  }

  static void share(
    BuildContext context, {
    String? subject,
    String? title,
    String? body,
    Color? loaderBarrierColor,
    List<String>? urls,
  }) async {
    if (urls != null && urls.length == 1 && subject == null && body == null) {
      SharePlus.instance.share(ShareParams(uri: Uri.parse(urls.first)));
      return;
    }
    if (urls != null && urls.isNotEmpty) {
      context.showLoader(barrierColor: loaderBarrierColor);
      DownloadHelper.downloadFilesOnly(urls).then((value) {
        if (context.mounted) context.hideLoader();
        if (value.isEmpty) return;
        final xFiles = value.map((e) => XFile(e.path)).toList();
        SharePlus.instance.share(
          ShareParams(
            files: xFiles,
            subject: subject,
            title: title,
            text: body,
          ),
        );
      });
      return;
    }
    if (body != null && body.isNotEmpty) {
      SharePlus.instance.share(ShareParams(text: body, subject: subject));
      return;
    }
  }
}
