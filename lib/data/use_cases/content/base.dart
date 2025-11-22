import 'package:data_management/core.dart';

import '../../repositories/content.dart';

class Pair<A, B> {
  final A a;
  final B b;

  const Pair(this.a, this.b);
}

class ContentBaseUseCase {
  final ContentRepository repository;

  ContentBaseUseCase() : repository = ContentRepository.i;

  Pair<String, DataFieldParams>? getPair(String path) {
    final paths = path.split('/');
    if (paths.length < 2 || paths.length.isOdd) return null;
    final id = paths.last;
    paths.removeLast();
    final mPath = paths.join('/');
    return Pair(id, getParams(mPath));
  }

  IterableParams getParams(String path) {
    return IterableParams([path]);
  }
}
