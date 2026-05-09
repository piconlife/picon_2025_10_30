import 'dart:async';
import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:developer' show log;

import 'package:flutter/foundation.dart'
    show ChangeNotifier, kReleaseMode, ValueNotifier;

import '../../lq/src/builder.dart' show QueryBuilder;
import '../../lq/src/query.dart' show Query;
import '../../lq/src/selection.dart' show Selection, Selections;
import '../../lq/src/sorting.dart' show Sorting;
import '../core/document_change_type.dart' show InAppDocumentChangeType;
import '../core/field_path.dart' show InAppFieldPath;
import '../core/field_value.dart' show InAppFieldValue, InAppFieldValues;
import '../core/paging_options.dart' show InAppPagingOptions;
import '../core/path.dart' show PathModifier;
import '../core/source.dart' show InAppSource;
import 'batch.dart' show InAppWriteBatch;
import 'delegate.dart' show InAppDatabaseDelegate;
import 'pointer.dart' show InAppPointer;
import 'transaction.dart' show InAppTransaction, InAppTransactionHandler;

part 'aggregate.dart';
part 'base.dart';
part 'collection.dart';
part 'document.dart';
part 'merger.dart';
part 'notifier.dart';
part 'query.dart';
part 'reference.dart';
part 'snapshots.dart';
part 'version.dart';

enum InAppDatabaseType { json, map }

class InAppDatabase extends ChangeNotifier {
  String _name;
  final bool showLogs;
  final InAppDatabaseDelegate _delegate;
  final InAppDatabaseType _type;
  final Map<String, _InAppNotifier> _notifiers = {};
  InAppDatabaseVersion _version;
  bool _disposed = false;

  String get name => _name == _defaultName ? 'default' : _name;

  String get versionCode => _version.code;

  set versionCode(String code) => version(InAppDatabaseVersion.custom(code));

  String get ref => _version._ref();

  Future<List<String>> get keys async {
    final paths = await _delegate.paths(_name);
    final r = ref;
    final result = <String>{};
    for (final p in paths) {
      if (versionCode != InAppDatabaseVersion.v1.code && !p.startsWith(r)) {
        continue;
      }
      final stripped = r.isEmpty ? p : p.replaceFirst(r, '');
      final first = stripped.split('/').first;
      if (first.isNotEmpty) result.add(first);
    }
    return result.toList(growable: false);
  }

  bool get isInitialized => isInitializedAs(_name);

  void _log(Object? msg, {String field = '', String action = ''}) {
    if (!showLogs || kReleaseMode) return;
    var text = msg.toString();
    if (field.isNotEmpty) {
      text = '${action.isEmpty ? field : '$action($field)'}: $text';
    } else if (action.isNotEmpty) {
      text = '$action: $text';
    }
    log(text, name: 'IN_APP_DATABASE');
  }

  static InAppDatabase? _i;

  static InAppDatabase get i {
    final instance = _i;
    if (instance == null) {
      throw StateError('$InAppDatabase not initialized yet!');
    }
    return instance;
  }

  static InAppDatabase get I => i;

  static InAppDatabase get instance => i;

  static String _defaultName = '__in_app_database__';

  static InAppDatabaseVersion _defaultVersion = InAppDatabaseVersion.v1;

  static bool get isDefault => i._name == _defaultName;

  static bool get isDefaultVersion => i.versionCode == _defaultVersion.code;

  static final Map<String, bool> _databases = {};

  static List<String> get databases => List.unmodifiable(_databases.keys);

  static bool isInitializedAs(String name) => _databases[name] ?? false;

  InAppDatabase._({
    this.showLogs = false,
    required String name,
    InAppDatabaseType? type,
    InAppDatabaseVersion? version,
    required InAppDatabaseDelegate delegate,
  }) : _name = name,
       _type = type ?? InAppDatabaseType.json,
       _version = version ?? InAppDatabaseVersion.v1,
       _delegate = delegate;

  final ValueNotifier<bool> initializing = ValueNotifier(false);
  final ValueNotifier<bool> activating = ValueNotifier(false);
  final ValueNotifier<bool> creating = ValueNotifier(false);
  final ValueNotifier<bool> deleting = ValueNotifier(false);

  static Completer<bool>? _initCompleter;

