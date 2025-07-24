import 'package:flutter/material.dart';

import '../../routes/builder.dart';
import '../../routes/paths.dart';
import 'views/pages/ai.dart';

Map<String, RouteBuilder> get kAiRoutes {
  return {Routes.ai: _ai};
}

Widget _ai(BuildContext context, Object? args) {
  return AiPage(args: args);
}
