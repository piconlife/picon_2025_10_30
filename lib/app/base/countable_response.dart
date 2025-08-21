import 'package:flutter_entity/entity.dart';

class CountableResponse<T extends Object> extends Response<T> {
  final int count;
  final List<String> selections;
  final List<T> resultByMe;

  bool get isExistByMe => resultByMe.isNotEmpty;

  bool isExist(String id) => selections.contains(id);

  T? elementOf(bool Function(T) test, [int? index]) {
    try {
      if (index == null) return result.firstWhere(test);
      return result[index];
    } catch (_) {
      return null;
    }
  }

  CountableResponse({
    super.requestCode,
    super.data,
    super.backups,
    super.ignores,
    super.result,
    super.progress,
    super.status,
    super.error,
    super.message,
    super.feedback,
    super.snapshot,
    this.count = 0,
    List<T>? resultByMe,
    List<String>? selections,
  }) : resultByMe = resultByMe ?? [],
       selections = selections ?? [];

  factory CountableResponse.from(
    Response<T> response,
    String Function(T) test,
  ) {
    return CountableResponse(
      requestCode: response.requestCode,
      data: response.data,
      backups: response.backups,
      ignores: response.ignores,
      result: response.result,
      progress: response.progress,
      status: response.status,
      error: response.error,
      message: response.message,
      feedback: response.feedback,
      snapshot: response.snapshot,
      selections: response.result.map(test).toList(),
    );
  }

  static CountableResponse<E> convert<E extends Object, T extends Object>(
    Response<T> response,
    E Function(T) converter,
  ) {
    return CountableResponse<E>(
      requestCode: response.requestCode,
      data: response.data != null ? converter(response.data!) : null,
      backups: response.backups.map(converter).toList(),
      ignores: response.ignores.map(converter).toList(),
      result: response.result.map(converter).toList(),
      progress: response.progress,
      status: response.status,
      error: response.error,
      message: response.message,
      feedback: response.feedback,
      snapshot: response.snapshot,
    );
  }

  @override
  CountableResponse<T> copy({
    int? requestCode,
    T? data,
    List<T>? backups,
    List<T>? ignores,
    List<T>? result,
    double? progress,
    Status? status,
    String? exception,
    String? message,
    feedback,
    snapshot,
    int? count,
    List<T>? resultByMe,
    List<String>? selections,
  }) {
    return CountableResponse(
      requestCode: requestCode ?? this.requestCode,
      data: data ?? this.data,
      backups: backups ?? this.backups,
      ignores: ignores ?? this.ignores,
      result: result ?? this.result,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      error: exception ?? error,
      message: message ?? this.message,
      feedback: feedback ?? this.feedback,
      snapshot: snapshot ?? this.snapshot,
      count: count ?? this.count,
      resultByMe: resultByMe ?? this.resultByMe,
      selections: selections ?? this.selections,
    );
  }
}
