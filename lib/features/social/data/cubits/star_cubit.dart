import 'package:flutter/foundation.dart';
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

  StarCubit(this.path, {int? initialCount})
    : super(Response(count: initialCount));

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
  Future<Response<int>> count() => GetStarsCountUseCase.i(path);

  @protected
  @override
  Future<Response<StarModel>> create(StarModel data) {
    return CreateStarUseCase.i(data);
  }

  @protected
  @override
  Future<Response<StarModel>> delete(StarModel data) {
    return DeleteStarUseCase.i(path, data.id);
  }

  @protected
  @override
  Future<Response<StarModel>> fetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) {
    if (resultByMe) {
      return GetStarUseCase.i(UserHelper.uid, path);
    }
    return GetStarsByPaginationUseCase.i(
      path,
      initialSize: initialSize,
      fetchingSize: fetchingSize,
      snapshot: state.snapshot,
    );
  }
}
