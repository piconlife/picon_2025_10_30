part of '_imports.dart';

class Root extends StatefulWidget {
  final Widget? app;
  final AsyncCallback? onInit;
  final ValueChanged<String>? onReady;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onDispose;

  const Root({
    super.key,
    this.app,
    this.onInit,
    this.onReady,
    this.onChanged,
    this.onDispose,
  });

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> with WidgetsBindingObserver {
  bool _initialized = false;

  Future<void> _init(AsyncCallback callback) async {
    final binding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: binding);
    WidgetsBinding.instance.addObserver(this);
    await SystemUi.resetOrientation();
    if (widget.onInit != null) await widget.onInit!();
    Analytics.call(
      name: "root",
      msg: "initializeDateFormatting",
      initializeDateFormatting,
    );
    await callback();
    setState(() => _initialized = true);
    if (widget.onReady != null) widget.onReady!("root");
  }

  void _initAnalytics() {
    Analytics.init(
      platformError: (exception, stackTrace) => true,
      widgetError: (details) {},
    );
  }

  void _initAndomie() {
    Andomie.init(
      dateFormatter: (format, locale, date) {
        locale ??= Translation.i.locale.toString();
        return DateFormat(format, locale).format(date);
      },
      decimalFormatter: (locale, number) {
        locale ??= Translation.i.locale.toString();
        return NumberFormat.decimalPattern(locale).format(number);
      },
      decimalParser: (locale, formattedNumber) {
        locale ??= Translation.i.locale.toString();
        return NumberFormat.decimalPattern(locale).parse(formattedNumber);
      },
    );
  }

