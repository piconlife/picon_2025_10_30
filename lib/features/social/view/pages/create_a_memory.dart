import 'dart:developer';

import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/list.dart';
import 'package:flutter_andomie/utils/key_generator.dart';
import 'package:flutter_andomie/utils/path_replacer.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:flutter_androssy_kits/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/flutter_entity.dart';
import 'package:in_app_navigator/in_app_navigator.dart';
import 'package:object_finder/object_finder.dart';

import '../../../../roots/contents/media.dart';
import '../../../../app/dialogs/bsd_audience.dart';
import '../../../../app/dialogs/bsd_privacy.dart';
import '../../../../app/helpers/user.dart';
import '../../../../app/res/icons.dart';
import '../../../../data/constants/keys.dart';
import '../../../../data/constants/paths.dart';
import '../../../../data/enums/audience.dart';
import '../../../../data/enums/feed_type.dart';
import '../../../../data/enums/privacy.dart';
import '../../../../data/models/feed.dart';
import '../../../../data/models/photo.dart';
import '../../../../data/models/user_post.dart';
import '../../../../data/use_cases/feed/create.dart';
import '../../../../data/use_cases/photo/create.dart';
import '../../../../data/use_cases/user_post/update.dart';
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
import '../../../user/view/cubits/photo_cubit.dart';
import '../../../user/view/cubits/post_cubit.dart';
import '../../../user/view/widgets/uploading_image.dart';

class CreateAMemoryPage extends StatefulWidget {
  final Object? args;

  const CreateAMemoryPage({super.key, this.args});

  @override
  State<CreateAMemoryPage> createState() => _CreateAMemoryPageState();
}

class _CreateAMemoryPageState extends State<CreateAMemoryPage> {
  late Object? data = widget.args;

  late String id;
  late String path;
  late String photosPath;

  final etHeader = TextEditingController();
  final etDescription = TextEditingController();

  final audience = Audience.everyone.obx;
  final privacy = Privacy.everyone.obx;
  final tags = <String>[].obx;
  final photos = <EditablePhoto>[].obx;
  final deletes = <EditablePhoto>[].obx;
  final Map<int, UploadingSnapshot> _pendingSnapshots = {};

  UserPost? old;
  FeedType type = FeedType.post;

  String get title => etHeader.text;

  String get description => etDescription.text;

  bool get isUpdateMode => old != null;

  /// --------------------------------------------------------------------------
  /// BASE SECTION START
  /// --------------------------------------------------------------------------

