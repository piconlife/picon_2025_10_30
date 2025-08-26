import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/list.dart';
import 'package:flutter_andomie/extensions/string.dart';
import 'package:flutter_andomie/helpers/clipboard_helper.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_navigator/in_app_navigator.dart';
import 'package:picon/data/use_cases/user_post/count.dart';
import 'package:picon/roots/services/storage.dart';

import '../../../../app/base/countable_response.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/constants/paths.dart';
import '../../../../data/models/user_post.dart';
import '../../../../data/models/user_report.dart';
import '../../../../data/use_cases/feed_star/delete.dart';
import '../../../../data/use_cases/feed_star/get.dart';
import '../../../../data/use_cases/feed_video/delete.dart';
import '../../../../data/use_cases/feed_video/get.dart';
import '../../../../data/use_cases/photo/delete.dart';
import '../../../../data/use_cases/photo/get.dart';
import '../../../../data/use_cases/user_post/create.dart';
import '../../../../data/use_cases/user_post/delete.dart';
import '../../../../data/use_cases/user_post/get_by_pagination.dart';
import '../../../../roots/services/path_provider.dart';
import '../../../../roots/services/translator.dart';
import '../../../../roots/utils/utils.dart';
import '../../../../routes/paths.dart';
import '../../../chooser/data/models/report.dart';

class UserPostCubit extends Cubit<CountableResponse<UserPost>> {
  final String uid;

  UserPostCubit([String? uid])
    : uid = uid ?? UserHelper.uid,
      super(CountableResponse());

  void count() {
    GetUserFeedCountUseCase.i(uid).then((value) {
      emit(state.copy(count: value.data));
    });
  }

  void fetch({int initialSize = 10, int fetchingSize = 5}) {
    emit(state.copy(status: Status.loading));
    GetUserPostsByPaginationUseCase.i(
      uid: uid,
      initialSize: initialSize,
      fetchingSize: fetchingSize,
      snapshot: state.snapshot,
    ).then(_attach).catchError((error, st) {
      emit(state.copy(status: Status.failure));
    });
  }

  void update(UserPost value) {
    final index = state.result.indexOf(value);
    if (index >= 0) {
      state.result.removeAt(index);
      state.result.insert(index, value);
      emit(state.copy(data: value, result: state.result, requestCode: 202));
    }
  }

  void _attach(Response<UserPost> response) {
    emit(
      state.copy(
        status: response.status,
        snapshot: response.snapshot,
        result: state.result..addAll(response.result),
        requestCode: 0,
      ),
    );
  }

  Future<Response<UserPost>> create(UserPost data) {
    return CreateUserPostUseCase.i(data).then((value) {
      if (value.isSuccessful) {
        emit(state.copy(result: state.result..insert(0, data)));
      }
      return value;
    });
  }

  void delete(BuildContext context, String id) {
    final index = state.result.indexWhere((e) => e.id == id);
    if (index < 0) return;
    final data = state.result.elementAtOrNull(index);
    if (data == null || data.id != id) return;
    emit(state.copy(result: state.result..removeAt(index)));
    DeleteUserPostUseCase.i(id).then((feedback) {
      if (!context.mounted) return;
      if (!feedback.isSuccessful) {
        context.showErrorSnackBar(feedback.status.error);
        emit(state.copy(result: state.result..insert(index, data)));
        return;
      }
      StorageService.i.deletes(data.photoUrls.use, lazy: true);
      if (data.path == null || data.path!.isEmpty) return;
      GetPhotosUseCase.i(data.path ?? '').then((value) {
        for (var i in value.result) {
          if (i.parentPath != null || i.parentPath!.isEmpty) return null;
          DeletePhotoUseCase.i(id: i.id, path: i.parentPath!);
        }
      });
      // GetLikesUseCase.i(data.path ?? '').then((value) {
      //   for (var i in value.result) {
      //     if (i.parentPath != null || i.parentPath!.isEmpty) return null;
      //     DeleteFeedLikeUseCase.i(id: i.id, path: i.parentPath!);
      //   }
      // });
      GetStarsUseCase.i(data.path ?? '').then((value) {
        for (var i in value.result) {
          if (i.parentPath != null || i.parentPath!.isEmpty) return null;
          DeleteFeedStarUseCase.i(id: i.id, path: i.parentPath!);
        }
      });
      // GetCommentsUseCase.i(data.path ?? '').then((value) {
      //   for (var i in value.result) {
      //     if (i.parentPath != null || i.parentPath!.isEmpty) return null;
      //     DeleteFeedCommentUseCase.i(id: i.id, path: i.parentPath!);
      //   }
      // });
      GetVideosUseCase.i(data.path ?? '').then((value) {
        for (var i in value.result) {
          if (i.parentPath != null || i.parentPath!.isEmpty) return null;
          DeleteFeedVideoUseCase.i(id: i.id, path: i.parentPath!);
        }
      });
    });
  }

