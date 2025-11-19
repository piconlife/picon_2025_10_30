import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:auth_management/core.dart';
import 'package:auth_management/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/spacing.dart';
import 'package:flutter_andomie/utils/path_replacer.dart';
import 'package:flutter_andomie/utils/validator.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:flutter_androssy_kits/widgets.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_navigator/in_app_navigator.dart';
import 'package:object_finder/object_finder.dart';
import 'package:picon/data/models/user_post.dart';
import 'package:picon/roots/widgets/gesture.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/helpers/user.dart';
import '../../../../app/interfaces/bsd_privacy.dart';
import '../../../../app/interfaces/dialog_alert.dart';
import '../../../../app/res/icons.dart';
import '../../../../app/res/labels.dart';
import '../../../../app/res/msg.dart';
import '../../../../data/constants/paths.dart';
import '../../../../data/enums/content_state.dart';
import '../../../../data/enums/feed_type.dart';
import '../../../../data/enums/privacy.dart';
import '../../../../data/models/feed.dart';
import '../../../../data/models/user.dart';
import '../../../../data/models/user_avatar.dart';
import '../../../../roots/contents/media.dart';
import '../../../../roots/helpers/connectivity.dart';
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
import '../../../social/data/cubits/feed_home_cubit.dart';
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

  late final feedCubit = DataCubit.of<FeedHomeCubit>(context);
  late final postCubit = DataCubit.of<UserPostCubit>(context);
  late final avatarCubit = DataCubit.of<UserAvatarCubit>(context);

  final etText = TextEditingController();
  final btnNext = GlobalKey<InAppFilledButtonState>();

  final loading = ValueNotifier(false);
  final privacy = ValueNotifier(Privacy.everyone);
  final feed = ValueNotifier(true);

  User user = User();
  String? photoUrl;
  late String id = Entity.generateID;

  bool get isValidUrl => photoUrl.isValidWebUrl;

  void _changePrivacy() async {
    if (!mounted) return;
    final value = await PrivacyBSD.show(context, privacy.value);
    privacy.value = value;
  }

  void _fetchUser() async {
    final value = await UserHelper.get();
    user = value;
  }

  Future<bool> _delete([bool skipMode = false]) async {
    if (!isValidUrl) {
      if (skipMode) _next();
      return false;
    }
    final permission = await context.showAlert(
      title: "Are you sure remove this profile picture?",
      content: const AlertDialogContent(
        positiveButtonText: ActionNames.yes,
        negativeButtonText: ActionNames.no,
      ),
    );

    if (!permission || !mounted) return false;

    loading.value = true;
    btnNext.currentState?.setEnabled(false);
    final response = await StorageService.i.delete(photoUrl!);
    if (!mounted) return false;
    if (!response.successful) {
      btnNext.currentState?.setEnabled(true);
      final permission = await context.showAlert(
        title: ResponseMessages.tryAgain,
        content: const AlertDialogContent(
          positiveButtonText: ActionNames.tryAgain,
          negativeButtonText: ActionNames.cancel,
        ),
      );
      if (!mounted) return false;
      if (permission) {
        return _delete(skipMode);
      } else {
        if (skipMode) _next();
        return false;
      }
    }

    photoUrl = null;
    loading.value = false;
    if (skipMode) _next();
    return true;
  }

  void _upload(MediaData? data) {
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

  void _skip() => _delete(true);

  void _submit() {
    _update();
  }

  void _update() async {
    if (!isValidUrl) {
      context.showWarningSnackBar("User profile photo isn't valid!");
      return;
    }

    context.showLoader();
    if (await ConnectivityHelper.isDisconnected) {
      if (!mounted) return;
      context.hideLoader();
      context.showWarningSnackBar(ResponseMessages.internetDisconnected);
      return;
    }

    if (!mounted) return;
    final updateAccountResponse = await context.updateAccount<User>({
      UserKeys.i.photo: photoUrl,
    });
    if (!mounted) return;

    if (updateAccountResponse == null) {
      context.hideLoader();
      final permission = await InAppAlertDialog.show(
        context,
        title: ResponseMessages.tryAgain,
        positiveButtonText: ActionNames.tryAgain,
        negativeButtonText: ActionNames.cancel,
      );

      if (!mounted) return;
      if (!permission) {
        _delete();
        return;
      }

      _update();
      return;
    }

    _create();
  }

  void _create() {
    if (!isValidUrl || !user.isCurrentUser) {
      context.hideLoader();
      context.showErrorSnackBar("User not active now!");
      return;
    }

    final mPublisherId = UserHelper.uid;
    final mTimeMills = Entity.generateTimeMills;

    final mAvatar = UserAvatar.create(
      id: id,
      timeMills: mTimeMills,
      description: etText.text.isNotEmpty ? etText.text : null,
      photoUrl: photoUrl,
      privacy: privacy.value,
    );

    final mUserPost = UserPost.createForAvatar(
      id: id,
      timeMills: mTimeMills,
      publisherId: mPublisherId,
      content: mAvatar,
    );

    final mFeed = Feed.create(
      id: id,
      timeMills: mTimeMills,
      publisher: user,
      path: Paths.feeds,
      type: FeedType.avatar,
      content: mUserPost,
    );

    feedCubit.create(
      mFeed,
      placement: "create_avatar",
      replace: (e) => e..uiState = ContentUiState.processed,
      onPut: () {
        postCubit.add(mUserPost, 0);
        avatarCubit.add(mAvatar, 0);
      },
      onCreated: () {
        postCubit.replace(mUserPost, (e) {
          return e..uiState = ContentUiState.processed;
        });
        avatarCubit.replace(mAvatar, (e) {
          return e..uiState = ContentUiState.processed;
        });
        if (mounted) context.hideLoader();
        _next();
        Toast.show(Msg.postingDone);
      },
      onFailed: () {
        postCubit.remove(mUserPost);
        avatarCubit.remove(mAvatar);
        if (mounted) context.hideLoader(true);
        Toast.show(Msg.postFailed);
      },
    );
  }

  void _next() {
    if (!mounted) return;
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
              onTap: _skip,
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
                          imageChosen: (c, v) => _upload(v),
                          imageRemove: (c) => _delete(),
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
                      onTap: _changePrivacy,
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
                      onTap: _submit,
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
