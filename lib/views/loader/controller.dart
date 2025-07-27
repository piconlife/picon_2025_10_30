part of 'view.dart';

class LoaderViewController<T> extends ViewController {
  T? data;

  LoaderViewController<T> fromLoaderView(LoaderView<T> view) {
    super.fromView(view);
    return this;
  }

  void setData(T data) {
    super.onNotifyWithCallback(() {
      this.data = data;
    });
  }
}
