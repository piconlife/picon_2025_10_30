import 'package:flutter_entity/entity.dart';

class CountableResponse<T extends Entity> extends Response<T> {
  final int count;
  final List<T> resultByMe;

  bool get isExistByMe => resultByMe.isNotEmpty;

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
  }) : resultByMe = resultByMe ?? [];

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
    );
  }
}
