import 'dart:convert';

import 'package:flutter_andomie/extensions/int.dart';
import 'package:flutter_andomie/extensions/object.dart';
import 'package:flutter_entity/entity.dart';

import '../enums/shift.dart';
import '../keys/exercise.dart';
import '../services/manager.dart';

enum ExerciseType {
  lottie,
  video,
  none;

  bool get isLottie => this == lottie;

  bool get isVideo => this == video;

  factory ExerciseType.parse(Object? source) {
    return values.where((e) {
          if (e == source) return true;
          if (e.toString().toLowerCase() == source.toString().toLowerCase()) {
            return true;
          }
          if (e.name == source.toString().toLowerCase()) return true;
          return false;
        }).firstOrNull ??
        ExerciseType.video;
  }
}

class Exercise extends Entity<ExerciseKeys> {
  final String? _name;
  final String? _description;
  final int? _durationInSec;
  final int? _repetitions;
  final int? _restTimeInSeconds;
  final Shift? _preferredShift;
  final String? _preview;
  final String? _thumbnail;
  final Map<double, int>? _feedbacks;
  final ExerciseType? _type;

  bool get isEmpty => id.isEmpty;

  String get idWithShift => "${preferredShift.name}:$id";

  String? get nameOrNull => _name;

  String get name => nameOrNull ?? "Exercise";

  String? get descriptionOrNull => _description;

  String get description => descriptionOrNull ?? "";

  int get durationInSec => _durationInSec ?? 0;

  Duration get duration => Duration(seconds: durationInSec);

  Duration? get durationOrNull {
    return durationInSec > 0 ? Duration(seconds: durationInSec) : null;
  }

  int get totalDurationInSec {
    return durationInSec.use * repetitions.use + restTimeInSeconds;
  }

  Duration get totalDuration => Duration(seconds: totalDurationInSec);

  Shift get preferredShift => _preferredShift ?? Shift.any;

  int get repetitions => _repetitions ?? 1;

  int get restTimeInSeconds => _restTimeInSeconds ?? 5;

  Duration get restTime => Duration(seconds: restTimeInSeconds);

  String get preview => _preview ?? '';

  String? get thumbnailOrNull => _thumbnail;

  String get thumbnail => thumbnailOrNull ?? '';

  Map<double, int> get feedbacks => _feedbacks ?? {};

  ExerciseType get type {
    if (preview.isEmpty) return ExerciseType.none;
    return _type ?? ExerciseType.none;
  }

  Exercise({
    super.id,
    super.timeMills,
    String? name,
    String? description,
    int? durationInSec,
    int? repetitions,
    int? restTimeInSeconds,
    Shift? preferredShift,
    String? preview,
    String? thumbnail,
    Map<double, int>? feedbacks,
    ExerciseType? type,
  }) : _name = name,
       _description = description,
       _durationInSec = durationInSec,
       _repetitions = repetitions,
       _restTimeInSeconds = restTimeInSeconds,
       _preferredShift = preferredShift,
       _preview = preview,
       _thumbnail = thumbnail,
       _feedbacks = feedbacks,
       _type = type;

  Exercise.empty() : this(type: ExerciseType.video);

  factory Exercise.fromId(Object? id) {
    if (id is! String) return Exercise.parse(id);
    return ExerciseManager.i.getExerciseById(id);
  }

  factory Exercise.fromIdWithShift(Object? id) {
    if (id is! String) return Exercise.parse(id);
    final parts = id.split(":");
    if (parts.length != 2) return Exercise.empty();
    final shift = Shift.parse(parts[0]);
    final parsedId = parts[1];
    return ExerciseManager.i
        .getExerciseById(parsedId)
        .copy(preferredShift: shift);
  }

