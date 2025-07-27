part of 'view.dart';

class SettingsTailingView extends StatelessWidget {
  final SettingsViewController controller;

  const SettingsTailingView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.type.isArrow) {
      return SettingsTailingArrow(controller: controller);
    } else if (controller.type.isCheckmark) {
      return SettingsTailingCheckmark(controller: controller);
    } else if (controller.type.isSwitcher) {
      return SettingsTailingSwitch(controller: controller);
    } else {
      return const SizedBox(
        width: 26,
        height: 40,
      );
    }
  }
}
