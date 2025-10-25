part of '_imports.dart';

class Root extends StatefulWidget {
  final Widget? app;
  final AsyncCallback? onInit;
  final void Function(BuildContext context)? onReady;
  final VoidCallback? onDispose;

  const Root({super.key, this.app, this.onInit, this.onReady, this.onDispose});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> with WidgetsBindingObserver {
  bool _initialized = false;

  Future<void> _init(AsyncCallback callback) async {
    return Analytics.callAsync(name: "root", reason: "init", () async {
      WidgetsBinding.instance.addObserver(this);
      await SystemUi.resetOrientation();
      if (widget.onInit != null) await widget.onInit!();
      await callback();
      setState(() => _initialized = true);
      _ready('root');
    });
  }

  void _ready(String tag) {
    if (widget.onReady == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onReady!(context);
    });
  }

  Future<void> _initIntl() {
    return Analytics.callAsync(name: "intl", reason: "init", () async {
      await initializeDateFormatting();
    });
  }

  void _initAndomie() {
    return Analytics.call(name: "andomie", reason: "init", () {
      Andomie.init(
        dateFormatter: (format, locale, date) {
          return Analytics.execute(name: "intl", reason: "date_format", () {
                locale ??= Translation.i.locale.toString();
                return DateFormat(format, locale).format(date);
              }) ??
              '';
        },
        decimalFormatter: (locale, number) {
          return Analytics.execute(name: "intl", reason: "number_format", () {
                locale ??= Translation.i.locale.toString();
                return NumberFormat.decimalPattern(locale).format(number);
              }) ??
              '';
        },
        decimalParser: (locale, formattedNumber) {
          return Analytics.execute(name: "intl", reason: "number_parse", () {
                locale ??= Translation.i.locale.toString();
                return NumberFormat.decimalPattern(
                  locale,
                ).parse(formattedNumber);
              }) ??
              0;
        },
      );
    });
  }

  void _initAndrossy() {
    return Analytics.call(name: "androssy", reason: "init", () {
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
    });
  }

  Future<void> _initAssets() {
    return Analytics.callAsync(name: "assets", reason: "init", () {
      return Assets.preload(LocalConfigs.assetsPreloads);
    });
  }

  Future<void> _initConfigs() {
    return Analytics.callAsync(name: "configs", reason: "init", () async {
      await Configs.init(
        name: LocalConfigs.configName,
        connected: Internet.i.value,
        delegate: InAppConfigDelegate(),
        paths: LocalConfigs.configPaths,
        showLogs: LocalConfigs.configLogs,
        defaultPath: LocalConfigs.configDefault,
        platform: LocalConfigs.configPlatform,
        environment: LocalConfigs.configEnvironment,
        lazy: LocalConfigs.configLazyMode,
        symmetricPaths: LocalConfigs.configSymmetricPaths,
      );
    });
  }

  Future<void> _initConnectivity() {
    return Analytics.callAsync(name: "internet", reason: "init", () async {
      await Internet.init(
        connected: ConnectivityHelper.isConnected,
        connection: ConnectivityHelper.changed,
      );
      Internet.i.addListener(() {
        Analytics.call(name: "internet", reason: "listen", () {
          final connected = Internet.i.value;
          Configs.i.changeConnection(connected);
          Translation.i.changeConnection(connected);
          ZotloService.i.changeConnection(connected);
          InAppPurchaser.changeConnection(connected);
          InAppListeners.connectivityChanged(connected);
        });
      });
    });
  }

  void _initCustomizers() {
    Analytics.call(name: "device_configs", reason: "init", () {
      kDeviceConfig.createInstance();
    });
    Analytics.call(name: "dimen", reason: "init", () {
      kDimen.createInstance();
    });
    Analytics.call(name: "color_theme", reason: "init", () {
      ColorTheme.tryParse(RemoteConfigs.themeConfigs)!.apply();
    });
  }

  Future<void> _initDatabase() {
    return Analytics.callAsync(
      name: "in_app_database",
      reason: "init",
      () async {
        await InAppDatabase.init(
          delegate: LocalDatabaseDelegate(),
          name: LocalConfigs.inAppDatabaseName,
          showLogs: LocalConfigs.inAppDatabaseLogs,
          type: LocalConfigs.inAppDatabaseType,
          version: LocalConfigs.inAppDatabaseVersion,
        );
      },
    );
  }