  factory Exercise.parse(Object? source) {
    if (source is String) source = jsonDecode(source);
    if (source is! Map) return Exercise.empty();
    final key = ExerciseKeys.i;
    final id = source[key.id];
    final timeMills = source[key.timeMills];
    final name = source[key.name];
    final description = source[key.description];
    final feedbacks = source[key.feedbacks];
    final durationInSec = source[key.durationInSec];
    final repetitions = source[key.repetitions];
    final restTimeInSeconds = source[key.restTimeInSeconds];
    final preferredShift = source[key.preferredShift];
    final preview = source[key.preview];
    final thumbnail = source[key.thumbnail];
    final type = source[key.type];
    return Exercise(
      id: id is String ? id : null,
      timeMills: timeMills is num ? timeMills.toInt() : null,
      name: name is String ? name : null,
      description: description is String ? description : null,
      durationInSec: durationInSec is num ? durationInSec.toInt() : null,
      repetitions: repetitions is num ? repetitions.toInt() : null,
      restTimeInSeconds: restTimeInSeconds is num
          ? restTimeInSeconds.toInt()
          : null,
      preferredShift: Shift.parse(preferredShift),
      preview: preview is String ? preview : null,
      feedbacks: feedbacks is Map
          ? Map.fromEntries(
              feedbacks.entries.map((e) {
                Object? k = e.key;
                if (k is String) {
                  k = double.tryParse(k);
                } else if (k is num) {
                  k = k.toDouble();
                }
                if (k is! double) {
                  return null;
                }
                final v = e.value;
                if (v is! num) return null;
                return MapEntry(k, v.toInt());
              }).whereType<MapEntry<double, int>>(),
            )
          : null,
      thumbnail: thumbnail is String ? thumbnail : null,
      type: ExerciseType.parse(type),
    );
  }

  Exercise copy({
    String? id,
    int? timeMills,
    String? name,
    String? description,
    int? durationInSec,
    int? repetitions,
    int? restTimeInSeconds,
    Shift? preferredShift,
    String? preview,
    Map<double, int>? feedbacks,
    String? thumbnail,
    ExerciseType? type,
  }) {
    return Exercise(
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      name: name ?? _name,
      description: description ?? _description,
      durationInSec: durationInSec ?? _durationInSec,
      repetitions: repetitions ?? _repetitions,
      restTimeInSeconds: restTimeInSeconds ?? _restTimeInSeconds,
      preferredShift: preferredShift ?? _preferredShift,
      preview: preview ?? _preview,
      feedbacks: feedbacks ?? _feedbacks,
      thumbnail: thumbnail ?? _thumbnail,
      type: type ?? _type,
    );
  }

  Exercise localize(Object? source) {
    if (source is String) source = jsonDecode(source);
    if (source is! Map || source.isEmpty) return this;
    return copy(
      name: source.getOrNull(key.name, _name),
      description: source.getOrNull(key.description, _description),
    );
  }

  @override
  ExerciseKeys makeKey() => ExerciseKeys.i;

  @override
  bool isInsertable(String key, value) => value != null;

  @override
  Map<String, dynamic> get source {
    if (isEmpty) return {};
    return {
      key.id: id,
      key.timeMills: timeMills,
      key.name: _name,
      key.description: _description,
      key.durationInSec: _durationInSec,
      key.repetitions: _repetitions,
      key.restTimeInSeconds: _restTimeInSeconds,
      key.preferredShift: _preferredShift?.source,
      key.preview: _preview,
      key.feedbacks: _feedbacks,
      key.thumbnail: _thumbnail,
      key.type: _type?.name,
    };
  }

  @override
  int get hashCode =>
      id.hashCode ^
      timeMills.hashCode ^
      _name.hashCode ^
      _description.hashCode ^
      _durationInSec.hashCode ^
      _repetitions.hashCode ^
      _restTimeInSeconds.hashCode ^
      _preferredShift.hashCode ^
      _preview.hashCode ^
      _feedbacks.hashCode ^
      _thumbnail.hashCode ^
      _type.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Exercise &&
        other.id == id &&
        other.timeMills == timeMills &&
        other._name == _name &&
        other._description == _description &&
        other._durationInSec == _durationInSec &&
        other._repetitions == _repetitions &&
        other._restTimeInSeconds == _restTimeInSeconds &&
        other._preferredShift == _preferredShift &&
        other._preview == _preview &&
        other._feedbacks == _feedbacks &&
        other._thumbnail == _thumbnail &&
        other._type == _type;
  }

  @override
  String toString() => "$Exercise#$id(${type.name})";
}
