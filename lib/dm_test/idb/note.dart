import '../../ldb/src/database.dart' show InAppDocument, InAppDocumentSnapshot;

class NoteKey {
  static const id = 'id';
  static const title = 'title';
  static const body = 'body';
  static const tags = 'tags';
  static const pinned = 'pinned';
  static const color = 'color';
  static const createdAt = 'createdAt';
  static const updatedAt = 'updatedAt';
  static const views = 'views';
}

class Note {
  final String id;
  final String title;
  final String body;
  final List<String> tags;
  final bool pinned;
  final String color;
  final int views;
  final int? createdAt;
  final int? updatedAt;

  const Note({
    required this.id,
    required this.title,
    required this.body,
    this.tags = const [],
    this.pinned = false,
    this.color = 'white',
    this.views = 0,
    this.createdAt,
    this.updatedAt,
  });

  static String _asString(Object? v, [String fallback = '']) {
    if (v == null) return fallback;
    if (v is String) return v;
    return v.toString();
  }

  static bool _asBool(Object? v, [bool fallback = false]) {
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) {
      final s = v.toLowerCase();
      if (s == 'true' || s == '1') return true;
      if (s == 'false' || s == '0') return false;
    }
    return fallback;
  }

  static int _asInt(Object? v, [int fallback = 0]) {
    if (v == null) return fallback;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) {
      final n = int.tryParse(v);
      if (n != null) return n;
      final d = double.tryParse(v);
      if (d != null) return d.toInt();
      final t = DateTime.tryParse(v);
      if (t != null) return t.toUtc().millisecondsSinceEpoch;
    }
    if (v is DateTime) return v.toUtc().millisecondsSinceEpoch;
    return fallback;
  }

  static int? _asIntOrNull(Object? v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) {
      final n = int.tryParse(v);
      if (n != null) return n;
      final d = double.tryParse(v);
      if (d != null) return d.toInt();
      final t = DateTime.tryParse(v);
      if (t != null) return t.toUtc().millisecondsSinceEpoch;
    }
    if (v is DateTime) return v.toUtc().millisecondsSinceEpoch;
    return null;
  }

  static List<String> _asStringList(Object? v) {
    if (v is List) {
      return v
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList(growable: false);
    }
    if (v is String && v.isNotEmpty) {
      return v
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(growable: false);
    }
    return const [];
  }

  factory Note.fromMap(InAppDocument map) {
    return Note(
      id: _asString(map[NoteKey.id]),
      title: _asString(map[NoteKey.title]),
      body: _asString(map[NoteKey.body]),
      tags: _asStringList(map[NoteKey.tags]),
      pinned: _asBool(map[NoteKey.pinned]),
      color: _asString(map[NoteKey.color], 'white'),
      views: _asInt(map[NoteKey.views]),
      createdAt: _asIntOrNull(map[NoteKey.createdAt]),
      updatedAt: _asIntOrNull(map[NoteKey.updatedAt]),
    );
  }

  factory Note.fromSnapshot(InAppDocumentSnapshot snap) {
    final data = snap.data();
    if (data == null) return Note.empty(snap.id);
    return Note.fromMap({...data, NoteKey.id: snap.id});
  }

  factory Note.empty(String id) =>
      Note(id: id, title: '', body: '', color: 'white');

  InAppDocument toMap() => {
    NoteKey.id: id,
    NoteKey.title: title,
    NoteKey.body: body,
    NoteKey.tags: tags,
    NoteKey.pinned: pinned,
    NoteKey.color: color,
    NoteKey.views: views,
    if (createdAt != null) NoteKey.createdAt: createdAt,
    if (updatedAt != null) NoteKey.updatedAt: updatedAt,
  };

  Note copyWith({
    String? title,
    String? body,
    List<String>? tags,
    bool? pinned,
    String? color,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      tags: tags ?? this.tags,
      pinned: pinned ?? this.pinned,
      color: color ?? this.color,
      views: views,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
