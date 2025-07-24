import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_database/core/field_value.dart';

import '../../../../data/entities/exercise.dart';
import '../../../../data/models/plan.dart';
import '../../../../data/use_cases/timeline/get.dart';
import '../../../../data/use_cases/timeline/update.dart';

class DailyPlanCubitState extends Equatable {
  final bool initial;
  final bool loading;
  final DateTime timeline;
  final DailyPlan plan;

  const DailyPlanCubitState({
    required this.timeline,
    required this.plan,
    required this.initial,
    required this.loading,
  });

  DailyPlanCubitState.empty()
    : this(
        timeline: DateTime.now(),
        plan: DailyPlan.empty(),
        initial: true,
        loading: false,
      );

  DailyPlanCubitState copyWith({
    DateTime? timeline,
    DailyPlan? plan,
    bool? initial,
    bool? loading,
  }) {
    return DailyPlanCubitState(
      initial: initial ?? this.initial,
      loading: loading ?? this.loading,
      timeline: timeline ?? this.timeline,
      plan: plan ?? this.plan,
    );
  }

  @override
  List<Object?> get props => [timeline, plan];
}

class DailyPlanCubit extends Cubit<DailyPlanCubitState> {
  DailyPlanCubit() : super(DailyPlanCubitState.empty()) {
    load(DateTime.now());
  }

  Future<void> load([DateTime? timeline]) {
    emit(state.copyWith(loading: true));
    return GetTimelineUseCase.i(timeline).then((value) {
      emit(
        state.copyWith(
          plan: value,
          timeline: timeline,
          initial: false,
          loading: false,
        ),
      );
    });
  }

  Future<void> markAsComplete(Exercise value) {
    final id = value.idWithShift;
    final timeMills = Entity.generateTimeMills;
    emit(
      state.copyWith(
        plan: state.plan.copy(
          timeMills: timeMills,
          completes: state.plan.completes..add(id),
        ),
      ),
    );
    return UpdateTimelineUseCase.i(
      data: {
        "time_mills": timeMills,
        "completes": InAppFieldValue.arrayUnion([id]),
      },
    );
  }

  Future<void> markAsFinish() {
    final ids = state.plan.docs;
    final timeMills = Entity.generateTimeMills;
    emit(
      state.copyWith(
        plan: state.plan.copy(timeMills: timeMills, completes: ids),
      ),
    );
    return UpdateTimelineUseCase.i(
      data: {"time_mills": timeMills, "completes": ids},
    );
  }
}
