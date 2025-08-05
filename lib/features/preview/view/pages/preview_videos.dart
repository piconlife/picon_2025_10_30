import 'package:flutter/material.dart';

import '../../../../roots/widgets/appbar.dart';

class PreviewVideosPage extends StatelessWidget {
  const PreviewVideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: InAppAppbar(titleText: "Preview Videos"));
  }
}