  void _initAndrossy() {
    Androssy.init(
      textConverter: (context, value) {
        if (RemoteConfigs.translationAutoMode) return value.tr;
        return value;
      },
      cachedNetworkImageBuilder: (context, config) {
        return CachedNetworkImage(
          alignment: config.alignment,
          color: config.color,
          cacheKey: config.cacheKey,
          cacheManager:
              config.cacheManager is BaseCacheManager
                  ? config.cacheManager as BaseCacheManager
                  : null,
          colorBlendMode: config.colorBlendMode,
          errorListener: config.errorListener,
          errorWidget:
              config.errorWidget ??
              (context, url, error) {
                return InAppCachedNetworkImageError(url: url, error: error);
              },
          fit: config.fit,
          fadeInCurve: config.fadeInCurve,
          fadeInDuration: config.fadeInDuration,
          fadeOutCurve: config.fadeOutCurve,
          fadeOutDuration: config.fadeOutDuration,
          filterQuality: config.filterQuality,
          height: config.height,
          httpHeaders: config.httpHeaders,
          imageBuilder: config.imageBuilder,
          imageRenderMethodForWeb:
              config.imageRenderMethodForWeb is ImageRenderMethodForWeb
                  ? config.imageRenderMethodForWeb as ImageRenderMethodForWeb
                  : ImageRenderMethodForWeb.HtmlImage,
          imageUrl: config.imageUrl,
          key: null,
          matchTextDirection: config.matchTextDirection,
          maxHeightDiskCache: config.maxHeightDiskCache,
          maxWidthDiskCache: config.maxWidthDiskCache,
          memCacheHeight: config.memCacheHeight,
          memCacheWidth: config.memCacheWidth,
          placeholderFadeInDuration: config.placeholderFadeInDuration,
          progressIndicatorBuilder:
              config.progressIndicatorBuilder ??
              (context, url, progress) {
                return InAppCachedNetworkImageProgress(
                  url: url,
                  progress: progress,
                  width: config.width,
                  height: config.height,
                );
              },
          repeat: config.repeat,
          // scale: config.scale,
          useOldImageOnUrlChange: config.useOldImageOnUrlChange,
          width: config.width,
        );
      },
      svgBuilder: (context, e) {
        final t = e.theme ?? AndrossySvgTheme();
        final theme = SvgTheme(
          currentColor: t.currentColor,
          fontSize: t.fontSize,
          xHeight: t.xHeight,
        );
        switch (e.source) {
          case AndrossySvgSource.asset:
            return SvgPicture.asset(
              e.assetName,
              alignment: e.alignment,
              allowDrawingOutsideViewBox: e.allowDrawingOutsideViewBox,
              bundle: e.bundle,
              clipBehavior: e.clipBehavior,
              colorFilter: e.colorFilter,
              excludeFromSemantics: e.excludeFromSemantics,
              fit: e.fit,
              height: e.height,
              key: e.key,
              matchTextDirection: e.matchTextDirection,
              package: e.package,
              placeholderBuilder: e.placeholderBuilder,
              semanticsLabel: e.semanticsLabel,
              theme: theme,
              width: e.width,
            );
          case AndrossySvgSource.file:
            return SvgPicture.file(
              kIsWeb ? e.data : e.file,
              alignment: e.alignment,
              allowDrawingOutsideViewBox: e.allowDrawingOutsideViewBox,
              clipBehavior: e.clipBehavior,
              colorFilter: e.colorFilter,
              excludeFromSemantics: e.excludeFromSemantics,
              fit: e.fit,
              height: e.height,
              key: e.key,
              matchTextDirection: e.matchTextDirection,
              placeholderBuilder: e.placeholderBuilder,
              semanticsLabel: e.semanticsLabel,
              theme: theme,
              width: e.width,
            );
          case AndrossySvgSource.memory:
            return SvgPicture.memory(
              e.bytes,
              alignment: e.alignment,
              allowDrawingOutsideViewBox: e.allowDrawingOutsideViewBox,
              clipBehavior: e.clipBehavior,
              colorFilter: e.colorFilter,
              excludeFromSemantics: e.excludeFromSemantics,
              fit: e.fit,
              height: e.height,
              key: e.key,
              matchTextDirection: e.matchTextDirection,
              placeholderBuilder: e.placeholderBuilder,
              semanticsLabel: e.semanticsLabel,
              theme: theme,
              width: e.width,
            );
          case AndrossySvgSource.network:
            return SvgPicture.network(
              e.url,
              alignment: e.alignment,
              allowDrawingOutsideViewBox: e.allowDrawingOutsideViewBox,
              clipBehavior: e.clipBehavior,
              colorFilter: e.colorFilter,
              excludeFromSemantics: e.excludeFromSemantics,
              fit: e.fit,
              headers: e.headers,
              height: e.height,
              httpClient: null,
              key: e.key,
              matchTextDirection: e.matchTextDirection,
              placeholderBuilder: e.placeholderBuilder,
              semanticsLabel: e.semanticsLabel,
              theme: theme,
              width: e.width,
            );
          case AndrossySvgSource.string:
            return SvgPicture.string(
              e.assetName,
              alignment: e.alignment,
              allowDrawingOutsideViewBox: e.allowDrawingOutsideViewBox,
              clipBehavior: e.clipBehavior,
              colorFilter: e.colorFilter,
              excludeFromSemantics: e.excludeFromSemantics,
              fit: e.fit,
              height: e.height,
              key: e.key,
              matchTextDirection: e.matchTextDirection,
              placeholderBuilder: e.placeholderBuilder,
              semanticsLabel: e.semanticsLabel,
              theme: theme,
              width: e.width,
            );
        }
      },
    );
  }

  Future<void> _initAssets() async {
    await Assets.preload([...kAssetsPreloads]);
  }

  Future<void> _initConfigs() async {
    await Configs.init(
      name: LocalConfigs.configName,
      connected: Internet.i.value,
      delegate: InAppConfigDelegate(),
      paths: LocalConfigs.configPaths,
      showLogs: LocalConfigs.configLogs,
      defaultPath: LocalConfigs.configDefault,
      platform: LocalConfigs.configPlatform,
      environment: LocalConfigs.configEnvironment,
    );
  }

