part of 'view.dart';

typedef LoaderViewFutureDataLoader<T> = Future<T> Function();
typedef LoaderViewStreamDataLoader<T> = Stream<T> Function();

typedef LoaderViewBuilder<T> = Widget Function(
  BuildContext context,
  LoaderViewController<T> controller,
);
