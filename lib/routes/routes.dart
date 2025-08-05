part of '_imports.dart';

class InAppRouter extends InAppRouteGenerator {
  const InAppRouter._() : super(home: Routes.main);

  static InAppRouter get I => const InAppRouter._();

  static String get initialRoute => Routes.splash;

  static Map<String, RouteBuilder> get values => I.pages();

  @override
  TextDirection get textDirection => Translation.textDirection;

  @override
  Widget defaultPage(context, data) => kSplashRoute(context, data);

  @override
  Route<T> defaultRoute<T>(
    RouteSettings settings,
    InAppRouteConfig config,
    WidgetBuilder builder,
  ) {
    return MaterialWithModalsPageRoute(builder: builder);
  }

  @override
  Map<String, RouteBuilder> pages() {
    return {
      ...mAboutsRoutes,
      ...mChannelRoutes,
      ...mChooserRoutes,
      ...mMainRoutes,
      ...mPreviewRoutes,
      ...mProfileRoutes,
      ...mServiceRoutes,
      ...mSettingsRoutes,
      ...mShopRoutes,
      ...mStoreRoutes,
      ...mSocialRoutes,
      ...mStartupRoutes,
      ...mUserRoutes,
    };
  }
}
