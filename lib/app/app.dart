import 'package:flutter/material.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_translation/core.dart';

import '../features/social/data/cubits/feed_home_cubit.dart';
import '../features/social/view/cubits/verified_feed_cubit.dart';
import '../features/social/view/cubits/verified_users_cubit.dart';
import '../features/user/view/cubits/avatar_cubit.dart';
import '../features/user/view/cubits/bookmark_cubit.dart';
import '../features/user/view/cubits/cover_cubit.dart';
import '../features/user/view/cubits/follower_cubit.dart';
import '../features/user/view/cubits/following_cubit.dart';
import '../features/user/view/cubits/memory_cubit.dart';
import '../features/user/view/cubits/note_cubit.dart';
import '../features/user/view/cubits/photo_cubit.dart';
import '../features/user/view/cubits/post_cubit.dart';
import '../features/user/view/cubits/report_cubit.dart';
import '../features/user/view/cubits/story_cubit.dart';
import '../features/user/view/cubits/user_cubit.dart';
import '../features/user/view/cubits/video_cubit.dart';
import '../routes/_imports.dart';
import 'configs/local.dart';
import 'constants/app.dart';
import 'theme/dark.dart';
import 'theme/light.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    Toast.context = context;
    return ListenableBuilder(
      listenable: Translation.i,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => FeedHomeCubit(context)..load()),
            BlocProvider(
              create: (context) => VerifiedFeedCubit(context)..load(),
            ),
            BlocProvider(
              create: (context) => VerifiedUsersCubit(context)..load(),
            ),

            BlocProvider(
              create: (context) => UserFollowerCubit(context)..load(),
            ),
            BlocProvider(
              create: (context) => UserFollowingCubit(context)..load(),
            ),

            BlocProvider(create: (context) => UserAvatarCubit(context)),
            BlocProvider(
              create: (context) => UserBookmarkCubit(context)..load(),
            ),
            BlocProvider(create: (context) => UserCoverCubit(context)),
            BlocProvider(create: (context) => UserCubit(context)),
            BlocProvider(create: (context) => UserMemoryCubit(context)),
            BlocProvider(create: (context) => UserNoteCubit(context)),
            BlocProvider(create: (context) => UserPhotoCubit(context)),
            BlocProvider(create: (context) => UserPostCubit(context)),
            BlocProvider(create: (context) => UserStoryCubit(context)),
            BlocProvider(create: (context) => UserVideoCubit(context)),
            BlocProvider(create: (context) => UserReportCubit(context)),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConstants.name,
            themeMode: LocalConfigs.theme,
            locale:
                Translation.i.localeOrNull ?? Translation.i.defaultLocaleOrNull,
            initialRoute: InAppRouter.initialRoute,
            onGenerateRoute: InAppRouter.I.generate,
            theme: kLightTheme,
            darkTheme: kDarkTheme,
          ),
        );
      },
    );
  }
}
