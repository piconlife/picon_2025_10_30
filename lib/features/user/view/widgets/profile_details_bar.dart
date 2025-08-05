import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:flutter_androssy_kits/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/dialogs/dialog_big_photo.dart';
import '../../../../app/helpers/user.dart';
import '../../../../app/res/icons.dart';
import '../../../../app/res/placeholders.dart';
import '../../../../app/styles/fonts.dart';
import '../../../../data/models/user.dart';
import '../../../../data/models/user_avatar.dart';
import '../../../../data/models/user_cover.dart';
import '../../../../roots/widgets/avatar.dart';
import '../../../../roots/widgets/button.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/icon_button.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../roots/widgets/user_builder.dart';
import '../../../../routes/paths.dart';
import '../../../social/view/dialogs/bsd_feed_format.dart';
import '../../utils/user_updater.dart';
import '../cubits/avatar_cubit.dart';
import '../cubits/cover_cubit.dart';
import '../cubits/follower_counter_cubit.dart';
import '../cubits/photo_cubit.dart';
import '../cubits/post_counter_cubit.dart';
import '../cubits/post_cubit.dart';
import '../cubits/report_counter_cubit.dart';
import '../dialogs/bsd_user_profile_avatars.dart';
import '../dialogs/bsd_user_profile_covers.dart';
import '../dialogs/bsd_user_profile_rating.dart';

class ProfileDetailsBar extends StatefulWidget {
  final User? user;
  final String? uid;

  const ProfileDetailsBar({super.key, this.user, required this.uid});

  @override
  State<ProfileDetailsBar> createState() => _ProfileDetailsBarState();
}

class _ProfileDetailsBarState extends State<ProfileDetailsBar> {
  void _editCoverPhoto(BuildContext context, User user) async {
    final option = await context.showOptions(
      initialIndex: -1,
      title: "Choose action",
      options: ["Update", "Change", "Remove"],
    );
    if (!context.mounted) return;
    if (option == 0) {
      context.open(
        Routes.editUserCoverPhoto,
        arguments: {"$UserCoverCubit": context.read<UserCoverCubit>()},
      );
    } else if (option == 1) {
      _loadCoverPhotos(context, user);
    } else if (option == 2) {
      _changeCoverPhoto(context);
    }
  }

  void _changeCoverPhoto(BuildContext context, [String? url]) {
    UserHelper.update(context, {UserKeys.i.coverPhoto: url});
  }

  void _loadCoverPhotos(BuildContext context, User user) {
    UserProfileCoversBSD.show(context, user).then((value) {
      if (value is UserCover && context.mounted) {
        _changeCoverPhoto(context, value.photoUrl);
      }
    });
  }

  void _editAvatar(BuildContext context, User user) async {
    final option = await context.showOptions(
      initialIndex: -1,
      title: "Choose action",
      options: ["Update", "Change", "Remove"],
    );
    if (!context.mounted) return;
    if (option == 0) {
      context.open(
        Routes.editUserProfilePhoto,
        arguments: {"$UserAvatarCubit": context.read<UserAvatarCubit>()},
      );
    } else if (option == 1) {
      _loadAvatars(context, user);
    } else if (option == 2) {
      _changeAvatar(context);
    }
  }

  void _changeAvatar(BuildContext context, [String? url]) {
    UserHelper.update(context, {UserKeys.i.photo: url});
  }

  void _loadAvatars(BuildContext context, User user) async {
    UserProfileAvatarsBSD.show(context, user).then((value) {
      if (value is UserAvatar && context.mounted) {
        _changeAvatar(context, value.photoUrl);
      }
    });
  }

  void _editProfileName(BuildContext context, User user) async {
    final updater = UserInfoUpdater(context, user);
    return updater.updateFullname("Family name");
  }

  void _editTitle(BuildContext context, User user) async {
    final updater = UserInfoUpdater(context, user);
    return updater.updateTitle("Title");
  }