  static Future<bool> init({
    String? name,
    bool showLogs = false,
    InAppDatabaseType? type,
    InAppDatabaseVersion? version,
    required InAppDatabaseDelegate delegate,
  }) async {
    if (_initCompleter != null) return _initCompleter!.future;
    final completer = Completer<bool>();
    _initCompleter = completer;
    try {
      _defaultName = name ?? _defaultName;
      _defaultVersion = version ?? _defaultVersion;
      _i = InAppDatabase._(
        name: _defaultName,
        type: type,
        version: _defaultVersion,
        showLogs: showLogs,
        delegate: delegate,
      );
      i.initializing.value = true;
      final initialized = await i._delegate.init(i._name);
      i.initializing.value = false;
      if (!initialized) {
        throw const InAppDatabaseException('Database not initialized.');
      }
      _databases[_defaultName] = true;
      i._log('$InAppDatabase initialized!');
      i.notifyListeners();
      completer.complete(true);
      return true;
    } catch (e) {
      _i?.initializing.value = false;
      _i?._log(e);
      if (!completer.isCompleted) completer.complete(false);
      _initCompleter = null;
      return false;
    }
  }

  static Future<bool> activate([String? name]) async {
    final inst = i;
    final target = name ?? _defaultName;
    try {
      if (!_databases.containsKey(target)) {
        throw InAppDatabaseException(
          '$InAppDatabase($target) not created yet.',
        );
      }
      if (!isInitializedAs(target)) {
        inst.activating.value = true;
        final created = await inst._delegate.init(target);
        inst.activating.value = false;
        if (!created) {
          throw InAppDatabaseException(
            '$InAppDatabase(${target == _defaultName ? "default" : target}) not activated.',
          );
        }
        _databases[target] = created;
      }
      inst._name = target;
      inst._log('activated: ${target == _defaultName ? "default" : target}');
      inst.notifyListeners();
      return true;
    } catch (e) {
      inst.activating.value = false;
      inst._log(e);
      rethrow;
    }
  }

  static bool version([InAppDatabaseVersion? version]) {
    final inst = i;
    try {
      if (!inst.isInitialized) {
        throw InAppDatabaseException(
          '$InAppDatabase(${inst.name}) not initialized.',
        );
      }
      inst._version = version ?? _defaultVersion;
      inst._log('version changed to ${inst._version.code}');
      inst.notifyListeners();
      return true;
    } catch (e) {
      inst._log(e);
      rethrow;
    }
  }

  static Future<bool> create(String name) async {
    final inst = i;
    try {
      if (_databases.containsKey(name)) {
        throw InAppDatabaseException('$InAppDatabase($name) already exists.');
      }
      inst.creating.value = true;
      final created = await inst._delegate.init(name);
      inst.creating.value = false;
      if (!created) {
        throw InAppDatabaseException('$InAppDatabase($name) not created.');
      }
      _databases[name] = created;
      inst._log('$InAppDatabase($name) created.');
      inst.notifyListeners();
      return true;
    } catch (e) {
      inst.creating.value = false;
      inst._log(e);
      rethrow;
    }
  }

  static Future<bool> delete(String name) async {
    final inst = i;
    try {
      if (!_databases.containsKey(name)) {
        throw const InAppDatabaseException('Database not found.');
      }
      if (name == 'default' || name == _defaultName) {
        throw const InAppDatabaseException(
          'The default database is protected and cannot be deleted.',
        );
      }
      if (name == inst._name) {
        throw const InAppDatabaseException(
          'Database is currently active. Deactivate it before deletion.',
        );
      }
      inst.deleting.value = true;
      final deleted = await inst._delegate.drop(name);
      inst.deleting.value = false;
      if (!deleted) {
        throw InAppDatabaseException('$InAppDatabase($name) not deleted.');
      }
      _databases.remove(name);
      inst._log('$InAppDatabase($name) deleted.');
      inst.notifyListeners();
      return true;
    } catch (e) {
      inst.deleting.value = false;
      inst._log(e);
      rethrow;
    }
  }

  Future<void> terminate() async => dispose();

  Future<void> clearPersistence() async {
    if (!isInitialized) return;
    final paths = await _delegate.paths(_name);
    for (final p in paths) {
      await _delegate.delete(_name, p);
    }
  }

  InAppWriteBatch batch() => InAppWriteBatch.of(this);

