import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../data/models/user_following.dart';
import '../../../user/view/cubits/following_cubit.dart';

class InAppFollowBuilder extends StatefulWidget {
  final String id;
  final Widget Function(
    BuildContext context,
    bool isFollowing,
    VoidCallback callback,
  )
  builder;

  const InAppFollowBuilder({
    super.key,
    required this.id,
    required this.builder,
  });

  @override
  State<InAppFollowBuilder> createState() => _InAppFollowBuilderState();
}

class _InAppFollowBuilderState extends State<InAppFollowBuilder> {
  late final cubit = context.read<UserFollowingCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFollowingCubit, Response<UserFollowing>>(
      builder: (context, state) {
        final data = state.elementOf((e) => e.id == widget.id);
        return widget.builder(context, data != null, () {
          // cubit.toggle(widget.id, data);
        });
      },
    );
  }
}
