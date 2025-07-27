part of 'view.dart';

extension ObserverExtension<T> on T {
  Observer<T> get obx => Observer(this);
}
