import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:data_management/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/list.dart';
import 'package:flutter_andomie/utils/key_generator.dart';
import 'package:flutter_andomie/utils/path_replacer.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:flutter_androssy_kits/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/flutter_entity.dart';
import 'package:in_app_analytics/analytics.dart';
import 'package:in_app_navigator/in_app_navigator.dart';
import 'package:in_app_settings/in_app_settings.dart';
import 'package:object_finder/object_finder.dart';

import '../../../../app/helpers/user.dart';
import '../../../../app/interfaces/bsd_audience.dart';
import '../../../../app/interfaces/bsd_privacy.dart';
import '../../../../app/res/icons.dart';
import '../../../../app/res/msg.dart';
import '../../../../data/constants/keys.dart';
import '../../../../data/constants/paths.dart';
import '../../../../data/enums/audience.dart';
import '../../../../data/enums/feed_type.dart';
import '../../../../data/enums/privacy.dart';
import '../../../../data/models/content.dart';
import '../../../../data/models/feed.dart';
import '../../../../data/models/photo.dart';
import '../../../../data/models/user_post.dart';
import '../../../../data/use_cases/feed/create.dart';
import '../../../../data/use_cases/feed/update.dart';
import '../../../../roots/contents/media.dart';
import '../../../../roots/helpers/connectivity.dart';
import '../../../../roots/services/path_provider.dart';
import '../../../../roots/services/storage.dart';
import '../../../../roots/services/uploader.dart';
import '../../../../roots/utils/image_provider.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/bottom_bar.dart';
import '../../../../roots/widgets/icon_button.dart';
import '../../../../roots/widgets/screen.dart';
import '../../../../roots/widgets/texted_action.dart';
import '../../../../routes/paths.dart';
import '../../../user/view/cubits/post_cubit.dart';
import '../../../user/view/widgets/uploading_image.dart';
import '../cubits/feed_home_cubit.dart';

const _kRecentPostPath = "recent_post_path";

class CreatePostPage extends StatefulWidget {
  final Object? args;

  const CreatePostPage({super.key, this.args});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  late Object? data = widget.args;

  late String id;
  late String photosPath;

  final etHeader = TextEditingController();
  final etDescription = TextEditingController();

  final audience = Audience.everyone.obx;
  final privacy = Privacy.everyone.obx;
  final tags = <String>[].obx;
  final photos = <EditablePhoto>[].obx;

  late final feedCubit = context.read<FeedHomeCubit>();
  late final postCubit = context.read<UserPostCubit>();

  Content? old;
  FeedType type = FeedType.post;

  String get title => etHeader.text;

  String get description => etDescription.text;

  bool get isUpdateMode => old != null;

  /// --------------------------------------------------------------------------
  /// BASE SECTION START
  /// --------------------------------------------------------------------------

  void _init(BuildContext context) {
    old = data?.findOrNull(key: "$Content");
    if (old != null) {
      id = old!.id;
      type = old?.type ?? FeedType.none;
      etHeader.text = old!.title ?? '';
      etDescription.text = old!.descriptionOrNull ?? '';
      photos.set(old!.photos.use.map(EditablePhoto.photo).toList());
      privacy.set(Privacy.parse(old?.privacy));
    } else {
      id = KeyGenerator.generateKey();
      type = data.findByKey("$FeedType", defaultValue: FeedType.post);
      if (type.isPhoto) {
        _pickPhotos(data.findOrNull(key: "$EditablePhotoFeedback"));
      }
    }
    photosPath = PathReplacer.replaceByIterable(Paths.userPhotos, [
      UserHelper.uid,
    ]);
  }

  void _changeAudience(BuildContext context) {
    AudienceBSD.show(context, audience.value).then((value) {
      audience.value = value;
    });
  }

  void _changePrivacy(BuildContext context) {
    PrivacyBSD.show(context, privacy.value).then((value) {
      privacy.value = value;
    });
  }

  void _changeTags(BuildContext context) {}

  void _changeMore(BuildContext context) {}

  /// --------------------------------------------------------------------------
  /// BASE SECTION END
  /// --------------------------------------------------------------------------

  /// --------------------------------------------------------------------------
  /// PHOTO SECTION START
  /// --------------------------------------------------------------------------

  List<Content> get currentPhotos {
    return photos.value.map((i) => i.rootData).whereType<Content>().toList();
  }

