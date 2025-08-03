import 'package:flutter_andomie/utils/settings.dart';
import 'package:in_app_review/in_app_review.dart';

import '../utils/platform.dart';

const kReviewed = "has_reviewed";
const kReviewShowedTimes = "review_showed_times";

class Review {
  const Review._();

  static bool get hasReviewed => Settings.get(kReviewed, false);

  static void askForReview() {
    if (isAndroid) {
      // TODO: IMPLEMENT REVIEW FOR ANDROID
    } else {
      showAppstoreReview();
    }
  }

  static void showAppstoreReview() async {
    final inAppReview = InAppReview.instance;
    final reviewTimes = Settings.get(kReviewShowedTimes, 0);
    if (await inAppReview.isAvailable()) {
      Settings.set(kReviewShowedTimes, reviewTimes + 1);
      if (reviewTimes >= 2) {
        Settings.set(kReviewed, true);
      }
      inAppReview.requestReview();
    }
  }
}