  void _initNavigator() {
    return Analytics.call(name: "in_app_navigator", reason: "init", () {
      InAppNavigator.init(delegate: const NavigatorDelegate());
    });
  }

  void _initInterfaces() {
    Analytics.call(name: "loader", reason: "init", () {
      Loader.init(
        barrierDismissible: true,
        barrierBlurSigma: 10,
        barrierColor: context.dark.withValues(alpha: .075),
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 300),
        builder: (context, content) => InAppLoadingDialog(),
      );
    });
    Analytics.call(name: "dialogs", reason: "init", () {
      Dialogs.init(
        snackBarConfig: (context) {
          return SnackBarConfig(
            position: AndrossyDialogPosition.top,
            builder: (context, content) {
              return InAppSnackBar(
                color: context.primary,
                title: content.titleText,
                message: content.bodyText,
              );
            },
          );
        },
        infoSnackBarConfig: (context) {
          return SnackBarConfig(
            position: AndrossyDialogPosition.top,
            builder: (context, content) {
              return InAppSnackBar(
                color: context.secondary,
                title: content.titleText,
                message: content.bodyText,
              );
            },
          );
        },
        waitingSnackBarConfig: (context) {
          return SnackBarConfig(
            position: AndrossyDialogPosition.top,
            builder: (context, content) {
              return InAppSnackBar(
                color: context.mid,
                title: content.titleText,
                message: content.bodyText,
              );
            },
          );
        },
        warningSnackBarConfig: (context) {
          return SnackBarConfig(
            position: AndrossyDialogPosition.top,
            builder: (context, content) {
              return InAppSnackBar(
                color: context.warning,
                title: content.titleText,
                message: content.bodyText,
              );
            },
          );
        },
        errorSnackBarConfig: (context) {
          return SnackBarConfig(
            position: AndrossyDialogPosition.top,
            builder: (context, content) {
              return InAppSnackBar(
                color: context.error,
                title: content.titleText,
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
        configs: LocalConfigs.dialogConfigs,
      );
    });
  }

  Future<void> _initHive() {
    return Analytics.callAsync(name: "hive", reason: "init", () async {
      await HiveInitializer.init();
    });
  }

  Future<void> _initNotifications() {
    return Analytics.callAsync(
      name: "in_app_notifications",
      reason: "init",
      () async {
        await InAppNotifications.init(onReady: () => _ready('notifications'));
      },
    );
  }

  Future<void> _initLocation() {
    return Analytics.callAsync(name: "location_helper", reason: "init", () {
      return LocationHelper.init();
    });
  }

  void _initHitLogger() {
    if (!LocalConfigs.hitLogger) return;
    Analytics.call(name: "hit_logger", reason: "init", () {
      HitLogger.init(
        onClientCheck: (value) {
          return true;
        },
        onClientListen: (value) {
          log(value.toString());
        },
      );
    });
  }

  Future<void> _initPurchaser() {
    return Analytics.callAsync(name: "in_app_purchaser", reason: "init", () {
      return InAppPurchaser.init(
        logEnabled: LocalConfigs.inAppPurchaseLogs,
        logThrowEnabled: LocalConfigs.inAppPurchaseThrowLogs,
        defaultPlacement: RemoteConfigs.subscriptionDefaultPlacementId,
        delegate: LocalConfigs.inAppPurchaseDelegate,
        rtlSupported: RemoteConfigs.isPurchasePaywallRtlEnabled,
        rtlLanguages: RemoteConfigs.subscriptionRtlLanguages,
        connection: Internet.isConnected,
        uid: UserHelper.uid,
        enabled: RemoteConfigs.isPurchasePaywallEnabled,
        features: RemoteConfigs.subscriptionFeatures,
        dark: RemoteConfigs.isPurchasePaywallDefaultDarkTheme,
        locale: Translation.i.locale,
        ignorableUsers: RemoteConfigs.subscriptionIgnorableUids,
        ignorableIndexes:
            RemoteConfigs.subscriptionIgnorableMappedFeatureIndexes,
        configDelegate: InAppPurchaseConfigDelegateImpl(),
      );
    });
  }

  void _initStorage() {
    Analytics.call(name: "storage", reason: 'init', () {
      return StorageService.init(
        delegate: InAppStorageDelegate(),
        connectionStatus: ConnectivityHelper.isConnected,
      );
    });
  }

  Future<void> _initSettings() {
    return Analytics.callAsync(name: "settings", reason: "init", () async {
      await Settings.init(
        initial: LocalConfigs.settings,
        showLogs: LocalConfigs.settingsLogs,
        delegate: InAppSettingsDelegate(),
      );
    });
  }

  Future<void> _initSplash() {
    return Analytics.callAsync(
      name: "native_splash",
      reason: "remove",
      () async {
        await Future.delayed(
          Duration(milliseconds: LocalConfigs.splashTimeForNative),
        );
        FlutterNativeSplash.remove();
      },
    );
  }

  Future<void> _initTranslation() {
    return Analytics.callAsync(name: "translation", reason: "init", () {
      return Translation.init(
        connected: Internet.i.value,
        autoTranslateMode: RemoteConfigs.translationAutoMode,
        showLogs: LocalConfigs.translationShowLogs,
        locale: RemoteSettings.translationSavedLocale,
        fallbackLocale: LocalConfigs.translationFallback,
        supportedLocales: RemoteConfigs.translationSupportedLocales,
        paths: InAppReferences.translationPaths,
        delegate: InAppTranslationDelegate(),
        translator: InAppTranslatorDelegate(),
        lazy: RemoteConfigs.translationLazyMode,
        symmetricPaths: LocalConfigs.translationSymmetricPaths,
        onReady: () => _ready('translations'),
      );
    });
  }

  Future<void> _initUserTracker() {
    return Analytics.callAsync(name: "user_tracker", reason: "init", () async {
      await UserTracker.init(delegate: InAppUserTrackerDelegate());
    });
  }

  Future<void> _initUniqueId() {
    return Analytics.callAsync(
      name: "unique_id_service",
      reason: "init",
      () async {
        if (Configs.get("application/firebase_app", defaultValue: false)) {
          return;
        }
        await UniqueIdService.init();
      },
    );
  }

  Future<void> _initZotlo() async {
    if (RemoteConfigs.zotloPackages.isEmpty ||
        RemoteConfigs.zotloAccessKey.isEmpty ||
        RemoteConfigs.zotloSecretKey.isEmpty) {
      return Analytics.warning(
        "zotlo_service",
        "init",
        msg: "all zotlo configs empty",
      );
    }
    return Analytics.callAsync(name: "zotlo_service", reason: "init", () {
      return ZotloService.init(
        connected: Internet.i.value,
        key: RemoteConfigs.zotloAccessKey,
        secret: RemoteConfigs.zotloSecretKey,
        appId: RemoteConfigs.zotloAppId,
        packageIds: RemoteConfigs.zotloPackages,
        subscriberId: UserHelper.email,
        expireDate: RemoteSettings.zotloExpireDate,
        onReady: InAppListeners.handleZotloReady,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _init(() async {
      await _initConnectivity();
      await _initAssets();
      await _initHive();
      _initHitLogger();
      await _initConfigs();
      await _initUniqueId();
      await _initSettings();
      await _initLocation();
      await _initTranslation();
      _initAndomie();
      _initAndrossy();
      _initCustomizers();
      _initIntl();
      await _initZotlo();
      _initUserTracker();
      _initPurchaser();
      _initDatabase();
      _initInterfaces();
      _initNavigator();
      _initNotifications();
      _initStorage();
      _initSplash();
    });
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    Translation.changeDefaultLocale(locales?.firstOrNull);
  }

  void _dispose(AsyncCallback callback) async {
    WidgetsBinding.instance.removeObserver(this);
    CoverManager.kill();
    if (widget.onDispose != null) widget.onDispose!();
    await callback();
  }

  @override
  void dispose() {
    Internet.i.removeListener(() {
      Configs.i.changeConnection(false);
      Translation.i.changeConnection(false);
      ZotloService.i.changeConnection(false);
      InAppPurchaser.changeConnection(false);
      InAppListeners.connectivityChanged(false);
    });
    _dispose(() async {
      CoverManager.kill();
      InAppNotifications.dispose();
      Internet.i.removeListener(() {});
      Internet.i.dispose();
      Configs.i.dispose();
      Translation.i.dispose();
      ZotloService.i.dispose();
    });
    super.dispose();
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
