import 'package:flutter/material.dart';

import '../../roots/widgets/icon.dart';
import '../../roots/widgets/text.dart';

class InAppCachedNetworkImageError extends StatelessWidget {
  final String url;
  final Object error;

  const InAppCachedNetworkImageError({
    super.key,
    required this.url,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Center(
        child: FittedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InAppIcon(Icons.error_outline, color: Colors.grey),
              SizedBox(height: 8),
              InAppText(
                "This image couldn't be loaded!",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
