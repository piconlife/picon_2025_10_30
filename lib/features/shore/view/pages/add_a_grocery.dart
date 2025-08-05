import 'package:flutter/material.dart';

import '../../../../roots/widgets/appbar.dart';
import '../dialogs/bsd_grocery_format.dart';

class AddAGroceryPage extends StatelessWidget {
  const AddAGroceryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InAppAppbar(titleText: GroceryFormats.addAGrocery.title),
    );
  }
}
