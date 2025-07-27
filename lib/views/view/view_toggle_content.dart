part of 'view.dart';

class ViewToggleContent<T> {
  final T active;
  final T inactive;

  const ViewToggleContent({
    required this.active,
    T? inactive,
  }) : inactive = inactive ?? active;

  T detect(bool isActivated) => isActivated ? active : inactive;
}
