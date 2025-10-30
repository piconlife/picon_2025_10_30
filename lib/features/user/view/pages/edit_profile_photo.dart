import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:auth_management/core.dart';
import 'package:auth_management/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:flutter_androssy_kits/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_navigator/in_app_navigator.dart';
import 'package:object_finder/object_finder.dart';
import 'package:picon/data/models/user_post.dart';
import 'package:picon/roots/widgets/gesture.dart';

import '../../../../app/helpers/user.dart';
import '../../../../app/interfaces/bsd_privacy.dart';
import '../../../../app/interfaces/dialog_alert.dart';
import '../../../../app/res/icons.dart';
import '../../../../app/res/labels.dart';
import '../../../../data/constants/paths.dart';
import '../../../../data/enums/feed_type.dart';
import '../../../../data/enums/privacy.dart';
import '../../../../data/models/feed.dart';
import '../../../../data/models/user.dart';
import '../../../../data/models/user_avatar.dart';
import '../../../../data/use_cases/feed/create.dart';
import '../../../../roots/contents/media.dart';
import '../../../../roots/helpers/connectivity.dart';
import '../../../../roots/services/path_provider.dart';
import '../../../../roots/services/storage.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/bottom_bar.dart';
import '../../../../roots/widgets/column.dart';
import '../../../../roots/widgets/filled_button.dart';
import '../../../../roots/widgets/padding.dart';
import '../../../../roots/widgets/row.dart';
import '../../../../roots/widgets/screen.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../roots/widgets/texted_action.dart';
import '../../../../routes/keys.dart';
import '../../../../routes/paths.dart';
import '../cubits/avatar_cubit.dart';
import '../cubits/post_cubit.dart';
import '../widgets/edit_avatar.dart';

class EditUserProfilePhotoPage extends StatefulWidget {
  final Object? args;

  const EditUserProfilePhotoPage({super.key, this.args});

  @override
  State<EditUserProfilePhotoPage> createState() {
    return _EditUserProfilePhotoPageState();
  }
}

class _EditUserProfilePhotoPageState extends State<EditUserProfilePhotoPage> {
  late bool isOnboardingMode = widget.args.find(
    key: kRouteOnboardingMode,
    defaultValue: false,
  );

  final etText = TextEditingController();
  final btnNext = GlobalKey<InAppFilledButtonState>();

  final loading = ValueNotifier(false);
  final privacy = ValueNotifier(Privacy.everyone);
  final feed = ValueNotifier(true);

  User user = User();
  String? photoUrl;
  late String id = Entity.generateID;

  bool get isValidUrl => photoUrl.isValidWebUrl;

  void _changePrivacy(BuildContext context) async {
    final value = await PrivacyBSD.show(context, privacy.value);
    privacy.value = value;
  }

  void _fetchUser() async {
    final value = await UserHelper.get();
    user = value;
  }

  Future<bool> _delete(BuildContext context, [bool skipMode = false]) async {
    if (!isValidUrl) {
      if (skipMode) _next(context);
      return false;
    }
    final permission = await context.showAlert(
      title: "Are you sure remove this profile picture?",
      content: const AlertDialogContent(
        positiveButtonText: ActionNames.yes,
        negativeButtonText: ActionNames.no,
      ),
    );

    if (!permission || !context.mounted) return false;

    loading.value = true;
    btnNext.currentState?.setEnabled(false);
    final response = await StorageService.i.delete(photoUrl!);
    if (!context.mounted) return false;
    if (!response.successful) {
      btnNext.currentState?.setEnabled(true);
      final permission = await context.showAlert(
        title: ResponseMessages.tryAgain,
        content: const AlertDialogContent(
          positiveButtonText: ActionNames.tryAgain,
          negativeButtonText: ActionNames.cancel,
        ),
      );
      if (!context.mounted) return false;
      if (permission) {
        return _delete(context, skipMode);
      } else {
        if (skipMode) _next(context);
        return false;
      }
    }

    photoUrl = null;
    loading.value = false;
    if (skipMode) _next(context);
    return true;
  }

