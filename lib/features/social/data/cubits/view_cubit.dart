import 'package:flutter/foundation.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/view.dart';
import '../../../../data/use_cases/view/count.dart';
import '../../../../data/use_cases/view/create.dart';
import '../../../../data/use_cases/view/delete.dart';
import '../../../../data/use_cases/view/get_by_id.dart';
import '../../../../data/use_cases/view/get_by_pagination.dart';

class ViewCubit extends DataCubit<ViewModel> {
  final String path;

  ViewCubit(this.path, {int? initialCount})
    : super(Response(count: initialCount));

  @protected
  @override
  ViewModel? createNewObject(Object? args) {
    if (path.isEmpty) return null;
    return ViewModel.create(parentPath: path);
  }

  @protected
  @override
  Future<Response<int>> count() => GetViewsCountUseCase.i(path);

  @protected
  @override
  Future<Response<ViewModel>> create(ViewModel data) {
    return CreateViewUseCase.i(data);
  }

  @protected
  @override
  Future<Response<ViewModel>> delete(ViewModel data) {
    return DeleteViewUseCase.i(path, data.id);
  }

  @protected
  @override
  Future<Response<ViewModel>> fetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) {
    if (resultByMe) {
      return GetViewUseCase.i(UserHelper.uid, path);
    }
    return GetViewsByPaginationUseCase.i(
      path,
      initialSize: initialSize,
      fetchingSize: fetchingSize,
      snapshot: state.snapshot,
    );
  }
}
