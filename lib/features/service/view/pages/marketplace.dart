import 'package:flutter/material.dart';

import '../../../../roots/widgets/appbar.dart';

class MarketplacePage extends StatelessWidget {
  const MarketplacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: InAppAppbar(titleText: "Marketplace"));
  }
}
