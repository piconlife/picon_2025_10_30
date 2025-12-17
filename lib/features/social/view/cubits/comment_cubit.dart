import 'package:flutter/material.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../data/models/comment.dart';
import '../../../../data/use_cases/comment/count.dart';
import '../../../../data/use_cases/comment/create.dart';
import '../../../../data/use_cases/comment/delete.dart';
import '../../../../data/use_cases/comment/gets.dart';
import '../../../../data/use_cases/comment/pagination.dart';
import '../../../../data/use_cases/comment/update.dart';

class CommentCubit extends DataCubit<CommentModel> {
  final String path;

  CommentCubit(BuildContext context, this.path, {int? initialCount})
    : super(context, Response(count: initialCount));

  @protected
  @override
  Future<Response<int>> onCount() => CommentCountUseCase.i(path);

  @protected
  @override
  Future<Response<CommentModel>> onCreate(CommentModel data) {
    return CommentCreateUseCase.i(data);
  }

  @protected
  @override
  Future<Response<CommentModel>> onDelete(CommentModel data) {
    return onDeleteById(data.id);
  }

  @protected
  @override
  Future<Response<CommentModel>> onDeleteById(String id) {
    return CommentDeleteUseCase.i.call(id: id, path: path);
  }

  @protected
  @override
  Future<Response<CommentModel>> onFetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) {
    if (resultByMe) {
      return CommentGetsUseCase.i(path, fetchForMe: true);
    }
    return CommentPaginationUseCase.i(
      path: path,
      initialSize: initialSize ?? 30,
      fetchingSize: fetchingSize ?? 15,
      snapshot: state.snapshot,
    );
  }

  @protected
  @override
  Future<Response<CommentModel>> onUpdate(
    CommentModel old,
    Map<String, dynamic> changes,
  ) async {
    return CommentUpdateUseCase.i.call(
      id: old.id,
      path: path,
      changes: changes,
    );
  }
}
