import 'package:app_dimen/app_dimen.dart';
import 'package:auth_management/widgets.dart';
import 'package:flutter/material.dart';

import '../../app/res/placeholders.dart';
import '../data/models/user.dart';
import 'gesture.dart';
import 'icon.dart';
import 'image.dart';

class InAppUserAvatar extends StatelessWidget {
  final bool isLocal;
  final dynamic url;
  final double? size;
  final EdgeInsets? margin;
  final double? border;
  final Color? borderColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const InAppUserAvatar({
    super.key,
    this.isLocal = false,
    this.url,
    this.size,
    this.border,
    this.borderColor,
    this.backgroundColor,
    this.margin,
    this.onTap,
  });

  Widget child(BuildContext context, String? url) {
    final size = this.size ?? context.smallAvatar;
    return InAppGesture(
      onTap: onTap,
      shape: const CircleBorder(),
      backgroundColor: backgroundColor,
      child: SizedBox(
        width: size,
        height: size,
        child: url == null || url.isEmpty
            ? InAppIcon(Icons.person, color: Colors.grey, size: 44)
            : InAppImage(
                url,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLocal) {
      return AuthConsumer<User>(
        builder: (context, value) {
          return child(context, value?.photo ?? url);
        },
      );
    } else {
      return child(context, url ?? InAppPlaceholders.user);
    }
  }
}