  void edit(BuildContext context, String id) async {
    final index = state.result.indexWhere((e) => e.id == id);
    if (index < 0) return;
    final data = state.result.elementAtOrNull(index);
    if (data == null || data.id != id) return;
    final feedback = await context.open(
      Routes.createUserPost,
      arguments: {"$UserPost": data},
    );
    if (feedback is! UserPost) return;
    emit(
      state.copy(
        result: state.result
          ..removeAt(index)
          ..insert(index, feedback),
      ),
    );
  }

  void share(BuildContext context, String id) {
    final index = state.result.indexWhere((e) => e.id == id);
    if (index < 0) return;
    final data = state.result.elementAtOrNull(index);
    if (data == null || data.id != id) return;
    if (!data.isShareMode) return;
    Utils.share(
      context,
      subject: data.isTranslated
          ? data.translatedTitle ?? data.title
          : data.title,
      body: data.isTranslated
          ? data.translatedDescription ?? data.description
          : data.description,
      urls: data.photoUrls,
    );
  }

  void copy(BuildContext context, String id) {
    final index = state.result.indexWhere((e) => e.id == id);
    if (index < 0) return;
    final data = state.result.elementAtOrNull(index);
    if (data == null || data.id != id) return;
    if (!data.isShareMode) return;
    if (!data.isDescription) return;
    ClipboardHelper.setText(
      data.isTranslated
          ? data.translatedDescription ?? data.description.use
          : data.description.use,
    );
  }

  void follow(BuildContext context, String id) {
    final index = state.result.indexWhere((e) => e.id == id);
    if (index < 0) return;
    final data = state.result.elementAtOrNull(index);
    if (data == null || data.id != id) return;
    // if (!data.isDescription) return;
    // ClipboardHelper.setText(data.description!);
  }

  void download(BuildContext context, String id) {
    final index = state.result.indexWhere((e) => e.id == id);
    if (index < 0) return;
    final data = state.result.elementAtOrNull(index);
    if (data == null || data.id != id) return;
    // if (!data.isDescription) return;
    // ClipboardHelper.setText(data.description!);
  }

  void report(BuildContext context, String id) async {
    final labels = InAppReport.labels;
    final index = state.result.indexWhere((e) => e.id == id);
    if (index < 0) return;
    final data = state.result.elementAtOrNull(index);
    if (data == null || data.id != id) return;
    final type = await context.showOptionsSheet(
      title: "What kind of problem is this feed causing you?",
      options: labels,
    );
    if (!context.mounted) return;
    final feedback = await context.showEditorSheet(
      title: "Please enter your reporting message?",
      hint: "Write a report…",
    );
    final mId = Entity.generateID;
    final path = PathProvider.generatePath(Paths.reports, mId, data.path);
    final report = UserReport(
      id: mId,
      reporter: UserHelper.uid,
      publisher: data.publisherId,
      path: path,
      parentId: data.id,
      parentPath: data.path,
      feedback: feedback,
      category: labels.elementAtOrNull(type),
    );
    // reports.add(report.getDocument_id());
    // mViewModel.addReport(report);
    // if (!data.isDescription) return;
    // ClipboardHelper.setText(data.description!);
  }

  void translate(UserPost item, ValueChanged<UserPost> notify) {
    final header = item.title ?? '';
    final body = item.description ?? '';
    if (!item.isTranslatable) return;
    if (item.isTranslated) {
      item = item
        ..translatedTitle = null
        ..translatedDescription = null;
      update(item);
      notify(item);
      return;
    }
    TranslateProvider.translates([header, body], to: UserHelper.language).then((
      value,
    ) {
      item = item
        ..translatedTitle = value.firstOrNull
        ..translatedDescription = value.lastOrNull;
      update(item);
      notify(item);
    });
  }
}
