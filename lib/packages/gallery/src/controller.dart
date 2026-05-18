import 'dart:async';
import 'dart:convert';
import 'dart:io' show File;
import 'dart:isolate' if (dart.library.html) 'isolate_stub.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:photo_manager/photo_manager.dart'
    hide PermissionState, AssetType;

import '../../../roots/preferences/preferences.dart' show Preferences;
import '../../../roots/utils/device_settings.dart' show DeviceSettings;
import 'data.dart' show GalleryData;
import 'directory.dart' show GalleryDirectory;
import 'enums.dart';
import 'filter.dart';
import 'platform.dart';
import 'typedefs.dart' show LaunchCameraHandler;

part 'cache.dart';
part 'isolate.dart';
part 'semaphore.dart';

class GalleryController extends ChangeNotifier {
  GalleryController({
    this.type = GalleryType.all,
    required this.filter,
    this.filters,
    this.maxSelection = 10,
    this.pageSize = 80,
    FilterConfig filterConfig = FilterConfig.none,
    this.lazyFilterHandler,
    this.eagerFilterHandler,
    this.launchCameraHandler,
    this.thumbnailPrefetchConcurrency = 6,
    this.lazyFilterConcurrency = 3,
    this.lazyPrewarmWindow = 6,
    this.allowMultipleVideoSelection = false,
  }) : _filterConfig = filterConfig,
       _activeMode = type;

  final GalleryType type;
  final Filter filter;
  final Map<FilterType, double?>? filters;
  final int maxSelection;
  final int pageSize;
  final int thumbnailPrefetchConcurrency;
  final int lazyFilterConcurrency;
  final int lazyPrewarmWindow;
  final bool allowMultipleVideoSelection;
  final LazyFilterHandler? lazyFilterHandler;
  final EagerFilterHandler? eagerFilterHandler;
  final LaunchCameraHandler? launchCameraHandler;

  static final _LruCache<String, Uint8List?> _cache = _LruCache(500);
  static final Map<String, List<FilterType>> _cachedFilters = {};
  static bool _filterCacheLoaded = false;

  static const _cacheKey = '__gallery_filtered_caches__';
  static const _maxPersistedEntries = 1000;

  static Future<void> _loadFilterCache() async {
    if (_filterCacheLoaded || _cachedFilters.isNotEmpty) return;
    _filterCacheLoaded = true;

    final raw = Preferences.getStringOrNull(_cacheKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final decoded = jsonDecode(raw) as Map;
      final entries = decoded.entries.toList();

      final trimmed =
          entries.length > _maxPersistedEntries
              ? entries.sublist(entries.length - _maxPersistedEntries)
              : entries;

      for (final entry in trimmed) {
        final types =
            (entry.value as List)
                .map(
                  (name) => FilterType.values.firstWhere(
                    (t) => t.name == name,
                    orElse: () => FilterType.none,
                  ),
                )
                .where((t) => t != FilterType.none)
                .toList();
        _cachedFilters[entry.key] = types;
      }
    } catch (_) {
      Preferences.remove(_cacheKey);
    }
  }

  static Future<void> _persistFilterCache() async {
    try {
      final encoded = jsonEncode(
        _cachedFilters.map(
          (id, types) => MapEntry(id, types.map((t) => t.name).toList()),
        ),
      );
      Preferences.setString(_cacheKey, encoded);
    } catch (_) {}
  }

  GalleryType _activeMode;

  GalleryType get activeMode => _activeMode;

  FilterConfig _filterConfig;

  FilterConfig get filterConfig => _filterConfig;

  bool get hasFilter => _filterConfig.hasRules;

  PermissionState permissionStatus = PermissionState.denied;

  bool get permissionGranted => permissionStatus.hasAccess;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  bool _loadingMore = false;

  bool get loadingMore => _loadingMore;

  Object? _error;

  Object? get error => _error;

  bool get hasError => _error != null;

  final Map<GalleryType, GalleryDirectory?> _albumPerType = {};
  final Map<GalleryType, String> _albumNamePerType = {};

  GalleryDirectory? get currentAlbum => _albumPerType[_activeMode];

  String get currentAlbumName => _albumNamePerType[_activeMode] ?? 'Recent';

  List<GalleryDirectory> _albums = [];

  List<GalleryDirectory> get albums => List.unmodifiable(_albums);

  final List<GalleryData> _assets = [];

  List<GalleryData> get assets => List.unmodifiable(_assets);

