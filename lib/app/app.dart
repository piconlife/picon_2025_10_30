import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';

import '../routes/_imports.dart';
import 'configs/local.dart';
import 'constants/app.dart';
import 'theme/dark.dart';
import 'theme/light.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Translation.i,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppConstants.name,
          themeMode: LocalConfigs.theme,
          locale:
              Translation.i.localeOrNull ?? Translation.i.defaultLocaleOrNull,
          initialRoute: InAppRouter.initialRoute,
          onGenerateRoute: InAppRouter.I.generate,
          theme: kLightTheme,
          darkTheme: kDarkTheme,
        );
      },
    );
  }
}
