/// Extension on DateTime to convert to human-readable "time ago" format
extension DurationAgoExtension on Duration {
  /// Helper method to pluralize words
  String _pluralize(String word, int count) {
    if (word.length <= 3) return word;
    return count == 1 ? word : '${word}s';
  }

  /// Converts the Duration to a human-readable "time ago" string
  ///
  /// Examples:
  /// - "just now" (< 1 minute)
  /// - "5 minutes ago"
  /// - "2 hours ago"
  /// - "3 days ago"
  /// - "2 weeks ago"
  /// - "1 month ago"
  /// - "1 year ago"
  String toTimeAgo({
    int secondsForNow = 60,
    String afterText = 'After ',
    String agoText = ' ago',
    String yearText = ' year',
    String monthText = ' month',
    String weekText = ' week',
    String dayText = ' day',
    String hourText = ' hour',
    String minuteText = ' minute',
    String secondText = ' second',
    String nowText = 'just now',
    String futureText = 'in the future',
  }) {
    afterText = isNegative ? afterText : '';
    agoText = isNegative ? '' : agoText;

    if (afterText.isEmpty && futureText.isNotEmpty && isNegative) {
      return futureText;
    }

    // Less than a minute
    final seconds = inSeconds.abs();
    if (seconds < 60) {
      if (seconds < secondsForNow) return nowText;
      return '$afterText$seconds${_pluralize(secondText, seconds)}$agoText';
    }

    // Minutes
    final minutes = inMinutes.abs();
    if (minutes < 60) {
      return '$afterText$minutes${_pluralize(minuteText, minutes)}$agoText';
    }

    // Hours
    final hours = inHours.abs();
    if (hours < 24) {
      return '$afterText$hours${_pluralize(hourText, hours)}$agoText';
    }

    // Days
    final days = inDays.abs();
    if (days < 7) {
      return '$afterText$days${_pluralize(dayText, days)}$agoText';
    }

    // Weeks
    if (days < 30) {
      final weeks = (days / 7).floor();
      return '$afterText$weeks${_pluralize(weekText, weeks)}$agoText';
    }

    // Months
    if (days < 365) {
      final months = (days / 30).floor();
      return '$afterText$months${_pluralize(monthText, months)}$agoText';
    }

    // Years
    final years = (days / 365).floor();
    return '$afterText$years${_pluralize(yearText, years)}$agoText';
  }

  /// Alternative version with short format (e.g., "5m", "2h", "3d")
  String toTimeAgoShort({
    int secondsForNow = 60,
    String afterText = '',
    String agoText = '',
    String yearText = 'y',
    String monthText = 'mo',
    String weekText = 'w',
    String dayText = 'd',
    String hourText = 'h',
    String minuteText = 'm',
    String secondText = 's',
    String nowText = 'now',
    String futureText = '',
  }) {
    return toTimeAgo(
      secondsForNow: secondsForNow,
      afterText: afterText,
      agoText: agoText,
      yearText: yearText,
      monthText: monthText,
      weekText: weekText,
      dayText: dayText,
      hourText: hourText,
      minuteText: minuteText,
      secondText: secondText,
      nowText: nowText,
      futureText: futureText,
    );
  }
}

/// Extension on DateTime to convert to human-readable "time ago" format
extension TimeAgoExtension on DateTime {
  /// Converts the DateTime to a human-readable "time ago" string
  ///
  /// Examples:
  /// - "just now" (< 1 minute)
  /// - "5 minutes ago"
  /// - "2 hours ago"
  /// - "3 days ago"
  /// - "2 weeks ago"
  /// - "1 month ago"
  /// - "1 year ago"
  String toTimeAgo({
    DateTime? from,
    int secondsForNow = 60,
    String afterText = 'After ',
    String agoText = ' ago',
    String yearText = ' year',
    String monthText = ' month',
    String weekText = ' week',
    String dayText = ' day',
    String hourText = ' hour',
    String minuteText = ' minute',
    String secondText = ' second',
    String nowText = 'just now',
    String futureText = 'in the future',
  }) {
    final now = from ?? DateTime.now();
    final difference = now.difference(this);
    return difference.toTimeAgo(
      secondsForNow: secondsForNow,
      afterText: afterText,
      agoText: agoText,
      yearText: yearText,
      monthText: monthText,
      weekText: weekText,
      dayText: dayText,
      hourText: hourText,
      minuteText: minuteText,
      secondText: secondText,
      nowText: nowText,
      futureText: futureText,
    );
  }

  /// Alternative version with short format (e.g., "5m", "2h", "3d")
  String toTimeAgoShort({
    DateTime? from,
    int secondsForNow = 60,
    String afterText = '',
    String agoText = '',
    String yearText = 'y',
    String monthText = 'mo',
    String weekText = 'w',
    String dayText = 'd',
    String hourText = 'h',
    String minuteText = 'm',
    String secondText = 's',
    String nowText = 'now',
    String futureText = '',
  }) {
    return toTimeAgo(
      from: from,
      secondsForNow: secondsForNow,
      afterText: afterText,
      agoText: agoText,
      yearText: yearText,
      monthText: monthText,
      weekText: weekText,
      dayText: dayText,
      hourText: hourText,
      minuteText: minuteText,
      secondText: secondText,
      nowText: nowText,
      futureText: futureText,
    );
  }
}
