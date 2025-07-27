part of 'view.dart';

class Observer<T> extends ViewController {
  T _value;

  Observer(T value) : _value = value;

  T get value => _value;

  set value(T value) => onNotifyWithCallback(() => _value = value);

  void set(T value) {
    _value = value;
  }
}
