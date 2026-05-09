part of 'database.dart';

class _InAppNotifier<T> extends ValueNotifier<T> {
  _InAppNotifier(super.data);

  bool _disposed = false;

  bool get isDisposed => _disposed;

  void notify() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    super.dispose();
  }
}

class InAppQueryNotifier extends _InAppNotifier<InAppQuerySnapshot?> {
  final Map<String, InAppDocumentNotifier> children = {};

  InAppQueryNotifier(super.data);

  InAppDocumentNotifier set(String id, [InAppDocumentSnapshot? value]) {
    final existing = children[id];
    if (existing != null && !existing.isDisposed) {
      if (value != null) existing.value = value;
      return existing;
    }
    final created = InAppDocumentNotifier(value, id);
    children[id] = created;
    return created;
  }

  @override
  set value(InAppQuerySnapshot? value) {
    if (_disposed) return;
    if (value == null) {
      super.value = null;
      return;
    }
    final id = value.id;
    final filtered = <InAppDocumentSnapshot>[];
    for (final d in value.docs) {
      final data = d.data;
      if (data != null && data.isNotEmpty) filtered.add(d);
    }
    if (id.isNotEmpty && filtered.isNotEmpty) {
      super.value = InAppQuerySnapshot(id, filtered);
    } else {
      super.value = null;
    }
  }

  @override
  void dispose() {
    for (final child in children.values) {
      child.dispose();
    }
    children.clear();
    super.dispose();
  }

  @override
  String toString() => 'InAppQueryNotifier(${value?.id})';
}

class InAppDocumentNotifier extends _InAppNotifier<InAppDocumentSnapshot?> {
  final String id;

  InAppDocumentNotifier(super.data, this.id);

  @override
  set value(InAppDocumentSnapshot? value) {
    if (_disposed) return;
    if (value == null) {
      super.value = null;
      return;
    }
    final vId = value.id;
    final data = value.data;
    if (vId.isNotEmpty && data != null && data.isNotEmpty) {
      super.value = InAppDocumentSnapshot(vId, data);
    } else {
      super.value = null;
    }
  }

  @override
  String toString() => 'InAppDocumentNotifier($id)';
}
