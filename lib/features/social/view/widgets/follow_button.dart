import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../data/models/user_following.dart';
import '../../../user/view/cubits/following_cubit.dart';

class InAppFollowBuilder extends StatefulWidget {
  final String publisher;
  final Widget Function(
    BuildContext context,
    bool isFollowing,
    VoidCallback callback,
  )
  builder;

  const InAppFollowBuilder({
    super.key,
    required this.publisher,
    required this.builder,
  });

  @override
  State<InAppFollowBuilder> createState() => _InAppFollowBuilderState();
}

class _InAppFollowBuilderState extends State<InAppFollowBuilder> {
  late final cubit = context.read<UserFollowingCubit>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit.exist(widget.publisher);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFollowingCubit, Response<FollowingModel>>(
      builder: (context, value) {
        final activated = value.isExist(widget.publisher);
        return widget.builder(context, activated, () {});
      },
    );
  }
}