  Future<void> _initConnectivity() async {
    await Internet.init(
      connected: ConnectivityHelper.isConnected,
      connection: ConnectivityHelper.changed,
    );
    Internet.i.addListener(() {
      final connected = Internet.i.value;
      Configs.i.changeConnection(connected);
      Translation.i.changeConnection(connected);
      ZotloService.i.changeConnection(connected);
      InAppPurchaser.changeConnection(connected);
      InAppListeners.connectivityChanged(connected);
    });
  }

  Future<void> _initCustomizers() async {
    DeviceConfig.init(
      watch: InAppDevices.watch,
      mobile: InAppDevices.mobile,
      tablet: InAppDevices.tablet,
      laptop: InAppDevices.laptop,
      desktop: InAppDevices.desktop,
      tv: InAppDevices.tv,
    );
    DimenInitializer.init(
      appbar: InAppDimens.appbar,
      avatar: InAppDimens.avatar,
      bottom: InAppDimens.bottom,
      button: InAppDimens.button,
      corner: InAppDimens.corner,
      divider: InAppDimens.divider,
      fontSize: InAppDimens.fontSize,
      fontWeight: InAppDimens.fontWeight,
      icon: InAppDimens.icon,
      image: InAppDimens.image,
      indicator: InAppDimens.indicator,
      logo: InAppDimens.logo,
      margin: InAppDimens.margin,
      padding: InAppDimens.padding,
      scaffold: InAppDimens.scaffold,
      size: InAppDimens.size,
      spacing: InAppDimens.space,
      stroke: InAppDimens.stroke,
      dimens: InAppDimens.customs,
    );
    ColorTheme.tryParse(Configs.getByName("themes"))?.apply();
  }

  void _initDatabase() {
    InAppDatabase.init(
      delegate: LocalDatabaseDelegate(),
      name: LocalConfigs.inAppDatabaseName,
      showLogs: LocalConfigs.inAppDatabaseLogs,
      type: LocalConfigs.inAppDatabaseType,
      version: LocalConfigs.inAppDatabaseVersion,
    );
  }

  void _initNavigator() {
    InAppNavigator.init(delegate: const NavigatorDelegate());
  }