  void _editBio(BuildContext context, User user) async {
    final updater = UserInfoUpdater(context, user);
    return updater.updateBiography("Biography");
  }

  void _createPost(BuildContext context) async {
    final value = await InAppFeedFormatBSD.show(context);
    if (!context.mounted) return;
    if (value == FeedFormats.memory) {
      context.open(Routes.createAMemory);
      return;
    }
    if (value == FeedFormats.note) {
      context.open(Routes.createANote);
      return;
    }
    if (value == FeedFormats.post) {
      context.open(
        Routes.createUserPost,
        arguments: {
          "$UserPostCubit": context.read<UserPostCubit>(),
          "$UserPhotoCubit": context.read<UserPhotoCubit>(),
          "$UserPostCounterCubit": context.read<UserPostCounterCubit>(),
        },
      );
      return;
    }
    if (value == FeedFormats.video) {
      context.open(Routes.createAVideo);
      return;
    }
  }

  void _createStory(BuildContext context) {
    context.open(Routes.createAStory);
  }

  void _makeACall(BuildContext context, User user) {
    if (user.isCurrentUser) {
      context.open(Routes.callingHome, arguments: widget.uid);
    } else if (user.calling.use) {
      context.open(Routes.callingCall, arguments: widget.uid);
    }
  }

  void _makeAConversation(BuildContext context, User user) {
    if (user.isCurrentUser) {
      context.open(Routes.messagingChat, arguments: widget.uid);
    } else if (user.messaging.use) {
      context.open(Routes.messagingInbox, arguments: widget.uid);
    }
  }

  void _makeAReport(BuildContext context) {}

  void _makeAFollower(BuildContext context, bool following) {}

  void _seeCoverPhoto(BuildContext context, User user) {
    if (user.coverPhoto == null || user.coverPhoto!.isEmpty) return;
    InAppBigPhotoDialog.show(context, user.coverPhoto);
  }

  void _seeProfileStatus(BuildContext context, User user) {
    UserProfileRatingBSD.show(context, user);
  }

  void _seeProfilePhoto(BuildContext context, User user) {
    if (user.avatar == null || user.avatar!.isEmpty) return;
    InAppBigPhotoDialog.show(context, user.avatar);
  }

  void _seePosts(BuildContext context, User user) {
    context.open(
      Routes.userFeeds,
      arguments: {
        "$User": user,
        "$UserPostCubit": context.read<UserPostCubit>(),
      },
    );
  }

  void _seeFollowers(BuildContext context, User user) {
    context.open(Routes.userFollowers, arguments: {"$User": user});
  }

  void _seeFollowings(BuildContext context, User user) {
    context.open(Routes.userFollowings, arguments: {"$User": user});
  }

