part of 'view.dart';

class DropdownItem<T> {
  final T value;
  final String name;
  final dynamic leadingIcon;
  final dynamic trailingIcon;

  const DropdownItem({
    required this.value,
    required this.name,
    this.leadingIcon,
    this.trailingIcon,
  });
}
