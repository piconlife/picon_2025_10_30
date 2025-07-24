import 'package:flutter/material.dart';

import '../../../../roots/widgets/text.dart';
import 'leading.dart';

class PrimaryAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  const PrimaryAppbar({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      title: _buildTitle(),
      backgroundColor: Colors.white,
      elevation: 0,
      leading: InAppLeading(),
    );
  }

  Widget? _buildTitle() {
    if (title == null || title!.isEmpty) return null;
    return InAppText(
      title!,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
