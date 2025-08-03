import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';

import '../routes/_imports.dart';
import 'constants/app.dart';
import 'constants/configs.dart';
import 'theme/dark/theme.dart';
import 'theme/light/theme.dart';

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
          themeMode: ConfigsConstants.theme,
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