  bool _hasMore = true;

  bool get hasMore => _hasMore;

  int _currentPage = 0;

  int _filteredOutCount = 0;

  int get filteredOutCount => _filteredOutCount;

  final List<GalleryData> _imageSelected = [];
  final List<GalleryData> _videoSelected = [];

  List<GalleryData> get _activeSelected =>
      _activeMode == GalleryType.video ? _videoSelected : _imageSelected;

  List<GalleryData> get selectedAssets => List.unmodifiable(_activeSelected);

  int get selectedCount => _activeSelected.length;

  bool get isRecentAlbum =>
      _albums.isEmpty || currentAlbum?.id == _albums.first.id;

  final Map<String, Future<Uint8List?>> _thumbnailFutures = {};

  LazyFilterIsolate? _filterIsolate;

  final List<String> _lazyQueue = [];
  int _lazyGeneration = 0;
  _Semaphore? _lazySemaphore;
  _Semaphore? _lazyPrewarmSemaphore;

  bool _notifyScheduled = false;
  int _pendingResolves = 0;
  static const int _notifyBatchSize = 5;

  void _scheduleNotify({bool force = false}) {
    _pendingResolves++;
    if (force || _pendingResolves >= _notifyBatchSize) {
      if (_notifyScheduled) return;
      _notifyScheduled = true;
      Future.microtask(_flushNotify);
      return;
    }
    if (_notifyScheduled) return;
    _notifyScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) => _flushNotify());
  }

  void _flushNotify() {
    _notifyScheduled = false;
    _pendingResolves = 0;
    notifyListeners();
  }

  Future<void> initialize([GalleryType? startingMode]) async {
    if (startingMode != null) _activeMode = startingMode;

    if (kIsWeb) {
      _isLoading = false;
      permissionStatus = PermissionState.denied;
      notifyListeners();
      return;
    }

    await _loadFilterCache();
    await _spawnIsolateIfNeeded();
    permissionStatus = await checkPermission();
    if (permissionGranted) {
      await _fetchAlbums();
    } else {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> _checkPermission() async {
    if (kIsWeb) return false;
    final status = await checkPermission();
    return status.hasAccess;
  }

  Future<PermissionState> checkPermission() async {
    if (kIsWeb) return PermissionState.denied;
    final state = await PhotoManager.getPermissionState(
      requestOption: PermissionRequestOption(),
    );
    return state.name.state;
  }

  Future<bool> openSettings({Future<bool> Function()? allowToSettings}) async {
    if (kIsWeb) return false;
    if (allowToSettings != null) {
      if (!(await allowToSettings())) return false;
    }
    final allow = await DeviceSettings.open(
      check: _checkPermission,
      open: PhotoManager.openSetting,
    );
    return allow;
  }

  Future<bool> requestPermission({
    Future<bool> Function()? allowToSettings,
  }) async {
    if (kIsWeb) return false;
    try {
      if (permissionStatus.isLimited && isIos) {
        await PhotoManager.presentLimited();
        permissionStatus = await checkPermission();
        if (permissionStatus.hasAccess) await _fetchAlbums();
        return permissionStatus.hasAccess;
      }
      final status = await PhotoManager.requestPermissionExtend();
      permissionStatus = status.name.state;
      if (permissionStatus.hasAccess) {
        await _fetchAlbums();
        return true;
      }
      if (permissionStatus == PermissionState.denied) {
        final granted = await openSettings(allowToSettings: allowToSettings);
        if (granted) {
          permissionStatus = await checkPermission();
          await _fetchAlbums();
        } else {
          notifyListeners();
        }
        return granted;
      }
      notifyListeners();
      return false;
    } catch (e) {
      notifyListeners();
      return false;
    }
  }

  Future<void> switchMode(GalleryType mode) async {
    if (_activeMode == mode) return;
    _activeMode = mode;
    notifyListeners();
    if (!kIsWeb) await _fetchAlbums();
  }

  Future<void> updateFilterConfig(FilterConfig newConfig) async {
    _filterConfig = newConfig;
    if (!kIsWeb && newConfig.hasRules) await _spawnIsolateIfNeeded();
    await fetchAssets(refresh: true);
  }

  Future<void> selectAlbum(GalleryDirectory album) async {
    _albumPerType[_activeMode] = album;
    _albumNamePerType[_activeMode] = album.name.isEmpty ? 'Recent' : album.name;
    notifyListeners();
    await fetchAssets(refresh: true);
  }

  Future<void> fetchMore() async {
    if (!_hasMore || _loadingMore) return;
    await fetchAssets();
  }

  Future<void> fetchAssets({bool refresh = false}) async {
    if (kIsWeb) return;
    if (currentAlbum == null) return;
    if (_loadingMore && !refresh) return;

    if (refresh) {
      _currentPage = 0;
      _assets.clear();
      _clearLazyPipeline();
      _hasMore = true;
      _isLoading = true;
      _filteredOutCount = 0;
      _error = null;
      _thumbnailFutures.clear();
      filter.resetSession();
      notifyListeners();
    }

    _loadingMore = true;

    try {
      final raw = await currentAlbum!.entity
          .getAssetListPaged(page: _currentPage, size: pageSize)
          .then((v) => v.map(GalleryData.new).toList());

      final fetched = _filterByActiveMode(raw);

      if (hasFilter) {
        final allowed = await _applyFilters(fetched);
        _filteredOutCount += fetched.length - allowed.length;
        _assets.addAll(allowed);
        if (_filterConfig.hasLazyRules) {
          _enqueueLazyBatch(allowed.map((a) => a.id).toList());
        }
      } else {
        _assets.addAll(fetched);
      }
      _hasMore = raw.length == pageSize;
      _currentPage++;
    } catch (e) {
      _error = e;
      _hasMore = false;
    } finally {
      _isLoading = false;
      _loadingMore = false;
      notifyListeners();
    }
  }

  List<GalleryData> _filterByActiveMode(List<GalleryData> assets) {
    if (_activeMode == GalleryType.all) return assets;
    final expected =
        _activeMode == GalleryType.image ? AssetType.image : AssetType.video;
    return assets.where((a) => a.type == expected).toList();
  }

  Future<Uint8List?> getThumbnail(GalleryData asset) {
    return _thumbnailFutures.putIfAbsent(
      asset.id,
      () => _fetchAndCacheThumbnail(asset),
    );
  }

  Future<List<FilterType>> detect(
    String id,
    Uint8List bytes, {
    Map<FilterType, double?>? filters,
  }) async {
    filters ??= this.filters;
    if (filters == null || filters.isEmpty) return [];
    if (_cachedFilters.containsKey(id)) {
      return _cachedFilters[id] ?? [];
    }
    return filter.matchedTypes(bytes, filters).then((filtered) {
      _cachedFilters[id] = filtered;
      _persistFilterCache();
      return filtered;
    });
  }

  Future<bool> detectNudity({double? accuracy}) async {
    for (final asset in selectedAssets) {
      final file = await asset.file;
      if (file == null) continue;
      final bytes = await file.readAsBytes();
      final result = await detect(
        asset.id,
        bytes,
        filters: {FilterType.nudity: accuracy},
      );
      return result.contains(FilterType.nudity);
    }
    return false;
  }

  void toggle(GalleryData asset) {
    final sel = _activeSelected;
    if (_activeMode == GalleryType.video && !allowMultipleVideoSelection) {
      final alreadySelected = sel.isNotEmpty && sel.first.id == asset.id;
      sel.clear();
      if (!alreadySelected) sel.add(asset);
    } else {
      final idx = sel.indexWhere((a) => a.id == asset.id);
      if (idx >= 0) {
        sel.removeAt(idx);
      } else if (sel.length < maxSelection) {
        sel.add(asset);
      }
    }
    notifyListeners();
  }

  bool isSelected(GalleryData asset) =>
      _activeSelected.any((a) => a.id == asset.id);

  int selectionIndex(GalleryData asset) =>
      _activeSelected.indexWhere((a) => a.id == asset.id) + 1;

  void clearSelection() {
    if (_activeSelected.isEmpty) return;
    _activeSelected.clear();
    notifyListeners();
  }

  Future<bool> launchCamera() async {
    if (kIsWeb || launchCameraHandler == null) return false;
    final path = await launchCameraHandler!(_activeMode);
    if (path == null) return false;
    return _activeMode == GalleryType.video ? saveVideo(path) : saveImage(path);
  }

  Future<bool> saveImage(String path) async {
    if (kIsWeb) return false;
    try {
      final entity = await PhotoManager.editor.saveImageWithPath(
        path,
        title: 'IMG_${DateTime.now().millisecondsSinceEpoch}',
      );
      prependAsset(GalleryData(entity));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> saveVideo(String path) async {
    if (kIsWeb) return false;
    try {
      final entity = await PhotoManager.editor.saveVideo(
        File(path),
        title: 'VID_${DateTime.now().millisecondsSinceEpoch}',
      );
      prependAsset(GalleryData(entity));
      return true;
    } catch (_) {
      return false;
    }
  }

  void prependAsset(GalleryData asset) {
    if (_assets.any((a) => a.id == asset.id)) return;
    _assets.insert(0, asset);
    notifyListeners();
  }

  void onVisibleIdsChanged(List<String> visibleIds) {
    if (_lazyQueue.isEmpty) return;
    final visibleSet = visibleIds.toSet();
    final prioritized = <String>[];
    final rest = <String>[];
    for (final id in _lazyQueue) {
      (visibleSet.contains(id) ? prioritized : rest).add(id);
    }
    _lazyQueue
      ..clear()
      ..addAll([...prioritized, ...rest]);
    _prewarmAhead();
    _startLazyBatch();
  }

  Future<void> _spawnIsolateIfNeeded() async {
    if (kIsWeb) return;
    if (_filterIsolate != null) return;
    if (!_filterConfig.hasRules) return;
    if (lazyFilterHandler == null && eagerFilterHandler == null) return;
    _filterIsolate = LazyFilterIsolate(
      lazyHandler: lazyFilterHandler ?? _noopLazyHandler,
      eagerHandler: eagerFilterHandler ?? _noopEagerHandler,
    );
    await _filterIsolate!.spawn();
  }

  Future<void> _fetchAlbums() async {
    if (kIsWeb) return;
    final requestType = switch (_activeMode) {
      GalleryType.image => RequestType.image,
      GalleryType.video => RequestType.video,
      GalleryType.all => RequestType.common,
    };

    try {
      final albums = await PhotoManager.getAssetPathList(
        type: requestType,
        filterOption: FilterOptionGroup(
          orders: [
            const OrderOption(type: OrderOptionType.createDate, asc: false),
          ],
        ),
      ).then((v) => v.map(GalleryDirectory.new).toList());

      if (albums.isNotEmpty) {
        _albums = albums;

        final saved = _albumPerType[_activeMode];
        final resolved =
            saved != null && albums.any((a) => a.id == saved.id)
                ? saved
                : albums.first;

        _albumPerType[_activeMode] = resolved;
        _albumNamePerType[_activeMode] =
            resolved.name.isEmpty ? 'Recent' : resolved.name;

        await fetchAssets(refresh: true);
      } else {
        _albums = [];
        _albumPerType[_activeMode] = null;
        _albumNamePerType[_activeMode] = 'Recent';
        _assets.clear();
        _hasMore = false;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _error = e;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<GalleryData>> _applyFilters(List<GalleryData> candidates) async {
    final eagerRules = _filterConfig.eagerRules;
    final lazyRules = _filterConfig.lazyRules;

    var passed =
        eagerRules.isNotEmpty
            ? await _runEagerFilters(
              candidates,
              FilterConfig(rules: eagerRules),
            )
            : candidates;

    if (lazyRules.isNotEmpty) {
      final lazyTypes = lazyRules.map((r) => r.type).toList();
      passed =
          passed.map((a) => a.copyWith(pendingFilters: lazyTypes)).toList();
    }

    return passed;
  }

  Future<List<GalleryData>> _runEagerFilters(
    List<GalleryData> candidates,
    FilterConfig eagerConfig,
  ) async {
    if (candidates.isEmpty) return [];

    final semaphore = _Semaphore(thumbnailPrefetchConcurrency);
    final results = <GalleryData>[];

    for (var i = 0; i < candidates.length; i++) {
      final asset = candidates[i];

      final thumb = await _thumbnailFutures.putIfAbsent(
        asset.id,
        () => semaphore.run(() => _fetchAndCacheThumbnail(asset)),
      );

      if (thumb == null) {
        results.add(asset);
      } else {
        final include =
            _filterIsolate != null
                ? await _filterIsolate!
                    .processEager(thumb, eagerConfig.rules)
                    .timeout(const Duration(seconds: 10), onTimeout: () => true)
                : await filter.shouldInclude(thumb, eagerConfig);

        if (include) results.add(asset);
      }
      if (i % 5 == 0) await Future.delayed(Duration.zero);
    }

    return results;
  }

  void _enqueueLazyBatch(List<String> ids) {
    _lazyQueue.addAll(ids);
    _startLazyBatch();
  }

  void _startLazyBatch() {
    if (_lazyQueue.isEmpty) return;
    _lazySemaphore ??= _Semaphore(lazyFilterConcurrency);
    _lazyPrewarmSemaphore ??= _Semaphore(lazyPrewarmWindow);

    final generation = _lazyGeneration;
    while (_lazyQueue.isNotEmpty) {
      final id = _lazyQueue.removeAt(0);
      _lazySemaphore!.run(() => _processOneLazyItem(id, generation));
    }
  }

  Future<void> _processOneLazyItem(String assetId, int generation) async {
    try {
      if (generation != _lazyGeneration) return;

      final idx = _assets.indexWhere((a) => a.id == assetId);
      if (idx < 0) return;

      final thumb = await _thumbnailFutures
          .putIfAbsent(assetId, () => _fetchAndCacheThumbnail(_assets[idx]))
          .timeout(const Duration(seconds: 5), onTimeout: () => null);

      if (generation != _lazyGeneration) return;

      if (thumb == null) {
        _resolveItem(assetId, null);
        return;
      }

      final matched =
          _filterIsolate != null
              ? await _filterIsolate!
                  .process(thumb, _filterConfig.lazyRules)
                  .timeout(
                    const Duration(seconds: 10),
                    onTimeout: () => FilterType.none,
                  )
              : await filter
                  .firstMatchedType(thumb, _filterConfig.lazyRules)
                  .timeout(
                    const Duration(seconds: 10),
                    onTimeout: () => FilterType.none,
                  );

      if (generation != _lazyGeneration) return;
      _resolveItem(assetId, matched);
    } catch (_) {
      if (generation == _lazyGeneration) _resolveItem(assetId, null);
    }
  }

  void _prewarmAhead() {
    final sem = _lazyPrewarmSemaphore;
    if (sem == null || _lazyQueue.isEmpty) return;

    final generation = _lazyGeneration;
    final limit = _lazyQueue.length.clamp(0, lazyPrewarmWindow);

    for (var i = 0; i < limit; i++) {
      final id = _lazyQueue[i];
      if (_cache.containsKey(id) || _thumbnailFutures.containsKey(id)) continue;
      final assetIdx = _assets.indexWhere((a) => a.id == id);
      if (assetIdx < 0) continue;
      final asset = _assets[assetIdx];
      _thumbnailFutures[id] = sem.run(() async {
        if (generation != _lazyGeneration) return null;
        return _fetchAndCacheThumbnail(asset);
      });
    }
  }

  void _resolveItem(String assetId, FilterType? matched) {
    final idx = _assets.indexWhere((a) => a.id == assetId);
    if (idx < 0) return;

    _thumbnailFutures.remove(assetId);

    if (matched == null || matched == FilterType.none) {
      _assets[idx] = _assets[idx].withLazyResolved();
      _scheduleNotify();
      return;
    }

    final rule = _filterConfig.ruleFor(matched);
    if (rule == null || rule.allow) {
      _assets[idx] = _assets[idx].withLazyResolved(matchedType: matched);
    } else if (matched == FilterType.nudity) {
      _assets[idx] = _assets[idx].withLazyResolved(
        matchedType: matched,
        blur: true,
      );
    } else {
      _assets.removeAt(idx);
      _filteredOutCount++;
    }

    _scheduleNotify();
  }

  Future<Uint8List?> _fetchAndCacheThumbnail(GalleryData asset) async {
    if (_cache.containsKey(asset.id)) return _cache[asset.id];
    final data = await asset.entity.thumbnailDataWithSize(
      const ThumbnailSize(240, 240),
      quality: 80,
    );
    _cache[asset.id] = data;
    return data;
  }

  void _clearLazyPipeline() {
    _lazyQueue.clear();
    _lazyGeneration++;
    _lazySemaphore = null;
    _lazyPrewarmSemaphore = null;
  }

  static Future<FilterType> _noopLazyHandler(
    Uint8List _,
    List<(FilterType, double)> __,
  ) async => FilterType.none;

  static Future<bool> _noopEagerHandler(
    Uint8List _,
    List<(FilterType, double, bool)> __,
  ) async => true;

  @override
  void dispose() {
    _clearLazyPipeline();
    _filterIsolate?.dispose();
    filter.dispose();
    super.dispose();
  }
}
