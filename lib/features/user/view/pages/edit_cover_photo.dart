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
import '../../../../data/models/user_cover.dart';
import '../../../../data/models/user_post.dart';
import '../../../../data/use_cases/feed/create.dart';
import '../../../../roots/contents/media.dart';
import '../../../../roots/helpers/connectivity.dart';
import '../../../../roots/services/path_provider.dart';
import '../../../../roots/services/storage.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/bottom_bar.dart';
import '../../../../roots/widgets/filled_button.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/padding.dart';
import '../../../../roots/widgets/row.dart';
import '../../../../roots/widgets/screen.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../roots/widgets/texted_action.dart';
import '../../../../routes/keys.dart';
import '../../../../routes/paths.dart';
import '../cubits/cover_cubit.dart';
import '../cubits/post_cubit.dart';
import '../widgets/edit_cover.dart';

class EditUserCoverPhotoPage extends StatefulWidget {
  final Object? args;

  const EditUserCoverPhotoPage({super.key, this.args});

  @override
  State<EditUserCoverPhotoPage> createState() => _EditUserCoverPhotoPageState();
}

class _EditUserCoverPhotoPageState extends State<EditUserCoverPhotoPage> {
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
      title: "Are you sure remove this cover photo?",
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

    final path = PathReplacer.replaceByIterable(Paths.userCovers, [
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
      context.showWarningSnackBar("User cover photo isn't valid!");
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
      UserKeys.i.coverPhoto: photoUrl,
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
    _createCover(
      context,
      UserCover(
        id: id,
        timeMills: Entity.generateTimeMills,
        description: etText.text.isNotEmpty ? etText.text : null,
        photo: photoUrl,
        privacy: privacy.value,
        publisher: user.id,
        path: PathReplacer.replaceByIterable(
          PathProvider.generatePath(Paths.userCovers, id),
          [UserHelper.uid],
        ),
      ),
    );
  }

  void _createCover(BuildContext context, UserCover data) async {
    final feedback = await context.read<UserCoverCubit>().putAsync(data);
    if (!context.mounted) return;
    if (!feedback) {
      context.hideLoader();
      final permission = await context.showAlert(
        message: ResponseMessages.tryAgain,
      );
      if (!context.mounted) return;
      if (!permission) return _next(context);
      return _createCover(context, data);
    }

    _createFeedForUser(
      context,
      data,
      UserPost.createForCover(
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
    UserCover cover,
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
      return _createFeedForUser(context, cover, data);
    }

    _createFeedForGlobal(
      context,
      cover,
      Feed.create(
        id: cover.id,
        timeMills: Entity.generateTimeMills,
        publisher: user,
        path: Paths.feeds,
        content: null,
        type: FeedType.cover,
      ),
    );
  }

  void _createFeedForGlobal(
    BuildContext context,
    UserCover cover,
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
        return _createFeedForGlobal(context, cover, data);
      }
    }
    context.hideLoader();
    _next(context);
  }

  void _next(BuildContext context) {
    InAppNavigator.setVisitor(Routes.editUserCoverPhoto);
    if (!isOnboardingMode) {
      context.close();
      return;
    }
    if (InAppNavigator.isNotVisited(Routes.editUserPrimaryAddress)) {
      context.clear(
        Routes.editUserPrimaryAddress,
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
        backgroundColor: Colors.transparent,
        appBar: InAppAppbar(
          titleText: "Update cover",
          actions: [
            InAppTextedAction(
              isOnboardingMode ? "Skip" : "Cancel",
              onTap: () => _skip(context),
            ),
          ],
        ),
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
        body: ListView(
          children: [
            AuthConsumer<User>(
              builder: (context, user) {
                return ValueListenableBuilder(
                  valueListenable: loading,
                  builder: (context, value, child) {
                    return EditableCover(
                      loading: value,
                      isAlreadyUploaded: isValidUrl,
                      image: photoUrl ?? user?.coverPhoto,
                      imageChosen: _upload,
                      imageRemove: _delete,
                    );
                  },
                );
              },
            ),
            dimen.dp(24).h,
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
              padding: EdgeInsets.all(dimen.dp(32)),
              child: Column(
                children: [
                  InAppText(
                    "Select your cover photo",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.dark,
                      fontSize: dimen.dp(20),
                    ),
                  ),
                  dimen.dp(8).h,
                  InAppText(
                    "Please choose a background cover picture. Because, it will be your profile background cover picture.",
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
    );
  }
}
