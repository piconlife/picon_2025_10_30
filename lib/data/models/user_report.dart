import 'package:flutter_entity/entity.dart';

class ReportKeys {
  const ReportKeys._();

  static const id = "id";
  static const timeMills = "time_mills";
  static const reporter = "reporter";
  static const publisher = "publisher";
  static const path = "path";
  static const parentId = "parent_id";
  static const parentPath = "parent_path";
  static const feedback = "feedback";
  static const category = "category";
}

class UserReport extends Entity {
  final String? reporter;
  final String? publisher;
  final String? path;
  final String? parentId;
  final String? parentPath;
  final String? feedback;
  final String? category;

  UserReport({
    super.id,
    super.timeMills,
    this.reporter,
    this.publisher,
    this.path,
    this.parentId,
    this.parentPath,
    this.feedback,
    this.category,
  });

  factory UserReport.from(Object? source) {
    return UserReport(
      id: source.entityValue(ReportKeys.id),
      timeMills: source.entityValue(ReportKeys.timeMills),
      reporter: source.entityValue(ReportKeys.reporter),
      publisher: source.entityValue(ReportKeys.publisher),
      path: source.entityValue(ReportKeys.path),
      parentId: source.entityValue(ReportKeys.parentId),
      parentPath: source.entityValue(ReportKeys.parentPath),
      feedback: source.entityValue(ReportKeys.feedback),
      category: source.entityValue(ReportKeys.category),
    );
  }

  UserReport copy({
    String? id,
    int? timeMills,
    String? reporter,
    String? publisher,
    String? path,
    String? parentId,
    String? parentPath,
    String? feedback,
    String? category,
  }) {
    return UserReport(
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      reporter: reporter ?? this.reporter,
      publisher: publisher ?? this.publisher,
      path: path ?? this.path,
      parentPath: parentPath ?? this.parentPath,
      parentId: parentId ?? this.parentId,
      feedback: feedback ?? this.feedback,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, dynamic> get source {
    return {
      ReportKeys.id: id,
      ReportKeys.timeMills: timeMills,
      ReportKeys.reporter: reporter,
      ReportKeys.publisher: publisher,
      ReportKeys.path: path,
      ReportKeys.parentId: parentId,
      ReportKeys.parentPath: parentPath,
      ReportKeys.feedback: feedback,
      ReportKeys.category: category,
    };
  }
}
