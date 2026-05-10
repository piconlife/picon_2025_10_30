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

  factory Note.fromMap(InAppDocument map) {
    return Note(
      id: (map[NoteKey.id] ?? '') as String,
      title: (map[NoteKey.title] ?? '') as String,
      body: (map[NoteKey.body] ?? '') as String,
      tags: (map[NoteKey.tags] as List?)?.cast<String>() ?? const [],
      pinned: (map[NoteKey.pinned] ?? false) as bool,
      color: (map[NoteKey.color] ?? 'white') as String,
      views: (map[NoteKey.views] ?? 0) as int,
      createdAt: map[NoteKey.createdAt] as int?,
      updatedAt: map[NoteKey.updatedAt] as int?,
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
