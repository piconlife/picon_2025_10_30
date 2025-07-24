import 'package:auth_management/widgets.dart';
import 'package:flutter/material.dart';

import '../data/models/user.dart';
import '../data/use_cases/user/get.dart';
import '../helpers/user.dart';

class InAppUserBuilder extends StatefulWidget {
  final String? id;
  final User? initial;
  final Widget Function(BuildContext, User user) builder;

  const InAppUserBuilder({
    super.key,
    this.id,
    this.initial,
    required this.builder,
  });

  @override
  State<InAppUserBuilder> createState() => _InAppUserBuilderState();
}

class _InAppUserBuilderState extends State<InAppUserBuilder> {
  @override
  Widget build(BuildContext context) {
    final id = widget.id ?? widget.initial?.id;
    if (id != null && id.isNotEmpty && !UserHelper.isCurrentUser(id)) {
      if (widget.initial != null) {
        return widget.builder(context, widget.initial!);
      }
      return FutureBuilder(
        future: GetUserUseCase.i(id),
        builder: (context, snapshot) =>
            widget.builder(context, snapshot.data?.data ?? User()),
      );
    }
    return AuthConsumer<User>(
      builder: (context, value) => widget.builder(context, value ?? User()),
    );
  }
}
