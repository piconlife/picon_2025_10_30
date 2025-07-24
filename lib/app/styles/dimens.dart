import 'package:app_dimen/app_dimen.dart';

class InAppDimens {
  const InAppDimens._();

  static const appbar = DimenConfig(mobile: ConstraintDimen());

  static const avatar = DimenConfig(mobile: SizeDimen.avatar());

  static const bottom = DimenConfig(mobile: ConstraintDimen());

  static const button = DimenConfig(mobile: ConstraintDimen());

  static const corner = DimenConfig(mobile: SizeDimen.corner());

  static const divider = DimenConfig(mobile: SizeDimen.divider());

  static const fontSize = DimenConfig(mobile: SizeDimen.font());

  static const fontWeight = DimenConfig(mobile: WeightDimen());

  static const icon = DimenConfig(mobile: SizeDimen.icon());

  static const image = DimenConfig(mobile: ConstraintDimen());

  static const indicator = DimenConfig(mobile: SizeDimen.indicator());

  static const logo = DimenConfig(mobile: SizeDimen.logo());

  static const margin = DimenConfig(mobile: SizeDimen.margin());

  static const padding = DimenConfig(mobile: SizeDimen.padding());

  static final scaffold = DimenConfig(mobile: ConstraintDimen());

  static const size = DimenConfig(mobile: SizeDimen.size());

  static const space = DimenConfig(mobile: SizeDimen.space());

  static const stroke = DimenConfig(mobile: SizeDimen.stroke());

  static const customs = <DimenConfigData>[];
}
