import 'package:flutter/material.dart';
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

  ViewCubit(BuildContext context, this.path, {int? initialCount})
    : super(context, Response(count: initialCount));

  @protected
  @override
  ViewModel? createNewObject(Object? args) {
    if (path.isEmpty) return null;
    return ViewModel.create(parentPath: path);
  }

  @protected
  @override
  Future<Response<int>> onCount() => GetViewsCountUseCase.i(path);

  @protected
  @override
  Future<Response<ViewModel>> onCreate(ViewModel data) {
    return CreateViewUseCase.i(data);
  }

  @protected
  @override
  Future<Response<ViewModel>> onCreateIfNotExist(ViewModel data) {
    return GetViewUseCase.i(path, UserHelper.uid).then((value) {
      if (!value.status.isResultNotFound) return value;
      return onCreate(data);
    });
  }

  @protected
  @override
  Future<Response<ViewModel>> onDelete(ViewModel data) {
    return DeleteViewUseCase.i(path, data.id);
  }

  @protected
  @override
  Future<Response<ViewModel>> onFetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) {
    if (resultByMe) {
      return GetViewUseCase.i(path, UserHelper.uid);
    }
    return GetViewsByPaginationUseCase.i(
      path,
      initialSize: initialSize,
      fetchingSize: fetchingSize,
      snapshot: state.snapshot,
    );
  }
}
