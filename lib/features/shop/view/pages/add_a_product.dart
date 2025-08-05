import 'package:flutter/material.dart';

import '../../../../roots/widgets/appbar.dart';
import '../dialogs/bsd_market_format.dart';

class AddAProductPage extends StatelessWidget {
  const AddAProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InAppAppbar(titleText: MarketFormats.addAProduct.title),
    );
  }
}
