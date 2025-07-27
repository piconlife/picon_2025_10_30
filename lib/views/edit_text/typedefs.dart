part of 'view.dart';

typedef OnEditTextChecker = Future<bool> Function(String value);

typedef EditTextDrawableBuilder<T extends EditTextController> = Widget Function(
  BuildContext context,
  T controller,
);

typedef EditTextContextMenuBuilder = Widget Function(
  BuildContext context,
  EditableTextState state,
);

typedef EditTextPrivateCommandListener = void Function(
  String value,
  Map<String, dynamic> params,
);

typedef EditTextVoidListener = void Function();
typedef EditTextCheckListener = Function(String tag, bool valid);
typedef EditTextSelectionChangeListener = void Function(
  TextSelection selection,
  SelectionChangedCause? cause,
);
typedef EditTextSubmitListener = void Function(String value);
typedef EditTextTapOutsideListener = void Function(PointerDownEvent event);
