import 'package:data_management/core.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/list.dart';
import 'package:flutter_andomie/models/selection.dart';
import 'package:flutter_andomie/utils/converter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';
import 'package:random_avatar/random_avatar.dart';

import '../../../../app/helpers/user.dart';
import '../../../../data/models/user.dart';

class SuggestedUsersCubit extends Cubit<Response<Selection<User>>> {
  SuggestedUsersCubit() : super(Response());

  void fetch({int initialSize = 25, int fetchingSize = 50}) async {
    emit(state.copyWith(status: Status.loading));
    Future.delayed(Duration(seconds: 3), () {
      final faker = Faker();
      final result = List.generate(
        state.snapshot == null ? initialSize : fetchingSize,
        (index) {
          final id = "id_${index + state.result.length}";
          final name = faker.person.name();
          String svg = RandomAvatarString(
            DateTime.now().toIso8601String(),
            trBackground: false,
          );
          return User(
            id: id,
            photo: svg,
            name: name,
            username: Converter.toUserName(name),
            biography: faker.lorem.sentence(),
            rating: index % 6,
          );
        },
      );
      return Response(result: result, snapshot: result);
    }).then(_attach);
    // GetUsersUseCase.i().then(_attach).catchError((error, __) {
    //   emit(state.copy(status: Status.failure));
    // });
  }

  void update(BuildContext context, Selection<User> value) {
    emit(
      state.copyWith(
        result: state.result.change(value, (e) {
          return e.data.id == value.data.id;
        }),
      ),
    );
    DataFieldValue field;
    if (value.selected) {
      field = DataFieldValue.arrayRemove([value.id]);
    } else {
      field = DataFieldValue.arrayUnion([value.id]);
    }
    UserHelper.update(context, {UserKeys.i.approvals: field});
  }

  void _attach(Response<User> response) {
    final data = state.result.where((e) {
      return !UserHelper.followings.contains(e.id);
    }).toList();
    if (response.result.isNotEmpty) {
      data.addAll(
        response.result.map((e) {
          return Selection(id: e.id, data: e, selected: false);
        }),
      );
    }
    emit(
      state.copyWith(
        status: response.status,
        snapshot: response.snapshot,
        result: data,
        requestCode: 0,
      ),
    );
  }
}
