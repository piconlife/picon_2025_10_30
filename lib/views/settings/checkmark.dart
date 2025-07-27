part of 'view.dart';

class SettingsTailingCheckmark extends StatelessWidget {
  final SettingsViewController controller;

  const SettingsTailingCheckmark({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final config = controller.checkmarkConfig;
    return AbsorbPointer(
      child: Checkbox.adaptive(
        splashRadius: 0,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        value: controller.activated,
        activeColor: config.activeColor,
        fillColor: config.fillColor(controller),
        checkColor: config.checkColor,
        focusColor: config.focusColor,
        hoverColor: config.hoverColor,
        overlayColor: config.overlayColor(controller),
        onChanged: (_) {},
      ),
    );
  }
}