  void _seeReports(BuildContext context, User user) {
    context.open(Routes.userReports, arguments: {"$User": user});
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    final light = context.light;
    return InAppUserBuilder(
      initial: widget.user,
      builder: (context, user) {
        final isCurrentUser = user.isCurrentUser;
        final isFollowing =
            !isCurrentUser &&
            Validator.isChecked(user.id, UserHelper.followings);
        final isCalling = user.calling.use;
        final isRatedUser = user.isRatedUser;
        final isMessaging = user.messaging.use;

        final primary = context.primary;

        return ColoredBox(
          color: context.scaffoldColor.primary ?? Colors.transparent,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    InAppGesture(
                      scalerLowerBound: 1,
                      onTap: () => _seeCoverPhoto(context, user),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: (user.coverPhoto ?? user.photo ?? '').isEmpty
                              ? Colors.grey
                              : null,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(dimen.dp(25)),
                            topRight: Radius.circular(dimen.dp(25)),
                          ),
                        ),
                        foregroundDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [light.t01, light.t05, light],
                          ),
                        ),
                        child: InAppImage(
                          user.coverPhoto ??
                              user.photo ??
                              InAppPlaceholders.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (isCurrentUser)
                      Positioned(
                        top: dimen.dp(16),
                        right: dimen.dp(16),
                        child: InAppIconButton(
                          InAppIcons.nativeEdit.regular,
                          size: dimen.dp(40),
                          primaryColor: Colors.black.t10,
                          iconColor: Colors.white,
                          onTap: () => _editCoverPhoto(context, user),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(bottom: dimen.dp(16)),
                      child: InAppAvatar(
                        user.avatar,
                        fadeLowerBound: 1,
                        size: dimen.dp(160),
                        borderSize: dimen.dp(4),
                        borderColor: Colors.white,
                        onTap: () => _seeProfilePhoto(context, user),
                      ),
                    ),
                    Positioned(
                      bottom: isRatedUser ? 0 : dimen.dp(8),
                      child: isRatedUser
                          ? InAppIconButton(
                              user.isHeartUser
                                  ? InAppIcons.heart.solid
                                  : InAppIcons.star.solid,
                              size: dimen.dp(40),
                              iconScale: 1.2,
                              primaryColor: user.isCelebrityUser
                                  ? context.yellow
                                  : context.red,
                              iconColor: Colors.white,
                              onTap: () => _seeProfileStatus(context, user),
                            )
                          : InAppButton(
                              height: dimen.dp(30),
                              width: dimen.dp(50),
                              fadeLowerBound: 1,
                              borderRadius: BorderRadius.circular(dimen.dp(25)),
                              text: user.rating.toStringAsFixed(1),
                              backgroundColor: Colors.white,
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: dimen.mediumFontWeight,
                                fontSize: dimen.dp(16),
                              ),
                              elevation: 2,
                              elevationColor: dark.t25,
                              onTap: () => _seeProfileStatus(context, user),
                            ),
                    ),
                  ],
                ),
              ),
              dimen.dp(16).h,
              InAppButton(
                scalerLowerBound: 1,
                backgroundColor: isFollowing ? primary.t10 : primary,
                text: isCurrentUser
                    ? "Edit"
                    : isFollowing
                    ? "Following"
                    : "Follow",
                textAllCaps: true,
                textStyle: TextStyle(
                  color: isFollowing ? primary : Colors.white,
                  fontSize: dimen.dp(14),
                  fontWeight: FontWeight.bold,
                  fontFamily: InAppFonts.secondary,
                ),
                onTap: isCurrentUser ? () => _editAvatar(context, user) : null,
                onToggle: !isCurrentUser
                    ? (value) => _makeAFollower(context, value)
                    : null,
                minWidth: 100,
                padding: EdgeInsets.symmetric(
                  horizontal: dimen.dp(16),
                  vertical: dimen.dp(8),
                ),
                borderRadius: BorderRadius.circular(dimen.dp(25)),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(dimen.dp(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InAppGesture(
                      onTap: isCurrentUser
                          ? () => _editProfileName(context, user)
                          : null,
                      child: Padding(
                        padding: EdgeInsets.all(dimen.dp(4)),
                        child: InAppText(
                          user.name ??
                              (isCurrentUser
                                  ? "Add your family name"
                                  : user.username ?? "Unknown"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: user.name.isNotValid ? dark.t50 : dark,
                            fontWeight: dimen.boldFontWeight,
                            fontSize: dimen.dp(24),
                          ),
                        ),
                      ),
                    ),
                    if (isCurrentUser || user.title.isValid)
                      InAppGesture(
                        onTap: isCurrentUser
                            ? () => _editTitle(context, user)
                            : null,
                        child: Padding(
                          padding: EdgeInsets.all(dimen.dp(4)),
                          child: InAppText(
                            user.title ?? "Add your title",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: user.title.isValid && isCurrentUser
                                  ? dark.t50
                                  : dark.t75,
                              fontWeight: dimen.mediumFontWeight,
                              fontSize: dimen.dp(16),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    if ((isCurrentUser || user.biography.isValid))
                      InAppGesture(
                        onTap: isCurrentUser
                            ? () => _editBio(context, user)
                            : null,
                        child: Padding(
                          padding: EdgeInsets.all(dimen.dp(4)),
                          child: InAppText(
                            user.biography ?? "Create your Biography",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: dark.t50,
                              fontSize: dimen.dp(14),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(dimen.dp(16)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BlocBuilder<UserReportCounterCubit, Response<int>>(
                      builder: (context, response) {
                        return _Counter(
                          text: "Reports",
                          primary: primary,
                          counter: response.data.toReadableNumber.text,
                          onClick: () => _seeReports(context, user),
                        );
                      },
                    ),
                    BlocBuilder<UserPostCounterCubit, Response<int>>(
                      builder: (context, response) {
                        return _Counter(
                          text: "Feeds",
                          primary: primary,
                          counter: response.data.toReadableNumber.text,
                          onClick: () => _seePosts(context, user),
                        );
                      },
                    ),
                    BlocBuilder<UserFollowerCounterCubit, Response<int>>(
                      builder: (context, response) {
                        return _Counter(
                          text: "Followers",
                          primary: primary,
                          counter: response.data.toReadableNumber.text,
                          onClick: () => _seeFollowers(context, user),
                        );
                      },
                    ),
                    BlocBuilder<UserFollowerCounterCubit, Response<int>>(
                      builder: (context, response) {
                        return _Counter(
                          text: "Followings",
                          primary: primary,
                          counter: response.data.toReadableNumber.text,
                          onClick: () => _seeFollowings(context, user),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: dimen.dp(50),
                margin: EdgeInsets.symmetric(horizontal: dimen.dp(16)),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: primary.t10,
                  borderRadius: BorderRadius.circular(dimen.dp(10)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (isCurrentUser)
                      _Button(
                        icon: InAppIcons.camera.solid,
                        primary: primary,
                        onClick: () => _createStory(context),
                      ),
                    if (isCurrentUser)
                      _Button(
                        icon: InAppIcons.editNote.solid,
                        primary: primary,
                        onClick: () => _createPost(context),
                      ),
                    if (isCurrentUser || isCalling)
                      _Button(
                        icon: InAppIcons.phone.solid,
                        primary: primary,
                        onClick: () => _makeACall(context, user),
                      ),
                    if (isCurrentUser || isMessaging)
                      _Button(
                        icon: InAppIcons.message.solid,
                        primary: primary,
                        onClick: () => _makeAConversation(context, user),
                      ),
                    if (!isCurrentUser)
                      _Button(
                        icon: InAppIcons.feedback.solid,
                        primary: primary,
                        onClick: () => _makeAReport(context),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Counter extends StatelessWidget {
  final Color? primary;
  final String text;
  final String counter;
  final VoidCallback? onClick;

  const _Counter({
    this.primary,
    required this.text,
    required this.counter,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final dimen = DimenData.from(context.scaffoldWidth, context.scaffoldHeight);
    return Expanded(
      child: AndrossyGesture(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        clickEffect: AndrossyGestureEffect.scale(),
        onTap: onClick,
        child: Center(
          child: Column(
            children: [
              InAppText(
                counter,
                style: TextStyle(
                  fontSize: dimen.dp(18),
                  fontWeight: dimen.boldFontWeight,
                ),
              ),
              InAppText(
                text,
                style: TextStyle(
                  color: primary ?? context.primary,
                  fontSize: dimen.dp(14),
                  fontWeight: dimen.boldFontWeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final dynamic icon;
  final Color? primary;
  final VoidCallback? onClick;

  const _Button({this.icon, this.primary, this.onClick});

  @override
  Widget build(BuildContext context) {
    final primary = this.primary ?? context.primary;
    return Expanded(
      child: SizedBox(
        height: double.infinity,
        child: AndrossyGesture(
          backgroundColor: Colors.transparent,
          splashColor: primary.t15,
          borderRadius: BorderRadius.circular(8),
          onTap: onClick,
          child: Center(child: InAppIcon(icon, size: 24, color: primary)),
        ),
      ),
    );
  }
}
