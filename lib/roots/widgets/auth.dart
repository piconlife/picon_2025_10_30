import 'package:flutter/material.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../features/startup/views/pages/login.dart';
import '../helpers/user.dart';
import '../notifiers/auth.dart';

class InAppAuth extends StatefulWidget {
  final String name;
  final bool enabled;
  final bool isSkipMode;
  final bool isBackMode;
  final Widget child;

  const InAppAuth({
    super.key,
    required this.name,
    this.enabled = true,
    this.isSkipMode = false,
    this.isBackMode = true,
    required this.child,
  });

  @override
  State<InAppAuth> createState() => _InAppAuthState();
}

class _InAppAuthState extends State<InAppAuth> {
  bool get isSkipped {
    if (!widget.isSkipMode) return false;
    return AuthManager.isSkipped(widget.name);
  }

  bool get isUnlocked {
    return isSkipped || AuthManager.isAuthorized;
  }

  void skip() {
    AuthManager.setSkipped(widget.name);
    if (Navigator.canPop(context)) {
      context.close();
    } else {
      setState(() {});
    }
  }

  void _init(_) {
    UserHelper.isLoggedIn(context).then(AuthManager.setInitialized);
  }

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      WidgetsBinding.instance.addPostFrameCallback(_init);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return ListenableBuilder(
      listenable: AuthManager.i,
      child: widget.child,
      builder: (context, child) {
        if (isUnlocked) return child ?? widget.child;
        return LoginPage(
          isBackMode: widget.isBackMode,
          onSkipped: widget.isSkipMode ? skip : null,
        );
      },
    );
  }
}
