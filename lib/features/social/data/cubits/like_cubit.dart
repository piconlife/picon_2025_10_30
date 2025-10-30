import 'package:flutter/material.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/enums/like_type.dart';
import '../../../../data/models/like.dart';
import '../../../../data/use_cases/like/count.dart';
import '../../../../data/use_cases/like/create.dart';
import '../../../../data/use_cases/like/delete.dart';
import '../../../../data/use_cases/like/get_by_id.dart';
import '../../../../data/use_cases/like/get_by_pagination.dart';

class LikeCubit extends DataCubit<LikeModel> {
  final String path;

  LikeCubit(BuildContext context, this.path, {int? initialCount})
    : super(context, Response(count: initialCount));

  @protected
  @override
  LikeModel? createNewObject(Object? args) {
    if (path.isEmpty) return null;
    return LikeModel.create(
      type: args is LikeType ? args : null,
      parentPath: path,
    );
  }

  @protected
  @override
  Future<Response<int>> onCount() => GetLikesCountUseCase.i(path);

  @protected
  @override
  Future<Response<LikeModel>> onCreate(LikeModel data) {
    return CreateLikeUseCase.i(data);
  }

  @protected
  @override
  Future<Response<LikeModel>> onDelete(LikeModel data) {
    return DeleteLikeUseCase.i(path, data.id);
  }

  @protected
  @override
  Future<Response<LikeModel>> onFetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) {
    if (resultByMe) {
      return GetLikeUseCase.i(UserHelper.uid, path);
    }
    return GetLikesByPaginationUseCase.i(
      path,
      initialSize: initialSize,
      fetchingSize: fetchingSize,
      snapshot: state.snapshot,
    );
  }
}
