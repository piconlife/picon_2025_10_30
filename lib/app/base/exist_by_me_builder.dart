import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

import 'data_cubit.dart';

class ExistByMeBuilder<C extends DataCubit<T>, T extends Object>
    extends StatelessWidget {
  final int? index;
  final Object? args;
  final Future<Object?> Function()? onArgs;
  final Widget Function(BuildContext context, bool exist, AsyncCallback toggle)
  builder;

  const ExistByMeBuilder({
    super.key,
    this.index,
    this.args,
    this.onArgs,
    required this.builder,
  });

  Future<void> _toggle(BuildContext context, bool exist) async {
    Object? args = this.args;
    if (onArgs != null) {
      args = await onArgs!();
    }
    if (!context.mounted) return;
    context.read<C>().toggle(index: index, exist: exist, args: args);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, Response<T>>(
      builder: (context, value) {
        final exist = value.isExistByMe;
        return builder(context, exist, () => _toggle(context, exist));
      },
    );
  }
}
