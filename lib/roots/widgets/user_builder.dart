import 'package:auth_management/widgets.dart';
import 'package:flutter/material.dart';

import '../../app/helpers/user.dart';
import '../../data/models/user.dart';
import '../../data/use_cases/user/get.dart';

class InAppUserBuilder extends StatefulWidget {
  final String? id;
  final User? initial;
  final bool currentUser;
  final Widget Function(BuildContext, User user) builder;

  const InAppUserBuilder({
    super.key,
    this.id,
    this.initial,
    this.currentUser = false,
    required this.builder,
  });

  @override
  State<InAppUserBuilder> createState() => _InAppUserBuilderState();
}

class _InAppUserBuilderState extends State<InAppUserBuilder> {
  @override
  Widget build(BuildContext context) {
    final id = widget.id ?? widget.initial?.id;
    if (widget.currentUser || UserHelper.isCurrentUser(id)) {
      return AuthConsumer<User>(
        builder: (context, value) => widget.builder(context, value ?? User()),
      );
    }
    if (id != null && id.isNotEmpty) {
      return FutureBuilder(
        future: GetUserUseCase.i(id),
        builder: (context, snapshot) {
          return widget.builder(
            context,
            snapshot.data?.data ?? widget.initial ?? User(),
          );
        },
      );
    }
    return widget.builder(context, widget.initial ?? User());
  }
}
