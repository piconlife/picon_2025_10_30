import 'package:data_management/core.dart';
import 'package:flutter_entity/entity.dart';

import '../delegates/firestore.dart';

abstract class FirestoreDataSource<T extends Entity>
    extends RemoteDataSource<T> {
  FirestoreDataSource(String path, {super.limitations})
    : super(path: path, delegate: FirestoreDataDelegate.i);
}