  void _initDialogs() {
    Loader.init(
      barrierDismissible: true,
      barrierBlurSigma: 10,
      barrierColor: context.dark.withValues(alpha: .075),
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 300),
      builder: (context, content) {
        return InAppLoadingDialog();
      },
    );
    Dialogs.init(
      snackBarConfig: (context) {
        return SnackBarConfig(
          builder: (context, content) {
            return InAppSnackBar(
              color: context.primary,
              title:
                  content.titleText ??
                  "ok_title".trWithOption(
                    name: "snack_bar",
                    defaultValue: "Well done!",
                  ),
              message: content.bodyText,
            );
          },
        );
      },
      infoSnackBarConfig: (context) {
        return SnackBarConfig(
          builder: (context, content) {
            return InAppSnackBar(
              color: context.secondary,
              title:
                  content.titleText ??
                  "info_title".trWithOption(
                    name: "snack_bar",
                    defaultValue: "Hi there!",
                  ),
              message: content.bodyText,
            );
          },
        );
      },
      waitingSnackBarConfig: (context) {
        return SnackBarConfig(
          builder: (context, content) {
            return InAppSnackBar(
              color: context.mid,
              title:
                  content.titleText ??
                  "waiting_title".trWithOption(
                    name: "snack_bar",
                    defaultValue: "Waiting!",
                  ),
              message: content.bodyText,
            );
          },
        );
      },
      warningSnackBarConfig: (context) {
        return SnackBarConfig(
          builder: (context, content) {
            return InAppSnackBar(
              color: context.warning,
              title:
                  content.titleText ??
                  "warning_title".trWithOption(
                    name: "snack_bar",
                    defaultValue: "Warning!",
                  ),
              message: content.bodyText,
            );
          },
        );
      },
      errorSnackBarConfig: (context) {
        return SnackBarConfig(
          builder: (context, content) {
            return InAppSnackBar(
              color: context.error,
              title:
                  content.titleText ??
                  "error_title".trWithOption(
                    name: "snack_bar",
                    defaultValue: "Oops!",
                  ),
              message: content.bodyText,
            );
          },
        );
      },
      alertDialogConfig: (context) {
        return AlertDialogConfig(
          builder: (context, content) {
            return InAppAlertDialog(
              title: content.titleText ?? "",
              titleSpans: content.titleSpans,
              subtitle: content.bodyText ?? "",
              subtitleSpans: content.bodySpans,
              icon: content.args,
              positiveButtonText: content.positiveButtonText,
              negativeButtonText: content.negativeButtonText,
            );
          },
        );
      },
      editableDialogConfig: (context) {
        return EditableDialogConfig(
          duration: const Duration(milliseconds: 500),
          reverseDuration: const Duration(milliseconds: 300),
          builder: (context, content) {
            return InAppEditorDialog(
              title: content.titleText,
              hint: content.hint,
              text: content.text,
              maxCharacters: content.maxCharacters,
              minCharacters: content.minCharacters,
              maxLines: content.maxLines,
              minLines: content.minLines,
              inputType: content.inputType,
              actionType: content.actionType,
              args: content.args,
            );
          },
        );
      },
      editableSheetConfig: (context) {
        return EditableSheetConfig(
          duration: const Duration(milliseconds: 500),
          reverseDuration: const Duration(milliseconds: 300),
          builder: (context, content) {
            return InAppEditorBottomSheet(
              title: content.titleText,
              hint: content.hint,
              text: content.text,
              maxCharacters: content.maxCharacters,
              minCharacters: content.minCharacters,
              maxLines: content.maxLines,
              minLines: content.minLines,
              inputType: content.inputType,
              actionType: content.actionType,
              args: content.args,
            );
          },
        );
      },
      messageDialogConfig: (context) {
        return MessageDialogConfig(
          duration: const Duration(milliseconds: 500),
          reverseDuration: const Duration(milliseconds: 300),
          builder: (context, content) {
            return InAppMessageDialog(
              title: content.titleText,
              message: content.bodyText,
            );
          },
        );
      },
      optionDialogConfig: (context) {
        return OptionDialogConfig(
          duration: const Duration(milliseconds: 500),
          reverseDuration: const Duration(milliseconds: 300),
          builder: (context, content) {
            return InAppOptionDialog(
              title: content.titleText,
              subtitle: content.bodyText,
              options: content.options.map((e) => e.toString()).toList(),
              initialIndex: content.initialIndex,
            );
          },
        );
      },
      optionSheetConfig: (context) {
        return OptionSheetConfig(
          duration: const Duration(milliseconds: 500),
          reverseDuration: const Duration(milliseconds: 300),
          builder: (context, content) {
            return InAppOptionBottomSheet(
              title: content.titleText,
              subtitle: content.bodyText,
              options: content.options.map((e) => e.toString()).toList(),
              initialIndex: content.initialIndex,
            );
          },
        );
      },
      configs: kDialogConfigs,
    );
  }

  Future<void> _initHive() async {
    await HiveInitializer.init();
  }

  void _initNotifications() async {
    InAppNotifications.init(
      onReady: () {
        if (widget.onReady != null) widget.onReady!("notifications");
      },
    );
  }

  Future<void> _initSettings() async {
    await Settings.init(delegate: InAppSettingsDelegate());
  }

  void _initStorage() {
    StorageService.init(
      delegate: InAppStorageDelegate(),
      connectionStatus: ConnectivityHelper.isConnected,
    );
  }

  void _initSplash() async {
    await Future.delayed(
      const Duration(milliseconds: LocalConfigs.splashTimeForNative),
    );
    FlutterNativeSplash.remove();
  }

  Future<void> _initLocation() async {
    await LocationHelper.init();
  }

  Future<void> _initTranslation() async {
    await Translation.init(
      connected: Internet.i.value,
      autoTranslateMode: RemoteConfigs.translationAutoMode,
      showLogs: LocalConfigs.translationShowLogs,
      locale: RemoteSettings.translationSavedLocale,
      defaultLocale: RemoteSettings.translationSavedLocale,
      fallbackLocale: LocalConfigs.translationFallbackLocale,
      supportedLocales: RemoteConfigs.translationSupportedLocales,
      paths: InAppReferences.translationPaths,
      delegate: InAppTranslationDelegate(),
      translator: InAppTranslatorDelegate(),
      onReady: () {
        if (widget.onReady != null) widget.onReady!("translations");
      },
    );

    if (widget.onChanged != null) {
      Translation.i.addListener(() {
        widget.onChanged!("translations");
      });
    }
  }

  Future<void> _initZotlo() async {
    if (RemoteConfigs.zotloPackages.isEmpty ||
        RemoteConfigs.zotloAccessKey.isEmpty ||
        RemoteConfigs.zotloSecretKey.isEmpty) {
      return;
    }
    return ZotloService.init(
      connected: Internet.i.value,
      key: RemoteConfigs.zotloAccessKey,
      secret: RemoteConfigs.zotloSecretKey,
      appId: RemoteConfigs.zotloAppId,
      packageIds: RemoteConfigs.zotloPackages,
      subscriberId: UserHelper.email,
      expireDate: RemoteSettings.zotloExpireDate,
      onReady: (expireDate) => Settings.set(kZotloExpireDate, expireDate),
    );
  }

  @override
  void initState() {
    super.initState();
    _init(() async {
      await _initConnectivity();
      await _initAssets();
      await _initHive();
      await _initConfigs();
      await _initSettings();
      await _initCustomizers();
      await _initLocation();
      await _initTranslation();
      await _initZotlo();
      _initAndomie();
      _initAndrossy();
      _initAnalytics();
      _initDatabase();
      _initDialogs();
      _initNavigator();
      _initNotifications();
      _initStorage();
      _initSplash();
    });
  }

  void _resetTranslation(List<Locale>? locales) {
    final currentLocale = locales?.firstOrNull;
    Translation.changeLocale(currentLocale);
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    _resetTranslation(locales);
  }

  void _dispose(AsyncCallback callback) async {
    WidgetsBinding.instance.removeObserver(this);
    CoverManager.kill();
    if (widget.onDispose != null) widget.onDispose!();
    await callback();
  }

  void _disposeAndomie() {}

  void _disposeConfigs() {
    Configs.i.dispose();
  }

  void _disposeConnectivity() {
    Internet.i.removeListener(() {
      Configs.i.changeConnection(false);
      Translation.i.changeConnection(false);
      ZotloService.i.changeConnection(false);
      InAppPurchaser.changeConnection(false);
      InAppListeners.connectivityChanged(false);
    });
  }

  void _disposeNotifications() {
    InAppNotifications.dispose();
  }

  void _disposeTranslation() {
    if (widget.onChanged != null) {
      Translation.i.removeListener(() {
        widget.onChanged!("translations");
      });
    }
    Translation.i.dispose();
  }

  void _disposeZotlo() {
    ZotloService.i.dispose();
  }

  @override
  void dispose() {
    super.dispose();
    _dispose(() async {
      _disposeAndomie();
      _disposeConfigs();
      _disposeConnectivity();
      _disposeNotifications();
      _disposeTranslation();
      _disposeZotlo();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return SizedBox();
    Widget child = widget.app ?? App();
    child = _buildAuthProvider(child);
    return child;
  }

  Widget _buildAuthProvider(Widget child) {
    return AuthProvider<User>(
      initialCheck: LocalConfigs.authInitialCheck,
      authorizer: Authorizer(
        delegate: InAppAuthDelegate(),
        backup: InAppAuthBackupDelegate(),
      ),
      child: child,
    );
  }
}
