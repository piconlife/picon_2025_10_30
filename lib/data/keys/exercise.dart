import 'package:flutter_entity/entity.dart';

class ExerciseKeys extends EntityKey {
  final name = "name";
  final description = "description";
  final durationInSec = "duration";
  final repetitions = "repetitions";
  final restTimeInSeconds = "restTimeInSeconds";
  final preferredShift = "preferredShift";
  final preview = "preview";
  final feedbacks = "feedbacks";
  final thumbnail = "thumbnail";
  final type = "type";

  const ExerciseKeys._() : super(id: "id", timeMills: "timeMills");

  static ExerciseKeys? _i;

  static ExerciseKeys get i => _i ??= ExerciseKeys._();
}
