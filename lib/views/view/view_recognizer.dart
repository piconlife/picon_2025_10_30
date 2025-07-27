part of 'view.dart';

class ViewRecognizer {
  final BuildContext context;

  const ViewRecognizer.of(this.context);

  GestureRecognizer? onClick(OnViewClickListener? callback) {
    if (callback != null) {
      return TapGestureRecognizer()..onTap = () => callback(context);
    } else {
      return null;
    }
  }

  GestureRecognizer? onDoubleClick(OnViewClickListener? callback) {
    if (callback != null) {
      return DoubleTapGestureRecognizer()
        ..onDoubleTap = () => callback(context);
    } else {
      return null;
    }
  }

  GestureRecognizer? onLongClick(OnViewClickListener? callback) {
    if (callback != null) {
      return LongPressGestureRecognizer()
        ..onLongPress = () => callback(context);
    } else {
      return null;
    }
  }
}

extension ViewRecognizerExtension on BuildContext {
  GestureRecognizer? onClick(OnViewClickListener? callback) {
    return ViewRecognizer.of(this).onClick(callback);
  }

  GestureRecognizer? onDoubleClick(OnViewClickListener? callback) {
    return ViewRecognizer.of(this).onDoubleClick(callback);
  }

  GestureRecognizer? onLongClick(OnViewClickListener? callback) {
    return ViewRecognizer.of(this).onLongClick(callback);
  }
}
