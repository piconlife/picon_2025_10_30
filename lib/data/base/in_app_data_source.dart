import 'package:flutter_entity/entity.dart' show Entity;

import '../../app/imports/data_management.dart' show LocalDataSource;
import '../delegates/local.dart' show LocalDataDelegate;

abstract class InAppDataSource<T extends Entity> extends LocalDataSource<T> {
  InAppDataSource(String path, {super.documentId = 'id'})
    : super(path: path, delegate: LocalDataDelegate.i);
}
