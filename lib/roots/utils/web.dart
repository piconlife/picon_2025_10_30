import "package:web/web.dart" as html;

bool get isAppleDevice {
  final userAgent = html.window.navigator.userAgent.toLowerCase();
  final x =
      userAgent.contains('iphone') ||
      userAgent.contains('ipad') ||
      userAgent.contains('macintosh') ||
      userAgent.contains('mac os');
  return x;
}
