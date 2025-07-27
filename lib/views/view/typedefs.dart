part of "view.dart";

typedef OnViewBuilder<T> = Widget Function(BuildContext context, T? controller);
typedef OnViewChangeListener<T> = void Function(T value);
typedef OnViewClickListener = void Function(BuildContext context);
typedef OnViewItemClickListener<T> = void Function(BuildContext contex, T item);
typedef OnViewItemChangeListener<T> = void Function(
  BuildContext context,
  T item,
);
typedef OnViewErrorListener = String? Function(ViewError error);
typedef OnViewToggleListener = void Function(bool value);
typedef OnViewHoverListener = void Function(bool value);
typedef OnViewValidListener = void Function(bool value);
typedef OnViewValidatorListener = bool Function(String value);
typedef OnViewIndexBuilder = Widget Function(
  BuildContext context,
  int index,
);
typedef OnViewToggleHandler<T extends ViewController> = void Function(
  BuildContext context,
  T controller,
);
typedef OnViewAttachBuilder<T extends ViewController> = Widget? Function(
  BuildContext context,
  T controller,
);
typedef OnViewModifyBuilder<T extends ViewController> = Widget Function(
  BuildContext context,
  T controller,
  Widget parent,
);
typedef OnViewNotifier = void Function(VoidCallback fn);
typedef OnViewNotifyListener<T extends ViewController> = void Function(
    T controller);

typedef OnViewActivator = Future<bool> Function(bool running, dynamic value);