  void _init(BuildContext context) {
    old = data?.findOrNull(key: "$UserPost");
    if (old != null) {
      id = old!.id;
      type = old?.type ?? FeedType.none;
      photos.set(old!.photos.use.map(EditablePhoto.photo).toList());
      privacy.set(Privacy.parse(old?.privacy));
    } else {
      id = KeyGenerator.generateKey(
        timeMills: Entity.generateTimeMills,
        extraKeySize: 5,
      );
      type = data.findByKey("$FeedType", defaultValue: FeedType.post);
      if (type.isPhoto) {
        _pickPhotos(data.findOrNull(key: "$EditablePhotoFeedback"));
      }
    }
    path = PathReplacer.replaceByIterable(Paths.userPost, [UserHelper.uid, id]);
    photosPath = PathReplacer.replaceByIterable(Paths.refPhotos, [path]);
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

  List<Photo> get currentPhotoUrls {
    return photos.value.map((i) => i.rootData).whereType<Photo>().toList();
  }

  List<Photo> get deletedPhotoUrls {
    return deletes.value.map((i) => i.rootData).whereType<Photo>().toList();
  }

  void _updatePosition(int previous, int current) {
    if (current > previous) current -= 1;
    final item = photos.value.removeAt(previous);
    photos.value.insert(current, item);
  }

  void _uploadPendingPhotos(BuildContext context) {
    final size = _pendingSnapshots.length;
    if (size > 0) {
      for (int i = 0; i < size; i++) {
        final item = _pendingSnapshots.entries.elementAt(i);
        final index = item.key;
        final snapshot = item.value;
        if (snapshot.url == null) continue;
        _createPhoto(
          context: context,
          index: index,
          id: snapshot.id,
          url: snapshot.url!,
        ).then((value) {
          if (value != null) {
            final x = photos.value.removeAt(index);
            photos.value.insert(index, x.copy(value));
            _pendingSnapshots.remove(index);
          } else {
            _pendingSnapshots.putIfAbsent(index, () => snapshot);
          }
          if (i == size - 1) {
            if (!context.mounted) return;
            _submit(context, _pendingSnapshots.isNotEmpty);
          }
        });
      }
    }
  }

  Future<Photo?> _createPhoto({
    required BuildContext context,
    required int index,
    required String url,
    required String id,
  }) async {
    final data = Photo.create(
      id: id,
      timeMills: Entity.generateTimeMills,
      publisher: UserHelper.uid,
      parentId: this.id,
      path: PathReplacer.replaceByIterable(Paths.refPhoto, [photosPath, id]),
      parentPath: path,
      photoUrl: url,
      privacy: privacy.value,
    );
    try {
      final value = await CreatePhotoUseCase.i(data);
      if (value.isSuccessful) return data;
      if (!context.mounted) return null;
      final resubmission = await context.showAlert(
        title: "Something went wrong!",
        message: ResponseMessages.tryAgain,
      );
      if (!resubmission || !context.mounted) return null;
      return _createPhoto(context: context, index: index, id: id, url: url);
    } catch (error) {
      if (!context.mounted) return null;
      final resubmission = await context.showAlert(
        title: "Something went wrong!",
        message: ResponseMessages.tryAgain,
      );
      if (!resubmission || !context.mounted) return null;
      return _createPhoto(context: context, index: index, id: id, url: url);
    }
  }

  Future<UploadingStatus> _upload(
    BuildContext context,
    int index,
    UploadingSnapshot snapshot,
  ) async {
    final url = snapshot.url;
    if (url == null || url.isEmpty) return UploadingStatus.error;
    return _createPhoto(
      context: context,
      index: index,
      id: snapshot.id,
      url: url,
    ).then((value) {
      if (value != null) {
        final x = photos.value.removeAt(index);
        photos.value.insert(index, x.copy(value));
        return UploadingStatus.processed;
      } else {
        _pendingSnapshots.putIfAbsent(index, () => snapshot);
        return UploadingStatus.error;
      }
    });
  }

  void _pickPhotos(Object? feedback) {
    if (feedback is EditablePhotoFeedback) {
      photos.value = feedback.currents;
      deletes.value = feedback.deletes;
    }
  }

  void _choosePhoto(BuildContext context) async {
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
  /// UPDATE SECTION START
  /// --------------------------------------------------------------------------

  void _complete(BuildContext context) {
    context.hideLoader();
    context.close();
  }

  void _deleteUrls(BuildContext context) {
    final urls = deletes.value.map((e) => e.data).whereType<String>().toList();
    if (urls.isNotEmpty) {
      StorageService.i.deletes(urls).then((value) {
        if (!context.mounted) return;
        if (value.successful) {
          _complete(context);
        } else {
          context.hideLoader();
          context.showAlert().then((value) {
            if (!context.mounted) return;
            if (value) {
              _deleteUrls(context);
            } else {
              StorageService.i.deletes(urls, lazy: true).then((_) {
                if (!context.mounted) return;
                _complete(context);
              });
            }
          });
        }
      });
    }
  }

  void _update(BuildContext context) {
    final isValidDescription = description != old!.description;
    if (photos.value.isNotEmpty || isValidDescription) {
      final photos = currentPhotoUrls;
      final isAllUploaded = photos.length == this.photos.value.length;
      if (isAllUploaded) {
        final updates = {
          Keys.i.updatedAt: Entity.generateTimeMills,
          Keys.i.description: description,
          Keys.i.photoUrls: photos,
        };
        UpdateUserPostUseCase.i(id, updates).then((value) {
          if (!context.mounted) return;
          if (value.isSuccessful) {
            _deleteUrls(context);
          } else {
            _complete(context);
          }
        });
      } else {
        context.showMessage("Please wait a second...!");
      }
    } else {
      context.showMessage("Please write something...!");
    }
  }

  /// --------------------------------------------------------------------------
  /// UPDATE SECTION END
  /// --------------------------------------------------------------------------

  /// --------------------------------------------------------------------------
  /// CREATE SECTION START
  /// --------------------------------------------------------------------------

  void _createFeedForGlobal(BuildContext context, UserPost feed) {
    final id = feed.id;
    final path = PathProvider.generatePath(Paths.feeds, id);
    final global = Feed.empty();
    // final global = Feed(
    //   id: id,
    //   timeMills: feed.timeMills,
    //   // audience: feed.audience,
    //   path: path,
    //   reference: "",
    //   publisher: '',
    //   // priority: feed.priority,
    //   // privacy: feed.privacy,
    //   // referenceId: feed.id,
    //   // referencePath: feed.path,
    // );
    CreateFeedUseCase.i(global).then((value) {
      if (!context.mounted) return;
      if (value.isSuccessful) {
        _complete(context);
      } else {
        context.hideLoader();
        context.showAlert(message: ResponseMessages.tryAgain).then((value) {
          if (!context.mounted) return;
          if (value) {
            _createFeedForGlobal(context, feed);
          } else {
            context.showMessage(ResponseMessages.postingUnsuccessful);
          }
        });
      }
    });
  }

  void _createPost(BuildContext context, UserPost feed) {
    context.showLoader();
    final mPhotos =
        photos.value.map((e) => e.rootData).whereType<Photo>().toList();
    context.read<UserPostCubit>().create(feed).then((value) {
      if (!context.mounted) return;
      if (value.isSuccessful) {
        context.read<UserPhotoCubit?>()?.add(feed..photos = mPhotos);
        _createFeedForGlobal(context, feed);
      } else {
        context.hideLoader();
        context.showAlert(message: ResponseMessages.tryAgain).then((v) {
          if (!context.mounted) return;
          if (v) {
            _createPost(context, feed);
          } else {
            context.showMessage(ResponseMessages.postingUnsuccessful);
          }
        });
      }
    });
  }

  void _create(BuildContext context) {
    if (photos.value.isEmpty && description.isEmpty) {
      context.showMessage("Please write something...!");
      return;
    }
    if (currentPhotoUrls.length != photos.value.length) {
      context.showMessage("Please wait a second...!");
      return;
    }
    final data = UserPost.create(
      id: id,
      timeMills: Entity.generateTimeMills,
      publisherId: UserHelper.uid,
      path: path,
      audience: audience.value,
      privacy: privacy.value,
      title: title.isEmpty ? null : title,
      description: description.isEmpty ? null : description,
      type: currentPhotoUrls.isNotEmpty ? FeedType.photo : null,
      tags: tags.value,
    );
    _createPost(context, data);
  }

  /// --------------------------------------------------------------------------
  /// CREATE SECTION END
  /// --------------------------------------------------------------------------

  /// --------------------------------------------------------------------------
  /// FINAL SECTION START
  /// --------------------------------------------------------------------------

  void _submit(BuildContext context, [bool skipMode = false]) {
    if (skipMode) return;
    if (_pendingSnapshots.isEmpty) {
      if (isUpdateMode) {
        _update(context);
      } else {
        _create(context);
      }
    } else {
      _uploadPendingPhotos(context);
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
    deletes.dispose();
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
          titleText:
              isUpdateMode ? "Update memorable story" : "Add a memorable story",
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
          elevationColor: dark.t05,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
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
                            (context, value) => _upload(context, index, value),
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
              AndrossyField(
                contentPadding: EdgeInsets.all(24),
                text: old?.description,
                hintText: "Write a note...",
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
          log(status.name);
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
    if (data is Photo) {
      return InAppUploadingImage(data: data.photoUrl);
    }
    return const SizedBox.shrink();
  }
}
