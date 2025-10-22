import 'package:in_app_translation/in_app_translation.dart';

String stepsParser(String key, int total, int step) {
  return Translation.localize(
    key,
    applyNumber: true,
    applyTranslator: false,
    replace: (value) {
      return value
          .replaceAll("{TOTAL_STEPS}", "$total")
          .replaceAll("{STEP}", step.toString());
    },
  );
}
