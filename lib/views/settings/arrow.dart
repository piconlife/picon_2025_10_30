part of 'view.dart';

class SettingsTailingArrow extends StatelessWidget {
  final SettingsViewController controller;

  const SettingsTailingArrow({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final config = controller.arrowConfig;
    if (config.arrow != null) return config.arrow!;
    return RawIconView(
      icon: config.icon ?? Icons.arrow_forward_ios_rounded,
      tint: config.color ?? Colors.grey.withOpacity(0.5),
      size: config.size ?? 24,
    );
  }
}
