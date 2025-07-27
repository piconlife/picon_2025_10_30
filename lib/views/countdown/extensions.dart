part of 'view.dart';

extension CountdownDurationExtension on Duration {
  int get days => inDays;

  String get days2D => inDays.x2D;

  String get days3D => inDays.x3D;

  int get hours => inHours - (inDays * 24);

  String get hours2D => hours.x2D;

  String get hours3D => hours.x3D;

  int get minutes => inMinutes - (inHours * 60);

  String get minutes2D => minutes.x2D;

  String get minutes3D => minutes.x3D;

  int get seconds => inSeconds - (inMinutes * 60);

  String get seconds2D => seconds.x2D;

  String get seconds3D => seconds.x3D;

  int get milliseconds => inMilliseconds - (inSeconds * 1000);

  int get microseconds => inMicroseconds - (inMilliseconds * 1000);
}

extension CountdownExtension on int? {
  num get use => this ?? 0;

  String get x2D => use >= 10 ? "$use" : "0$use";

  String get x3D {
    if (use >= 100) {
      return "$use";
    } else if (use >= 10) {
      return "0$use";
    } else {
      return "00$use";
    }
  }
}
