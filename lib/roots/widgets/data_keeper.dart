import 'package:flutter/material.dart';
import 'package:flutter_androssy_kits/widgets.dart';

class InAppDataKeeper<T extends Object?> extends StatelessWidget {
  final String backupKey;
  final AndrossyDataResponse<T>? initial;
  final Future<T> Function() callback;

  final Widget Function(BuildContext, AndrossyDataResponse<T> value) builder;

  const InAppDataKeeper({
    super.key,
    this.initial,
    required this.backupKey,
    required this.callback,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return AndrossyDataKeeper(
      backupKey: backupKey,
      callback: callback,
      builder: builder,
    );
  }
}
