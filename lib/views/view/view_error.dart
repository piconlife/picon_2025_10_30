part of 'view.dart';

enum ViewError {
  none,
  empty,
  invalid,
  alreadyFound,
  maximum,
  minimum,
  unmodified;

  bool get isEmpty => this == ViewError.empty;

  bool get isInvalid => this == ViewError.invalid;

  bool get isMaximum => this == ViewError.maximum;

  bool get isMinimum => this == ViewError.minimum;

  bool get isAlreadyFound => this == ViewError.alreadyFound;

  bool get isUnmodified => this == ViewError.unmodified;
}
