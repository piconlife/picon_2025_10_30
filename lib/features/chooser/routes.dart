import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/object.dart';
import 'package:flutter_app_navigator/app_navigator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../routes/paths.dart';
import 'view/cubits/suggested_channel_cubit.dart';
import 'view/cubits/suggested_user_cubit.dart';
import 'view/pages/choose_channel.dart';
import 'view/pages/choose_country.dart';
import 'view/pages/choose_following.dart';
import 'view/pages/choose_hobby.dart';
import 'view/pages/choose_language.dart';
import 'view/pages/choose_motherland.dart';
import 'view/pages/choose_photo.dart';
import 'view/pages/choose_profession.dart';
import 'view/pages/choose_religion.dart';

Map<String, RouteBuilder> get mChooserRoutes {
  return {
    Routes.chooseChannel: _chooseChannel,
    Routes.chooseCountry: _chooseCountry,
    Routes.chooseCountries: _chooseCountries,
    Routes.chooseFollowing: _chooseFollowing,
    Routes.chooseHobby: _chooseHobby,
    Routes.chooseHobbies: _chooseHobbies,
    Routes.chooseLanguage: _chooseLanguage,
    Routes.chooseLanguages: _chooseLanguages,
    Routes.chooseMotherland: _chooseMotherland,
    Routes.chooseMotherlands: _chooseMotherlands,
    Routes.choosePhoto: _choosePhoto,
    Routes.chooseProfession: _chooseProfession,
    Routes.chooseProfessions: _chooseProfessions,
    Routes.chooseReligion: _chooseReligion,
    Routes.chooseReligions: _chooseReligions,
  };
}

Widget _chooseChannel(BuildContext context, Object? args) {
  SuggestedChannelsCubit? suggestedChannelsCubit = args.findOrNull(
    key: "$SuggestedChannelsCubit",
  );
  return MultiBlocProvider(
    providers: [
      suggestedChannelsCubit != null
          ? BlocProvider.value(value: suggestedChannelsCubit)
          : BlocProvider(
              create: (context) {
                return SuggestedChannelsCubit()..fetch();
              },
            ),
    ],
    child: ChooseChannelPage(args: args),
  );
}

Widget _chooseCountry(BuildContext context, Object? args) {
  return ChooseCountryPage(args: args);
}

Widget _chooseCountries(BuildContext context, Object? args) {
  return ChooseCountryPage(args: args, multiSelection: true);
}

Widget _chooseFollowing(BuildContext context, Object? args) {
  SuggestedUsersCubit? suggestedUsersCubit = args.findOrNull(
    key: "$SuggestedUsersCubit",
  );
  return MultiBlocProvider(
    providers: [
      suggestedUsersCubit != null
          ? BlocProvider.value(value: suggestedUsersCubit)
          : BlocProvider(create: (context) => SuggestedUsersCubit()..fetch()),
    ],
    child: ChooseFollowingPage(args: args),
  );
}

Widget _chooseHobby(BuildContext context, Object? args) {
  return ChooseHobbyPage(args: args);
}

Widget _chooseHobbies(BuildContext context, Object? args) {
  return ChooseHobbyPage(args: args, multiSelection: true);
}

Widget _chooseLanguage(BuildContext context, Object? args) {
  return ChooseLanguagePage(args: args);
}

Widget _chooseLanguages(BuildContext context, Object? args) {
  return ChooseLanguagePage(args: args, multiSelection: true);
}

Widget _chooseMotherland(BuildContext context, Object? args) {
  return ChooseMotherlandPage(args: args);
}

Widget _chooseMotherlands(BuildContext context, Object? args) {
  return ChooseMotherlandPage(args: args, multiSelection: true);
}

Widget _choosePhoto(BuildContext context, Object? args) {
  return ChoosePhotoPage(args: args);
}

Widget _chooseProfession(BuildContext context, Object? args) {
  return ChooseProfessionPage(args: args);
}

Widget _chooseProfessions(BuildContext context, Object? args) {
  return ChooseProfessionPage(args: args, multiSelection: true);
}

Widget _chooseReligion(BuildContext context, Object? args) {
  return ChooseReligionPage(args: args);
}

Widget _chooseReligions(BuildContext context, Object? args) {
  return ChooseReligionPage(args: args, multiSelection: true);
}
