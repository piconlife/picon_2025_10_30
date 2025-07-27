part of 'view.dart';

typedef OnSlideLayoutItemBuilder<T> = Widget Function(
  BuildContext context,
  int index,
  T item,
);
typedef OnSlideLayoutCounterBuilder<T> = Widget Function(
  BuildContext context,
  int index,
  int size,
  T item,
);

typedef OnSlideLayoutCounterHandler = void Function(int index, int size);