  Future<T> runTransaction<T>(
    InAppTransactionHandler<T> handler, {
    int maxAttempts = 5,
    Duration timeout = const Duration(seconds: 30),
  }) {
    return InAppTransaction.run<T>(
      this,
      handler,
      maxAttempts: maxAttempts,
      timeout: timeout,
    );
  }

  InAppQueryReference collection(String field) {
    if (field.isEmpty) {
      throw ArgumentError.value(
        field,
        'field',
        'Collection path cannot be empty.',
      );
    }
    if (field.contains('//')) {
      throw ArgumentError.value(
        field,
        'field',
        'Collection path cannot contain "//".',
      );
    }
    final pointer = InAppPointer(field);
    if (!pointer.isCollection()) {
      throw ArgumentError.value(
        field,
        'field',
        'Path must point to a collection.',
      );
    }
    final parts = pointer.components;
    if (parts.length == 1) {
      return InAppQueryReference(
        db: this,
        reference: _version._ref(field),
        path: field,
        id: field,
      );
    }
    InAppCollectionReference current = InAppQueryReference(
      db: this,
      reference: _version._ref(parts.first),
      path: parts.first,
      id: parts.first,
    );
    var i = 1;
    while (i < parts.length) {
      final docId = parts[i];
      final colId = parts[i + 1];
      current = current.doc(docId).collection(colId);
      i += 2;
    }
    return current as InAppQueryReference;
  }

  InAppQueryReference collectionGroup(String collectionId) {
    if (collectionId.isEmpty || collectionId.contains('/')) {
      throw ArgumentError.value(
        collectionId,
        'collectionId',
        'Collection group id must be non-empty and not contain "/".',
      );
    }
    return collection(collectionId);
  }

  InAppDocumentReference doc(String documentPath) {
    if (documentPath.isEmpty) {
      throw ArgumentError.value(
        documentPath,
        'documentPath',
        'must be non-empty.',
      );
    }
    if (documentPath.contains('//')) {
      throw ArgumentError.value(
        documentPath,
        'documentPath',
        'cannot contain "//".',
      );
    }
    final pointer = InAppPointer(documentPath);
    if (!pointer.isDocument()) {
      throw ArgumentError.value(
        documentPath,
        'documentPath',
        'must point to a valid document (even number of segments).',
      );
    }
    final parts = pointer.components;
    InAppReference ref = collection(parts.first);
    for (var i = 1; i < parts.length; i++) {
      final seg = parts[i];
      if (ref is InAppCollectionReference) {
        ref = ref.doc(seg);
      } else if (ref is InAppDocumentReference) {
        ref = ref.collection(seg);
      }
    }
    return ref as InAppDocumentReference;
  }

  InAppQueryNotifier _addNotifier(
    String reference, [
    InAppQuerySnapshot? value,
  ]) {
    final existing = _notifiers[reference];
    if (existing is InAppQueryNotifier && !existing.isDisposed) {
      if (value != null) existing.value = value;
      return existing;
    }
    final created = InAppQueryNotifier(value);
    _notifiers[reference] = created;
    return created;
  }

  InAppDocumentNotifier _addChildNotifier(
    String reference,
    String id, [
    InAppDocumentSnapshot? value,
  ]) {
    return _addNotifier(reference).set(id, value);
  }

  static const Duration _retryDelay = Duration(milliseconds: 250);
  static const int _maxRetries = 3;

  Future<T> _execute<T>(
    Future<T> Function() callback, [
    int attempt = 0,
  ]) async {
    if (_disposed) {
      throw const InAppDatabaseException('Database has been disposed.');
    }
    if (!isInitialized) {
      throw InAppDatabaseException('$InAppDatabase($name) not initialized.');
    }
    try {
      return await callback();
    } catch (e) {
      if (attempt >= _maxRetries) rethrow;
      await Future<void>.delayed(_retryDelay * (attempt + 1));
      return _execute(callback, attempt + 1);
    }
  }

  Future<bool> _delete(
    String collectionPath, {
    bool related = true,
    Iterable<String> Function(String path, Iterable<String>)? filter,
  }) async {
    final ref = _version._ref(collectionPath);
    try {
      return await _execute(() async {
        if (!related) return _delegate.delete(_name, ref);
        final paths = await _delegate.paths(_name);
        final keys =
            filter != null
                ? filter(ref, paths)
                : paths.where((p) => p.startsWith(ref));
        var any = false;
        for (final k in keys) {
          if (await _delegate.delete(_name, k)) any = true;
        }
        return any || filter != null;
      });
    } catch (e) {
      _log(e, action: 'delete', field: collectionPath);
      return false;
    }
  }

