import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_entity/entity.dart';

import '../entities/exercise.dart';
import '../enums/shift.dart';

class DailyPlan extends Entity implements Equatable {
  final List<String> docs;
  final List<String> completes;

  bool get isEmpty => id.isEmpty || docs.isEmpty;

  bool get isFinish => completes.length == docs.length;

  double get progress {
    final x = completes.toSet().length / docs.length;
    return x.isNaN ? 0 : x;
  }

  bool isExercised(String id) => completes.contains(id);

  bool isCompleted(Shift shift) => incomplete(shift).isEmpty;

  List<Exercise> total(Shift shift) {
    return docs
        .map(Exercise.fromIdWithShift)
        .where((e) => e.preferredShift == shift)
        .toList();
  }

  List<Exercise> complete(Shift shift) {
    return total(shift).where((e) {
      return completes.contains(e.idWithShift);
    }).toList();
  }

  List<Exercise> incomplete(Shift shift) {
    final x = total(shift);
    return x.where((e) {
      return !completes.contains(e.idWithShift);
    }).toList();
  }

  Duration incompleteDuration(Shift shift) {
    return incomplete(shift).fold(Duration.zero, (previousValue, element) {
      return previousValue + element.totalDuration;
    });
  }

  const DailyPlan({
    super.id,
    super.timeMills,
    required this.docs,
    required this.completes,
  });

  DailyPlan.empty() : this(docs: [], completes: []);

  factory DailyPlan.parse(Object? source) {
    if (source is String) source = jsonDecode(source);
    if (source is! Map) return DailyPlan.empty();
    final id = source['id'];
    final timeMills = source['time_mills'];
    final completes = source['completes'];
    final docs = source['docs'];
    return DailyPlan(
      id: id is String ? id : null,
      timeMills: timeMills is num ? timeMills.toInt() : null,
      completes: completes is List
          ? completes.map((e) => e.toString()).toList()
          : [],
      docs: docs is List ? docs.map((e) => e.toString()).toList() : [],
    );
  }

  DailyPlan copy({
    String? id,
    int? timeMills,
    List<String>? docs,
    List<String>? completes,
  }) {
    return DailyPlan(
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      docs: docs ?? this.docs,
      completes: completes ?? this.completes,
    );
  }

  @override
  Map<String, dynamic> get source {
    if (isEmpty) return {};
    return {
      "id": id,
      "time_mills": timeMills,
      "completes": completes,
      "docs": docs,
    };
  }

  @override
  int get hashCode {
    return id.hashCode ^
        timeMills.hashCode ^
        completes.hashCode ^
        docs.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return other is DailyPlan &&
        other.id == id &&
        other.timeMills == timeMills &&
        other.completes == completes &&
        other.docs == docs;
  }

  @override
  String toString() {
    return "$DailyPlan(id: $id, time_mills: $timeMills, completes: $completes, docs: $docs)";
  }

  @override
  List<Object?> get props => [id, timeMills, completes, docs];

  @override
  bool? get stringify => false;
}
