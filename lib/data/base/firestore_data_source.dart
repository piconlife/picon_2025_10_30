import 'package:flutter_entity/entity.dart' show Entity;

import '../../app/imports/data_management.dart' show RemoteDataSource;
import '../delegates/firestore.dart' show FirestoreDataDelegate;

abstract class FirestoreDataSource<T extends Entity>
    extends RemoteDataSource<T> {
  FirestoreDataSource(String path, {super.limitations})
    : super(path: path, delegate: FirestoreDataDelegate.i);
}
