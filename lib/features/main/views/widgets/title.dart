import 'package:flutter/material.dart';

import '../../../../roots/widgets/text.dart';

class Header extends StatelessWidget {
  final String? data;

  const Header(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return InAppText(
      data,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}
