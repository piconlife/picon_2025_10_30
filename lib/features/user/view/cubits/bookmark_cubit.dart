import 'package:flutter/material.dart';
import 'package:flutter_entity/entity.dart';
import 'package:object_finder/object_finder.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../data/models/bookmark.dart';
import '../../../../data/use_cases/bookmark/count.dart';
import '../../../../data/use_cases/bookmark/create.dart';
import '../../../../data/use_cases/bookmark/delete.dart';
import '../../../../data/use_cases/bookmark/pagination.dart';

class UserBookmarkCubit extends DataCubit<BookmarkModel> {
  UserBookmarkCubit(BuildContext context, {int? initialCount})
    : super(context, Response(count: initialCount));

  @protected
  @override
  BookmarkModel? createNewObject(Object? args) {
    if (args is BookmarkModel) return args;
    String? path = args.findOrNull(key: "path");
    String? contentType = args.findOrNull(key: "contentType");
    if (path == null || path.isEmpty) return null;
    if (contentType == null || contentType.isEmpty) return null;
    return BookmarkModel.create(path: path, contentType: contentType);
  }

  @protected
  @override
  Future<Response<int>> onCount() => BookmarkCountUseCase.i();

  @protected
  @override
  Future<Response<BookmarkModel>> onCreate(BookmarkModel data) {
    return BookmarkCreateUseCase.i(data);
  }

  @protected
  @override
  Future<Response<BookmarkModel>> onDelete(BookmarkModel data) {
    return BookmarkDeleteUseCase.i(data.id);
  }

  @protected
  @override
  Future<Response<BookmarkModel>> onFetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) {
    return BookmarkPaginationUseCase.i(
      initialSize: initialSize,
      fetchingSize: fetchingSize,
      snapshot: state.snapshot,
    );
  }
}