  Future<Iterable<String>> _k(String path) async {
    try {
      return await _execute(() async {
        final paths = await _delegate.paths(_name);
        final r = _version._ref(path);
        return paths.where((p) => p.startsWith(r)).toList(growable: false);
      });
    } catch (e) {
      _log(e, action: 'keys', field: path);
      return const <String>[];
    }
  }

  Future<InAppSnapshot> _r({
    required InAppReadType type,
    required String reference,
    required String collectionPath,
    required String collectionId,
    required String documentId,
  }) async {
    try {
      return await _execute(() async {
        final ref = _version._ref(collectionPath);
        final raw = await _delegate.read(_name, ref);
        final value = raw is String ? jsonDecode(raw) : raw;
        if (value is! Map) {
          return const InAppFailureSnapshot('Data not found.');
        }
        if (type.isCollection) {
          final docs = <InAppQueryDocumentSnapshot>[];
          value.forEach((k, v) {
            if (k is! String) return;
            final parsed = v is String ? jsonDecode(v) : v;
            if (parsed is! Map) return;
            final doc = Map<String, InAppValue>.from(parsed);
            if (doc.isEmpty) return;
            docs.add(InAppQueryDocumentSnapshot(k, doc));
          });
          return InAppQuerySnapshot(collectionId, docs);
        } else if (type.isDocument) {
          final entry = value[documentId];
          if (entry == null) return InAppDocumentSnapshot(documentId);
          final parsed = entry is String ? jsonDecode(entry) : entry;
          final doc =
              parsed is Map ? Map<String, InAppValue>.from(parsed) : null;
          return InAppDocumentSnapshot(documentId, doc);
        }
        return const InAppErrorSnapshot('Unsupported read type.');
      });
    } catch (e) {
      _log(e, action: 'read', field: collectionPath);
      return InAppFailureSnapshot(e.toString());
    }
  }

  Future<Object?> _wb(
    String path,
    Map<String, Object?> base,
    bool isJson,
  ) async {
    if (base.isEmpty) return null;
    final l = await _delegate.limitation(_name, PathModifier.format(path));
    if (l == null || l.isUnlimited) {
      return isJson ? jsonEncode(base) : base;
    }
    final entries = base.entries;
    if (entries.length <= l.limit) return isJson ? jsonEncode(base) : base;
    final selected =
        l.limitByRecent
            ? entries.toList(growable: false).reversed.take(l.limit)
            : entries.take(l.limit);
    final reduced = Map<String, Object?>.fromEntries(selected);
    return isJson ? jsonEncode(reduced) : reduced;
  }

  Future<bool> _w({
    required InAppWriteType type,
    required String reference,
    required String collectionPath,
    required String collectionId,
    required String documentId,
    InAppDocument? value,
  }) async {
    final isJson = _type == InAppDatabaseType.json;
    try {
      return await _execute(() async {
        final ref = _version._ref(collectionPath);
        final root = await _delegate.read(_name, ref);
        final raw = root is String ? jsonDecode(root) : root;
        final base =
            raw is Map ? Map<String, Object?>.from(raw) : <String, Object?>{};

        if (type.isDocument) {
          if (value != null && value.isNotEmpty) {
            final cleaned = <String, Object?>{};
            value.forEach((k, v) {
              if (v != null) cleaned[k] = v;
            });
            base[documentId] = isJson ? jsonEncode(cleaned) : cleaned;
          } else {
            base.remove(documentId);
          }
        } else if (type.isCollection) {
          if (value != null) {
            value.forEach((k, v) {
              if (v == null) {
                base.remove(k);
              } else {
                base[k] = isJson ? jsonEncode(v) : v;
              }
            });
          } else {
            base.clear();
          }
        }

        final payload = await _wb(collectionPath, base, isJson);
        return _delegate.write(_name, ref, payload);
      });
    } catch (e) {
      _log(e, action: 'write', field: collectionPath);
      return false;
    }
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    for (final n in _notifiers.values) {
      n.dispose();
    }
    _notifiers.clear();
    initializing.dispose();
    activating.dispose();
    creating.dispose();
    deleting.dispose();
    _databases.clear();
    _initCompleter = null;
    _i = null;
    _log('disposed!');
    super.dispose();
  }
}
