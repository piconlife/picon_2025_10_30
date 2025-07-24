import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/constants/app.dart';
import '../helpers/download_helper.dart';
import '../preferences/preferences.dart';

const kReviewed = "has_reviewed";
const kReviewShowedTimes = "review_showed_times";

bool kIsAndroid = !kIsWeb && Platform.isAndroid;
bool kIsIos = !kIsWeb && Platform.isIOS;

class Utils {
  const Utils._();

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static Future<void> toggleOrientation(BuildContext context) {
    if (isLandscape(context)) {
      return setOrientation(Orientation.portrait);
    } else {
      return setOrientation(Orientation.landscape);
    }
  }

  static Future<void> setOrientation(Orientation orientation) async {
    try {
      await SystemChrome.setEnabledSystemUIMode(
        orientation == Orientation.landscape
            ? SystemUiMode.immersiveSticky
            : SystemUiMode.edgeToEdge,
      );
      await SystemChrome.setPreferredOrientations(
        orientation == Orientation.landscape
            ? [
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ]
            : [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
      );
    } catch (_) {}
  }

  static Future<void> resetOrientation() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  static void hideStatusBar() {
    try {
      hideSystemOverlays(SystemUiOverlay.values..remove(SystemUiOverlay.top));
    } catch (_) {}
  }

  static void showStatusBar() {
    try {
      hideSystemOverlays(SystemUiOverlay.values..add(SystemUiOverlay.top));
    } catch (_) {}
  }

  static void hideNavigationBar() {
    try {
      hideSystemOverlays(
        SystemUiOverlay.values..remove(SystemUiOverlay.bottom),
      );
    } catch (_) {}
  }

  static void showNavigationBar() {
    try {
      hideSystemOverlays(SystemUiOverlay.values..add(SystemUiOverlay.bottom));
    } catch (_) {}
  }

  static void hideSystemOverlays([List<SystemUiOverlay> overlays = const []]) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: overlays,
    );
  }

  static Future sendEmail(
    BuildContext context, {
    void Function(String error)? onError,
  }) async {
    final size = MediaQuery.sizeOf(context);
    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;
    String query;
    if (kIsAndroid) {
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
    String? body,
    List<String>? urls,
  }) async {
    if (urls != null && urls.length == 1 && subject == null && body == null) {
      Share.shareUri(Uri.parse(urls.first));
      return;
    }
    if (urls != null && urls.isNotEmpty) {
      context.showLoader();
      DownloadHelper.downloadFilesOnly(urls).then((value) {
        if (context.mounted) context.hideLoader();
        if (value.isEmpty) return;
        final xFiles = value.map((e) => XFile(e.path)).toList();
        Share.shareXFiles(xFiles, subject: subject, text: body);
      });
      return;
    }
    if (body != null && body.isNotEmpty) {
      Share.share(body, subject: subject);
      return;
    }
  }

  /// REVIEW UTILS
  static bool get hasReviewed {
    return Preferences.getBoolOrNull(kReviewed) ?? false;
  }

  static void askForReview() {
    if (kIsAndroid) {
      // TODO: IMPLEMENT REVIEW FOR ANDROID
    } else {
      showAppstoreReview();
    }
  }

  static void showAppstoreReview() async {
    final inAppReview = InAppReview.instance;
    final reviewTimes = Preferences.getInt(kReviewShowedTimes);
    if (await inAppReview.isAvailable()) {
      Preferences.setInt(kReviewShowedTimes, reviewTimes + 1);
      if (reviewTimes >= 2) {
        Preferences.setBool(kReviewed, true);
      }
      inAppReview.requestReview();
    }
  }
}