  void _upload(BuildContext context, MediaData? data) {
    if (data == null) {
      context.showWarningSnackBar("File not found!");
      return;
    }

    final path = PathReplacer.replaceByIterable(Paths.userAvatars, [
      UserHelper.uid,
    ]);
    loading.value = true;
    StorageService.i.upload(
      path,
      UploadingFile(
        data: data.bytes,
        extension: data.extension ?? "",
        filename: "$id.${data.extension ?? "jpg"}",
        tag: id,
      ),
      onLoading: (event) => loading.value = event.value,
      onError: (event) => context.showErrorSnackBar(event.value),
      onNetworkError: (event) {
        context.showErrorSnackBar(ResponseMessages.internetDisconnected);
      },
      onCanceled: (event) {
        context.showErrorSnackBar(ResponseMessages.processCanceled);
      },
      onPaused: (event) {
        context.showErrorSnackBar(ResponseMessages.processPaused);
      },
      onDone: (event) {
        photoUrl = event.value;
        loading.value = false;
        btnNext.currentState?.setEnabled(isValidUrl);
      },
    );
  }

  void _skip(BuildContext context) => _delete(context, true);

  void _submit(BuildContext context) {
    _update(context);
  }

  void _update(BuildContext context) async {
    if (!isValidUrl) {
      context.showWarningSnackBar("User profile photo isn't valid!");
      return;
    }

    context.showLoader();
    if (await ConnectivityHelper.isDisconnected) {
      if (!context.mounted) return;
      context.hideLoader();
      context.showWarningSnackBar(ResponseMessages.internetDisconnected);
      return;
    }

    if (!context.mounted) return;
    final updateAccountResponse = await context.updateAccount<User>({
      UserKeys.i.photo: photoUrl,
    });
    if (!context.mounted) return;

    if (updateAccountResponse == null) {
      context.hideLoader();
      final permission = await InAppAlertDialog.show(
        context,
        title: ResponseMessages.tryAgain,
        positiveButtonText: ActionNames.tryAgain,
        negativeButtonText: ActionNames.cancel,
      );

      if (!context.mounted) return;
      if (!permission) {
        _delete(context);
        return;
      }

      _update(context);
      return;
    }

    _create(context);
  }

  void _create(BuildContext context) {
    if (!isValidUrl || !user.isCurrentUser) {
      context.hideLoader();
      context.showErrorSnackBar("User not active now!");
      return;
    }
    _createAvatar(
      context,
      UserAvatar(
        id: id,
        timeMills: Entity.generateTimeMills,
        description: etText.text.isNotEmpty ? etText.text : null,
        photo: photoUrl,
        privacy: privacy.value,
        publisher: user.id,
        path: PathReplacer.replaceByIterable(
          PathProvider.generatePath(Paths.userAvatars, id),
          [UserHelper.uid],
        ),
      ),
    );
  }

  void _createAvatar(BuildContext context, UserAvatar data) async {
    final feedback = await context.read<UserAvatarCubit>().putAsync(data);
    if (!context.mounted) return;
    if (!feedback) {
      context.hideLoader();
      final permission = await context.showAlert(
        message: ResponseMessages.tryAgain,
      );
      if (!context.mounted) return;
      if (!permission) return _next(context);
      return _createAvatar(context, data);
    }

    _createFeedForUser(
      context,
      data,
      UserPost.createForAvatar(
        id: data.id,
        timeMills: Entity.generateTimeMills,
        publisherId: data.publisher,
        path: PathReplacer.replaceByIterable(
          PathProvider.generatePath(Paths.userPosts, data.id),
          [UserHelper.uid],
        ),
      ),
    );
  }

  void _createFeedForUser(
    BuildContext context,
    UserAvatar avatar,
    UserPost data,
  ) async {
    final feedback = await context.read<UserPostCubit>().putAsync(data);
    if (!context.mounted) return;
    if (!feedback) {
      context.hideLoader();
      final permission = await context.showAlert(
        message: ResponseMessages.tryAgain,
      );
      if (!context.mounted) return;
      if (!permission) return _next(context);
      return _createFeedForUser(context, avatar, data);
    }

    _createFeedForGlobal(
      context,
      avatar,
      Feed.create(
        id: avatar.id,
        timeMills: Entity.generateTimeMills,
        publisher: user,
        path: Paths.feeds,
        content: null,
        type: FeedType.avatar,
      ),
    );
  }

  void _createFeedForGlobal(
    BuildContext context,
    UserAvatar avatar,
    Feed data,
  ) async {
    if (feed.value) {
      final feedback = await CreateFeedUseCase.i(data);
      if (!context.mounted) return;
      if (!feedback.isSuccessful) {
        context.hideLoader();
        final permission = await context.showAlert(
          message: ResponseMessages.tryAgain,
        );
        if (!context.mounted) return;
        if (!permission) {
          context.showMessage(ResponseMessages.postingUnsuccessful);
          return;
        }
        return _createFeedForGlobal(context, avatar, data);
      }
    }
    context.hideLoader();
    _next(context);
  }

