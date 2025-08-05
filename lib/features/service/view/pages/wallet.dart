import 'package:flutter/material.dart';

import '../../../../roots/widgets/appbar.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: InAppAppbar(titleText: "Wallet"));
  }
}
