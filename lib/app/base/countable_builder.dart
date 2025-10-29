import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

import 'data_cubit.dart';

class CountableBuilder<C extends DataCubit<T>, T extends Object>
    extends StatelessWidget {
  final Widget Function(BuildContext context, int count) builder;

  const CountableBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, Response<T>>(
      builder: (context, value) {
        return builder(context, value.count);
      },
    );
  }
}
