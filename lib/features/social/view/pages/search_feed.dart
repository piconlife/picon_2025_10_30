import 'package:flutter/material.dart';

import '../../../../roots/widgets/appbar.dart';

class SearchFeedsPage extends StatelessWidget {
  const SearchFeedsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: InAppAppbar(titleText: "Search posts"));
  }
}
