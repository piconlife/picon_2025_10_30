import 'package:flutter/material.dart';

import '../../../../roots/widgets/appbar.dart';

class SearchGroceriesPage extends StatelessWidget {
  const SearchGroceriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: InAppAppbar(titleText: "Search grocery products"),
    );
  }
}