  List<Content> get deletedPhotos {
    if (old == null) return [];
    final current = currentPhotos;
    return old!.photos.where((e) => !current.contains(e)).toList();
  }

  Future<UploadingStatus> _createPhoto(
    BuildContext context,
    int index,
    UploadingSnapshot snapshot,
  ) async {
    final url = snapshot.url;
    if (url == null || url.isEmpty) return UploadingStatus.error;
    final x = photos.value.removeAt(index);
    final photoId = snapshot.id;
    final data = Photo.create(
      id: photoId,
      timeMills: Entity.generateTimeMills,
      publisherId: UserHelper.uid,
      path: PathProvider.generatePath(photosPath, photoId),
      audience: audience.value,
      privacy: privacy.value,
      photoUrl: url,
    );
    photos.value.insert(index, x.copy(data));
    return UploadingStatus.processed;
  }

  void _updatePosition(int previous, int current) {
    if (current > previous) current -= 1;
    final item = photos.value.removeAt(previous);
    photos.value.insert(current, item);
  }

  void _pickPhotos(Object? feedback) {
    if (feedback is! EditablePhotoFeedback) return;
    photos.value = feedback.currents;
    if (feedback.deletes.isEmpty) return;
    final urls =
        feedback.deletes
            .map((e) {
              final x = e.data;
              if (x is String && x.isNotEmpty) return x;
              return null;
            })
            .whereType<String>()
            .toList();
    if (urls.isEmpty) return;
    StorageService.i.deletes(urls);
  }

  void _choosePhoto(BuildContext context) async {
    if (await ConnectivityHelper.isDisconnected) {
      if (!context.mounted) return;
      context.showToast(Msg.internetError);
      return;
    }
    if (!context.mounted) return;
    context
        .open(
          Routes.choosePhoto,
          arguments: {
            "List<$EditablePhoto>": List<EditablePhoto>.from(photos.value),
          },
        )
        ?.then(_pickPhotos);
  }

  /// --------------------------------------------------------------------------
  /// PHOTO SECTION END
  /// --------------------------------------------------------------------------

  /// --------------------------------------------------------------------------
  /// FINAL SECTION START
  /// --------------------------------------------------------------------------

  void _create(BuildContext context) {
    if (photos.value.isEmpty && description.isEmpty) {
      context.showMessage(Msg.writeSomething);
      return;
    }
    final mPhotos = currentPhotos;

    if (mPhotos.length != photos.value.length) {
      context.showMessage(Msg.waitASecond);
      return;
    }

    final mTimeMills = Entity.generateTimeMills;

    final mUserPost = UserPost.create(
      id: id,
      timeMills: mTimeMills,
      publisherId: UserHelper.uid,
      audience: audience.value,
      privacy: privacy.value,
      title: title.isEmpty ? null : title,
      description: description.isEmpty ? null : description,
      type: mPhotos.isNotEmpty ? FeedType.photo : null,
      tags: tags.value,
      photos:
          mPhotos.isEmpty
              ? null
              : mPhotos.map((e) {
                return e
                  ..privacy = privacy.value
                  ..audience = audience.value;
              }).toList(),
    );

    final mFeed = Feed.create(
      id: id,
      timeMills: mTimeMills,
      path: PathProvider.generatePath(Paths.feeds, id),
      content: mUserPost,
      recentRef: Settings.get(_kRecentPostPath, null),
      type: mUserPost.type,
    );

    Analytics.future(name: 'create_post', () async {
      context.showLoader();
      final feedback = await CreateFeedUseCase.i(mFeed);
      if (!context.mounted) return;
      context.hideLoader();
      if (feedback.isSuccessful) {
        Settings.set(_kRecentPostPath, mUserPost.path);
        feedCubit.created(mFeed);
        postCubit.created(mUserPost);
        context.close();
        return;
      }
      final allow = await context.showAlert(message: Msg.somethingWentWrong);
      if (!context.mounted) return;
      if (!allow) {
        context.showMessage(Msg.postFailed);
        return;
      }
      _create(context);
    });
  }

