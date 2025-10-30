import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/string.dart';
import 'package:flutter_andomie/helpers/clipboard_helper.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../data/models/content.dart';
import '../../../../data/models/user_post.dart';
import '../../../../data/use_cases/user_post/count.dart';
import '../../../../data/use_cases/user_post/get_by_pagination.dart';
import '../../../../roots/services/translator.dart';
import '../../../../roots/utils/utils.dart';
import '../../../../routes/paths.dart';

class UserPostCubit extends DataCubit<UserPost> {
  final String uid;

  UserPostCubit([String? uid]) : uid = uid ?? UserHelper.uid;

  @override
  Future<Response<int>> count() => GetUserFeedCountUseCase.i(uid);

  @override
  Future<Response<UserPost>> fetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) async {
    if (resultByMe) return Response(status: Status.undefined);
    return GetUserPostsByPaginationUseCase.i(
      uid: uid,
      initialSize: initialSize ?? 10,
      fetchingSize: fetchingSize ?? 5,
      snapshot: state.snapshot,
    );
  }

  void edit(BuildContext context, String id) async {
    final index = state.result.indexWhere((e) => e.id == id);
    if (index < 0) return;
    final data = state.result.elementAtOrNull(index);
    if (data == null || data.id != id) return;
    final feedback = await context.open(
      Routes.createUserPost,
      arguments: {"$Content": data},
    );
    if (feedback is! UserPost) return;
    updated(index, (_) => feedback);
  }

  void share(BuildContext context, String id) {
    final index = state.result.indexWhere((e) => e.id == id);
    if (index < 0) return;
    final data = state.result.elementAtOrNull(index);
    if (data == null || data.id != id) return;
    if (!data.isShareMode) return;
    Utils.share(
      context,
      subject:
          data.isTranslated ? data.translatedTitle ?? data.title : data.title,
      body:
          data.isTranslated
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
    // final labels = InAppReport.labels;
    // final index = state.result.indexWhere((e) => e.id == id);
    // if (index < 0) return;
    // final data = state.result.elementAtOrNull(index);
    // if (data == null || data.id != id) return;
    // final type = await context.showOptionsSheet(
    //   title: "What kind of problem is this feed causing you?",
    //   options: labels,
    // );
    // if (!context.mounted) return;
    // final feedback = await context.showEditorSheet(
    //   title: "Please enter your reporting message?",
    //   hint: "Write a report…",
    // );
    // final mId = Entity.generateID;
    // final path = PathProvider.generatePath(Paths.reports, mId, data.path);
    // final report = UserReport(
    //   id: mId,
    //   reporter: UserHelper.uid,
    //   publisher: data.publisherId,
    //   path: path,
    //   parentId: data.id,
    //   parentPath: data.path,
    //   feedback: feedback,
    //   category: labels.elementAtOrNull(type),
    // );
    // reports.add(report.getDocument_id());
    // mViewModel.addReport(report);
    // if (!data.isDescription) return;
    // ClipboardHelper.setText(data.description!);
  }

  void translate(int index, UserPost item, ValueChanged<UserPost> notify) {
    final header = item.title ?? '';
    final body = item.description ?? '';
    if (!item.isTranslatable) return;
    if (item.isTranslated) {
      item =
          item
            ..translatedTitle = null
            ..translatedDescription = null;
      updated(index, (_) => item);
      notify(item);
      return;
    }
    TranslateProvider.translates([header, body], to: UserHelper.language).then((
      value,
    ) {
      item =
          item
            ..translatedTitle = value.firstOrNull
            ..translatedDescription = value.lastOrNull;
      updated(index, (_) => item);
      notify(item);
    });
  }
}
