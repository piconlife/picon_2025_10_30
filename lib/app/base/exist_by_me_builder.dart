import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

import 'data_cubit.dart';

class ExistByMeBuilder<C extends DataCubit<T>, T extends Object>
    extends StatelessWidget {
  final int? index;
  final Object? args;
  final Widget Function(BuildContext context, bool exist, VoidCallback toggle)
  builder;

  const ExistByMeBuilder({
    super.key,
    this.index,
    this.args,
    required this.builder,
  });

  void _toggle(BuildContext context, bool exist) {
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