  void _update(BuildContext context) {
    if (photos.value.isEmpty && description == old!.description) {
      context.showMessage(Msg.writeSomething);
      return;
    }
    final mPhotos = currentPhotos;

    if (mPhotos.length != photos.value.length) {
      context.showMessage(Msg.waitASecond);
      return;
    }

    final cp = currentPhotos.map((e) {
      if (old!.photos.contains(e)) {
        final updates = {
          if (privacy.value != old!.privacy) Keys.i.privacy: privacy.value.name,
          if (audience.value != old!.audience)
            Keys.i.audience: audience.value.name,
        };
        if (e.path != null && updates.isNotEmpty) {
          return {"path": e.path, "update": updates};
        }
        return e.path;
      }
      return e.createMetadata;
    });
    final dp = deletedPhotos.map((e) => e.deleteMetadata);
    final hasChangedPhotos =
        !(cp.every((e) => e is String) && dp.isEmpty) ||
        old!.photos.map((e) => e.id).toString() !=
            currentPhotos.map((e) => e.id).toString();
    final metadata = [if (hasChangedPhotos) ...cp, if (dp.isNotEmpty) ...dp];

    final isTitleDeleted = title.isEmpty && old!.title.isNotEmpty;
    final isTitleChanged = title.isNotEmpty && old!.title != title;

    final isDescriptionDeleted =
        description.isEmpty && old!.description.isNotEmpty;
    final isDescriptionChanged =
        description.isNotEmpty && old!.description != description;

    final updates = {
      if (isTitleDeleted) Keys.i.title: DataFieldValue.delete(),
      if (isTitleChanged) Keys.i.title: title,
      if (isDescriptionDeleted) Keys.i.description: DataFieldValue.delete(),
      if (isDescriptionChanged) Keys.i.description: description,
      if (metadata.isNotEmpty) Keys.i.photosRef: metadata,
    };

    if (updates.isNotEmpty) {
      updates[Keys.i.updatedAt] = Entity.generateTimeMills;
    }

    if (updates.isEmpty) {
      context.showMessage(Msg.noChangesFound);
      return;
    }

    Content? updatedContent(Content? v) {
      if (v == null) return null;
      if (isTitleChanged) {
        v.title = title;
      } else if (isTitleDeleted) {
        v.title = null;
      }
      if (isDescriptionChanged) {
        v.description = description;
      } else if (isDescriptionDeleted) {
        v.description = null;
      }
      if (hasChangedPhotos) {
        v.photos = currentPhotos;
      }
      return v;
    }

    Analytics.future(name: 'update_post', () async {
      context.showLoader();
      final feedback = await UpdateFeedUseCase.i(id, {
        Keys.i.contentRef: {"path": old!.path!, "update": updates},
        Keys.i.updatedAt: Entity.generateTimeMills,
      });
      if (!context.mounted) return;
      context.hideLoader();
      if (feedback.isSuccessful) {
        if (old is Feed) {
          old!.content = updatedContent(old?.contentOrNull);
        } else if (old is UserPost) {
          old = updatedContent(old);
        }
        context.close(result: old);
        return;
      }
      final allow = await context.showAlert(message: Msg.somethingWentWrong);
      if (!context.mounted) return;
      if (!allow) {
        context.showMessage(Msg.postFailed);
        return;
      }
      _update(context);
    });
  }

  void _submit(BuildContext context, [bool skipMode = false]) {
    if (skipMode) return;
    if (isUpdateMode) {
      _update(context);
    } else {
      _create(context);
    }
  }