  void _next(BuildContext context) {
    InAppNavigator.setVisitor(Routes.editUserProfilePhoto);
    if (!isOnboardingMode) {
      context.close();
      return;
    }
    if (InAppNavigator.isNotVisited(Routes.editUserCoverPhoto)) {
      context.clear(
        Routes.editUserCoverPhoto,
        arguments: {kRouteOnboardingMode: isOnboardingMode},
      );
      return;
    }
    context.clear(Routes.main);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchUser());
  }

  @override
  void dispose() {
    etText.dispose();
    feed.dispose();
    loading.dispose();
    privacy.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.primary;
    final dimen = context.dimens;
    return InAppScreen(
      unfocusMode: true,
      theme: ThemeType.secondary,
      child: Scaffold(
        appBar: InAppAppbar(
          titleText: "Update profile photo",
          actions: [
            InAppTextedAction(
              isOnboardingMode ? "Skip" : "Cancel",
              onTap: () => _skip(context),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        bottomNavigationBar: InAppBottomBar.minimalist(
          elevation: 0.5,
          child: ValueListenableBuilder(
            valueListenable: feed,
            builder: (context, value, child) {
              return InAppGesture(
                onTap: () => feed.value = !feed.value,
                scalerLowerBound: 1,
                child: ColoredBox(
                  color: Colors.transparent,
                  child: InAppPadding(
                    padding: EdgeInsets.only(left: 32, right: 16),
                    child: InAppRow(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InAppText(
                          "Upload to feed",
                          style: TextStyle(fontSize: 16),
                        ),
                        Checkbox(
                          value: value,
                          onChanged: (v) => feed.value = v ?? feed.value,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: InAppColumn(
            children: [
              dimen.dp(40).h,
              Center(
                child: AuthConsumer<User>(
                  builder: (context, user) {
                    return ValueListenableBuilder(
                      valueListenable: loading,
                      builder: (context, value, child) {
                        return EditableAvatar(
                          isUploading: value,
                          isAlreadyUploaded: isValidUrl,
                          image: photoUrl ?? user?.photo,
                          imageChosen: _upload,
                          imageRemove: _delete,
                        );
                      },
                    );
                  },
                ),
              ),
              dimen.dp(48).h,
              Center(
                child: ValueListenableBuilder(
                  valueListenable: privacy,
                  builder: (context, value, child) {
                    return AndrossyButton(
                      primary: primary,
                      clickEffect: AndrossyGestureEffect.scale(),
                      text: value.label,
                      textSize: dimen.dp(16),
                      textColor: const AndrossyButtonProperty.all(Colors.white),
                      icon: InAppIcons.shieldCheck.solid,
                      iconOrIndicatorAlignment: IconAlignment.start,
                      iconColor: const AndrossyButtonProperty.all(Colors.white),
                      padding: EdgeInsets.only(
                        left: dimen.dp(8),
                        top: dimen.dp(8),
                        bottom: dimen.dp(8),
                        right: dimen.dp(16),
                      ),
                      iconOrIndicatorSpace: dimen.dp(8),
                      borderRadius: BorderRadius.circular(dimen.dp(25)),
                      onTap: () => _changePrivacy(context),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: dimen.dp(32),
                  right: dimen.dp(32),
                  top: dimen.dp(32),
                ),
                child: Column(
                  children: [
                    InAppText(
                      "Select your profile photo",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.dark,
                        fontSize: dimen.dp(20),
                      ),
                    ),
                    dimen.dp(8).h,
                    InAppText(
                      "Please choose a picture. Because, it will be your profile picture.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: dimen.dp(14),
                      ),
                    ),
                    dimen.dp(24).h,
                    AndrossyField(
                      controller: etText,
                      hintText: "Write something…",
                      textAlign: TextAlign.center,
                      hintColor: context.dark.t30,
                      underlineColor: AndrossyFieldProperty(
                        enabled: context.dark.t10,
                        focused: primary,
                      ),
                    ),
                    dimen.dp(24).h,
                    InAppFilledButton(
                      key: btnNext,
                      enabled: isValidUrl,
                      width: double.infinity,
                      borderRadius: BorderRadius.circular(dimen.dp(24)),
                      height: dimen.dp(45),
                      text: isOnboardingMode ? "Next" : "Upload",
                      onTap: () => _submit(context),
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
