import 'dart:convert';

import 'package:in_app_configs/configs.dart';

class OnboardConfigs {
  final OnboardHeroConfigs hero;

  const OnboardConfigs({this.hero = const OnboardHeroConfigs()});

  factory OnboardConfigs.from(Object? source) {
    if (source is String) source = jsonDecode(source);
    if (source is! Map) return OnboardConfigs();
    final heroConfigs = source['hero_configs'] ?? source['heroConfigs'];
    return OnboardConfigs(hero: OnboardHeroConfigs.from(heroConfigs));
  }

  static OnboardConfigs get i {
    return Configs.get(
      "configs/onboards",
      defaultValue: OnboardConfigs(),
      parser: OnboardConfigs.from,
    );
  }
}

class OnboardHeroConfigs {
  final bool title;
  final bool body;
  final bool image;
  final bool logo;
  final bool filledButton;
  final bool outlinedButton;
  final bool appbar;
  final bool appbarLeading;
  final bool appbarTitle;

  const OnboardHeroConfigs({
    this.title = false,
    this.body = false,
    this.image = false,
    this.logo = false,
    this.filledButton = false,
    this.outlinedButton = false,
    this.appbar = false,
    this.appbarLeading = false,
    this.appbarTitle = false,
  });

  factory OnboardHeroConfigs.from(Object? source) {
    if (source is String) source = jsonDecode(source);
    if (source is! Map) return OnboardHeroConfigs();
    final title = source['title'];
    final body = source['body'];
    final image = source['image'];
    final logo = source['logo'];
    final filledButton = source['filled_button'] ?? source['filledButton'];
    final outlinedButton =
        source['outlined_button'] ?? source['outlinedButton'];
    final appbar = source['appbar'];
    final appbarLeading = source['appbar_leading'] ?? source['appbarLeading'];
    final appbarTitle = source['appbar_title'] ?? source['appbarTitle'];
    return OnboardHeroConfigs(
      title: title is bool ? title : false,
      body: body is bool ? body : false,
      image: image is bool ? image : false,
      logo: logo is bool ? logo : false,
      filledButton: filledButton is bool ? filledButton : false,
      outlinedButton: outlinedButton is bool ? outlinedButton : false,
      appbar: appbar is bool ? appbar : false,
      appbarLeading: appbarLeading is bool ? appbarLeading : false,
      appbarTitle: appbarTitle is bool ? appbarTitle : false,
    );
  }

  static OnboardHeroConfigs get i => OnboardConfigs.i.hero;
}