  /// --------------------------------------------------------------------------
  /// FINAL SECTION END
  /// --------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _init(context);
  }

  @override
  void dispose() {
    etHeader.dispose();
    etDescription.dispose();
    photos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final light = context.light;
    final dark = context.dark;
    return InAppScreen(
      theme: ThemeType.secondary,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: InAppAppbar(
          titleText: isUpdateMode ? "Update post" : "Add a new post",
          actions: [
            InAppTextedAction(
              isUpdateMode ? "Update" : "Post",
              onTap: () => _submit(context),
            ),
          ],
        ),
        bottomNavigationBar: InAppBottomBar(
          height: kToolbarHeight,
          shadowBlurRadius: 50,
          shadowColor: dark.t05,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InAppIconButton(
                InAppIcons.tagMultiple.regular,
                primaryColor: Colors.transparent,
                iconColor: CupertinoColors.activeGreen,
                iconScale: 1.5,
                onTap: () => _changeTags(context),
              ),
              InAppIconButton(
                InAppIcons.audience.regular,
                primaryColor: Colors.transparent,
                iconColor: CupertinoColors.systemBlue,
                iconScale: 1.5,
                onTap: () => _changeAudience(context),
              ),
              InAppIconButton(
                InAppIcons.addPhoto.solid,
                iconColor: context.primary,
                primaryColor: Colors.transparent,
                size: 50,
                iconScale: 1.5,
                onTap: () => _choosePhoto(context),
              ),
              InAppIconButton(
                InAppIcons.public.regular,
                primaryColor: Colors.transparent,
                iconColor: CupertinoColors.systemBlue,
                iconScale: 1.5,
                onTap: () => _changePrivacy(context),
              ),
              InAppIconButton(
                InAppIcons.moreX.regular,
                primaryColor: CupertinoColors.systemGreen.t10,
                iconColor: CupertinoColors.systemGreen,
                iconScale: 1.5,
                onTap: () => _changeMore(context),
              ),
              // SizedBox(width: dimen.dp(8)),
              // AndrossyObserver(
              //   observer: privacy,
              //   builder: (context, value) {
              //     return InAppTextButton(
              //       value.title,
              //       highlightColor: dark.t05,
              //       borderRadius: BorderRadius.circular(dimen.dp(10)),
              //       style: TextStyle(
              //         color: dark,
              //         fontSize: dimen.dp(14),
              //         fontWeight: FontWeight.bold,
              //       ),
              //       onTap: () => _changePrivacy(context),
              //     );
              //   },
              // ),
              // VerticalDivider(
              //   color: dark.t05,
              //   indent: dimen.dp(12),
              //   endIndent: dimen.dp(12),
              // ),
              // InAppTextButton(
              //   "Photo",
              //   highlightColor: dark.t05,
              //   borderRadius: BorderRadius.circular(dimen.dp(10)),
              //   style: TextStyle(
              //     color: dark,
              //     fontSize: dimen.dp(14),
              //     fontWeight: FontWeight.bold,
              //   ),
              //   onTap: () => _choosePhoto(context),
              // ),
              // SizedBox(width: dimen.dp(8)),
            ],
          ),
        ),
        body: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: dimen.dp(0.5)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [light, light.t75],
            ),
          ),
          child: ListView(
            children: [
              AndrossyObserver(
                observer: photos,
                builder: (context, base) {
                  return ReorderableList(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: base.length,
                    itemBuilder: (context, index) {
                      final item = base.elementAt(index);
                      Widget child = _ItemPhoto(
                        key: ValueKey(item.id),
                        photo: item,
                        path: photosPath,
                        onProcessing:
                            (context, value) =>
                                _createPhoto(context, index, value),
                      );
                      return ReorderableDelayedDragStartListener(
                        index: index,
                        key: ValueKey(item.id),
                        child: Container(
                          margin: EdgeInsets.only(bottom: dimen.dp(4)),
                          width: double.infinity,
                          child: child,
                        ),
                      );
                    },
                    onReorder: _updatePosition,
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.all(dimen.dp(24)),
                child: Column(
                  children: [
                    AndrossyField(
                      controller: etHeader,
                      text: old?.title,
                      hintText: "Header",
                      maxCharacters: 100,
                      hintColor: dark.t25,
                      counterVisibility: FloatingVisibility.auto,
                      underlineColor: AndrossyFieldProperty(enabled: dark.t10),
                      onTapOutside: (_) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                    AndrossyField(
                      minLines: 10,
                      text: old?.description,
                      hintText: "Write something...",
                      hintColor: dark.t25,
                      controller: etDescription,
                      underlineColor: const AndrossyFieldProperty.none(),
                      inputType: TextInputType.multiline,
                      onTapOutside: (_) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemPhoto extends StatelessWidget {
  final EditablePhoto photo;
  final String path;
  final InAppUploaderProcessingCallback onProcessing;

  const _ItemPhoto({
    super.key,
    required this.photo,
    required this.path,
    required this.onProcessing,
  });

  @override
  Widget build(BuildContext context) {
    final data = photo.rootData;
    if (data is MediaData) {
      return InAppUploader(
        task: UploadingTask(id: photo.id, path: path, data: data),
        onProcessing: onProcessing,
        builder: (context, value, callback) {
          final status = value.status;
          final data = value.value;
          return InAppUploadingImage(
            data: photo.data,
            loading: status == UploadingStatus.loading,
            processing: status == UploadingStatus.processing,
            progressing: status == UploadingStatus.progressing,
            internetError: status == UploadingStatus.networkError,
            error: status == UploadingStatus.error,
            progress: data is double ? data : 0.0,
            tryAgain: callback,
          );
        },
      );
    }
    if (data is Content) {
      return InAppUploadingImage(data: data.photoUrl);
    }
    return const SizedBox.shrink();
  }
}
