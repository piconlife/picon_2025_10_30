part of 'view.dart';

typedef OnCountdownBuilder = Widget Function(
  BuildContext context,
  Duration duration,
);
typedef OnCountdownRemainingListener = void Function(Duration duration);
typedef OnCountdownCompleteListener = void Function(bool complete);
