part of 'database.dart';

abstract class InAppSnapshot {
  const InAppSnapshot();
}

class InAppQuerySnapshot extends InAppSnapshot {
  final String id;
  final List<InAppDocumentSnapshot> docs;
  final List<InAppDocumentChangeSnapshot> docChanges;

  const InAppQuerySnapshot(
    this.id, [
    this.docs = const [],
    this.docChanges = const [],
  ]);

  bool get exists => docs.isNotEmpty;

  int get size => docs.length;

  bool get isEmpty => docs.isEmpty;

  bool get isNotEmpty => docs.isNotEmpty;

  InAppDocument get rootDocs {
    final result = <String, InAppValue>{};
    for (final d in docs) {
      result[d.id] = d.data;
    }
    return result;
  }

  InAppDocument get rootDocChanges {
    final result = <String, InAppValue>{};
    for (final c in docChanges) {
      result[c.doc.id] = c.doc.data;
    }
    return result;
  }

  InAppDocumentSnapshot? doc(String id) {
    for (final d in docs) {
      if (d.id == id) return d;
    }
    return null;
  }

  @override
  int get hashCode =>
      Object.hash(id, Object.hashAll(docs), Object.hashAll(docChanges));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! InAppQuerySnapshot) return false;
    if (other.id != id) return false;
    if (other.docs.length != docs.length) return false;
    if (other.docChanges.length != docChanges.length) return false;
    for (var i = 0; i < docs.length; i++) {
      if (other.docs[i] != docs[i]) return false;
    }
    for (var i = 0; i < docChanges.length; i++) {
      if (other.docChanges[i] != docChanges[i]) return false;
    }
    return true;
  }

  @override
  String toString() =>
      'InAppQuerySnapshot(id: $id, size: $size, changes: ${docChanges.length})';
}

class InAppCounterSnapshot extends InAppSnapshot {
  final String id;
  final int count;
  final InAppQuerySnapshot query;

  const InAppCounterSnapshot(this.id, this.query, [this.count = 0]);

  bool get exists => query.exists;

  @override
  int get hashCode => Object.hash(id, count, query);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InAppCounterSnapshot &&
          other.id == id &&
          other.count == count &&
          other.query == query;

  @override
  String toString() => 'InAppCounterSnapshot(id: $id, count: $count)';
}

class InAppDocumentChangeSnapshot extends InAppSnapshot {
  final InAppDocumentSnapshot doc;

  const InAppDocumentChangeSnapshot({required this.doc});

  @override
  int get hashCode => doc.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InAppDocumentChangeSnapshot && other.doc == doc;

  @override
  String toString() => 'InAppDocumentChangeSnapshot(doc: $doc)';
}

class InAppDocumentSnapshot extends InAppSnapshot {
  final String id;
  final InAppDocument? _doc;

  const InAppDocumentSnapshot(this.id, [this._doc]);

  InAppDocument? get data => _doc;

  bool get exists => _doc != null && _doc.isNotEmpty;

  T? field<T>(String key) {
    final v = _doc?[key];
    return v is T ? v : null;
  }

  InAppDocumentSnapshot copy({String? id, InAppDocument? doc}) {
    return InAppDocumentSnapshot(id ?? this.id, doc ?? _doc);
  }

  @override
  int get hashCode => Object.hash(id, _doc == null ? 0 : _doc.length);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! InAppDocumentSnapshot) return false;
    if (other.id != id) return false;
    final a = _doc;
    final b = other._doc;
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (!b.containsKey(entry.key)) return false;
      if (b[entry.key] != entry.value) return false;
    }
    return true;
  }

  @override
  String toString() => 'InAppDocumentSnapshot(id: $id, exists: $exists)';
}

class InAppFailureSnapshot extends InAppSnapshot {
  final String message;

  const InAppFailureSnapshot(this.message);

  @override
  int get hashCode => message.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InAppFailureSnapshot && other.message == message;

  @override
  String toString() => 'InAppFailureSnapshot(message: $message)';
}

class InAppErrorSnapshot extends InAppFailureSnapshot {
  const InAppErrorSnapshot(super.message);

  @override
  String toString() => 'InAppErrorSnapshot(message: $message)';
}
