import 'package:flutter_entity/entity.dart';

class NoteKey extends EntityKey {
  final String title = 'title';
  final String body = 'body';
  final String tags = 'tags';
  final String pinned = 'pinned';
  final String color = 'color';

  static NoteKey? _i;

  static NoteKey get i => _i ??= NoteKey();

  @override
  Iterable<String> get keys => [
    id,
    timeMills,
    title,
    body,
    tags,
    pinned,
    color,
  ];
}

class Note extends Entity<NoteKey> {
  final String title;
  final String body;
  final List<String> tags;
  final bool pinned;
  final String color;

  Note({
    required super.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.pinned,
    required this.color,
  }) : super.auto();

  @override
  NoteKey makeKey() => NoteKey();

  factory Note.from(dynamic source) {
    final map = source is Map<String, dynamic> ? source : <String, dynamic>{};
    final key = NoteKey.i;
    return Note(
      id: map[key.id] ?? '',
      title: map[key.title] ?? '',
      body: map[key.body] ?? '',
      tags: List<String>.from(map[key.tags] ?? []),
      pinned: map[key.pinned] ?? false,
      color: map[key.color] ?? '',
    );
  }

  @override
  Map<String, dynamic> get source => {
    key.id: id,
    key.title: title,
    key.body: body,
    key.tags: tags,
    key.pinned: pinned,
    key.color: color,
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
    );
  }
}
