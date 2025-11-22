import 'package:flutter/material.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/enums/privacy.dart';
import '../../../../data/models/star.dart';
import '../../../../data/use_cases/star/count.dart';
import '../../../../data/use_cases/star/create.dart';
import '../../../../data/use_cases/star/delete.dart';
import '../../../../data/use_cases/star/get_by_id.dart';
import '../../../../data/use_cases/star/get_by_pagination.dart';

class StarCubit extends DataCubit<StarModel> {
  final String path;

  StarCubit(BuildContext context, this.path, {int? initialCount})
    : super(context, Response(count: initialCount));

  @protected
  @override
  StarModel? createNewObject(Object? args) {
    if (path.isEmpty) return null;
    return StarModel.create(
      privacy: args is Privacy ? args : null,
      parentPath: path,
    );
  }

  @protected
  @override
  Future<Response<int>> onCount() => GetStarsCountUseCase.i(path);

  @protected
  @override
  Future<Response<StarModel>> onCreate(StarModel data) {
    return CreateStarUseCase.i(data);
  }

  @protected
  @override
  Future<Response<StarModel>> onDelete(StarModel data) {
    return DeleteStarUseCase.i(path, data.id);
  }

  @protected
  @override
  Future<Response<StarModel>> onFetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) {
    if (resultByMe) {
      return GetStarUseCase.i(path, UserHelper.uid);
    }
    return GetStarsByPaginationUseCase.i(
      path,
      initialSize: initialSize,
      fetchingSize: fetchingSize,
      snapshot: state.snapshot,
    );
  }
}
