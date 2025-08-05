import 'package:flutter/material.dart';

import '../../../../roots/widgets/appbar.dart';

class SearchProductsPage extends StatelessWidget {
  const SearchProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: InAppAppbar(titleText: "Search products"));
  }
}
