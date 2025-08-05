import 'package:flutter/material.dart';

import '../../../../roots/widgets/appbar.dart';

class CreateAStoryPage extends StatelessWidget {
  const CreateAStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: InAppAppbar(titleText: "Create a story"));
  }
}
