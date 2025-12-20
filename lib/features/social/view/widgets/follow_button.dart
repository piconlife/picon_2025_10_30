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

  void _toggle(bool following) {
    if (following) {
      cubit.unfollow(widget.publisher);
    } else {
      cubit.follow(widget.publisher);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit.exist(widget.publisher);
    });
  }

  @override
  void didUpdateWidget(covariant InAppFollowBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.publisher != widget.publisher) {
      cubit.exist(widget.publisher);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFollowingCubit, Response<FollowingModel>>(
      buildWhen: (p, c) {
        return p.isExist(widget.publisher) != c.isExist(widget.publisher);
      },
      builder: (context, value) {
        final following = value.isExist(widget.publisher);
        return widget.builder(context, following, () => _toggle(following));
      },
    );
  }
}
