import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../delegates/local.dart';

abstract class InAppDataSource<T extends Entity> extends LocalDataSource<T> {
  InAppDataSource(String path)
    : super(path: path, delegate: LocalDataDelegate.i);
}
