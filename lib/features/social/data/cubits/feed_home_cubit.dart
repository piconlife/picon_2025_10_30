import 'package:flutter/material.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../data/models/feed.dart';
import '../../../../data/use_cases/feed/create.dart';
import '../../../../data/use_cases/feed/delete.dart';
import '../../../../data/use_cases/feed/get_stars.dart';
import '../../../../data/use_cases/feed/update.dart';

class FeedHomeCubit extends DataCubit<FeedModel> {
  FeedHomeCubit(super.context);

  @override
  Future<Response<FeedModel>> onFetch({
    int? initialSize,
    int? fetchingSize,
    bool resultByMe = false,
  }) async {
    if (resultByMe) return Response();
    return GetStarFeedsByPaginationUseCase.i(
      initialSize: initialSize ?? 10,
      fetchingSize: fetchingSize ?? 5,
      snapshot: state.snapshot,
    );
  }

  @protected
  @override
  Future<Response<FeedModel>> onCreate(FeedModel data) =>
      CreateFeedUseCase.i(data);

  @protected
  @override
  Future<Response<FeedModel>> onDelete(FeedModel data) => onDeleteById(data.id);

  @protected
  @override
  Future<Response<FeedModel>> onDeleteById(String id) =>
      DeleteFeedUseCase.i(id);

  @protected
  @override
  Future<Response<FeedModel>> onUpdate(
    FeedModel old,
    Map<String, dynamic> changes,
  ) {
    return UpdateFeedUseCase.i(old.id, changes);
  }

  void deletes(BuildContext context, int index, FeedModel data) {
    // Analytics.callAsync(name: 'delete_feed', reason: data.id, () async {
    //   emit(state.copyWith(result: state.result..removeAt(index)));
    //   final feedback = await DeleteFeedUseCase.i(data.id);
    //   if (!context.mounted) return;
    //   if (!feedback.isSuccessful) {
    //     context.showErrorSnackBar(feedback.status.error);
    //     emit(state.copyWith(result: state.result..insert(index, data)));
    //     return;
    //   }
    //   StorageService.i.deletes(data.photoUrls.use, lazy: true);
    //   if (data.path == null || data.path!.isEmpty) return;
    //   GetLikesUseCase.i(data.path ?? '').then((value) {
    //     for (var i in value.result) {
    //       if (i.parentPath != null || i.parentPath!.isEmpty) return null;
    //       DeleteLikeUseCase.i(i.parentPath!, i.id);
    //     }
    //   });
    //   GetStarsUseCase.i(data.path ?? '').then((value) {
    //     for (var i in value.result) {
    //       if (i.parentPath != null || i.parentPath!.isEmpty) return null;
    //       DeleteStarUseCase.i(i.parentPath!, i.id);
    //     }
    //   });
    //   GetCommentsUseCase.i(data.path ?? '').then((value) {
    //     for (var i in value.result) {
    //       if (i.parentPath != null || i.parentPath!.isEmpty) return null;
    //       DeleteFeedCommentUseCase.i(id: i.id, path: i.parentPath!);
    //     }
    //   });
    // });
  }

  void share(BuildContext context, String id) {
    // final index = state.result.indexWhere((e) => e.id == id);
    // if (index < 0) return;
    // final data = state.result.elementAtOrNull(index);
    // if (data == null || data.id != id) return;
    // if (!data.isShareMode) return;
    // Utils.share(
    //   context,
    //   subject:
    //       data.isTranslated ? data.translatedTitle ?? data.title : data.title,
    //   body:
    //       data.isTranslated
    //           ? data.translatedDescription ?? data.description
    //           : data.description,
    //   urls: data.photoUrls,
    // );
  }

  void copy(BuildContext context, String id) {
    // final index = state.result.indexWhere((e) => e.id == id);
    // if (index < 0) return;
    // final data = state.result.elementAtOrNull(index);
    // if (data == null || data.id != id) return;
    // if (!data.isShareMode) return;
    // if (!data.isDescription) return;
    // ClipboardHelper.setText(
    //   data.isTranslated
    //       ? data.translatedDescription ?? data.description.use
    //       : data.description.use,
    // );
  }

  void follow(BuildContext context, String id) {
    // final index = state.result.indexWhere((e) => e.id == id);
    // if (index < 0) return;
    // final data = state.result.elementAtOrNull(index);
    // if (data == null || data.id != id) return;
    // // if (!data.isDescription) return;
    // // ClipboardHelper.setText(data.description!);
  }

  void download(BuildContext context, String id) {
    // final index = state.result.indexWhere((e) => e.id == id);
    // if (index < 0) return;
    // final data = state.result.elementAtOrNull(index);
    // if (data == null || data.id != id) return;
    // // if (!data.isDescription) return;
    // // ClipboardHelper.setText(data.description!);
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
    // // reports.add(report.getDocument_id());
    // // mViewModel.addReport(report);
    // // if (!data.isDescription) return;
    // // ClipboardHelper.setText(data.description!);
  }

  void translate(int index, FeedModel item, ValueChanged<FeedModel> notify) {
    // final header = item.title ?? '';
    // final body = item.description ?? '';
    // if (!item.isTranslatable) return;
    // if (item.isTranslated) {
    //   item =
    //       item
    //         ..translatedTitle = null
    //         ..translatedDescription = null;
    //   updatedAt(index, item);
    //   notify(item);
    //   return;
    // }
    // TranslateProvider.translates([header, body], to: UserHelper.language).then((
    //   value,
    // ) {
    //   item =
    //       item
    //         ..translatedTitle = value.firstOrNull
    //         ..translatedDescription = value.lastOrNull;
    //   updatedAt(index, item);
    //   notify(item);
    // });
  }
}
