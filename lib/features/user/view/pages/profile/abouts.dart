import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';

import '../../../../../app/res/icons.dart';
import '../../../../../app/styles/fonts.dart';
import '../../../../../data/models/user.dart';
import '../../../../../roots/widgets/icon.dart';
import '../../../../../roots/widgets/scaffold_shimmer.dart';
import '../../../../../roots/widgets/text.dart';
import '../../../../../roots/widgets/text_button.dart';
import '../../../../../roots/widgets/user_builder.dart';
import '../../../../chooser/data/models/religion.dart';
import '../../../utils/user_updater.dart';
import '../../cubits/user_cubit.dart';

class ProfileAboutsSegment extends StatefulWidget {
  final User? user;

  const ProfileAboutsSegment({super.key, this.user});

  @override
  State<ProfileAboutsSegment> createState() => _ProfileAboutsSegmentState();
}

class _ProfileAboutsSegmentState extends State<ProfileAboutsSegment> {
  List<Map<String, dynamic>> _data(User user) {
    return [
      {
        "title": "Family Information",
        "contents": [
          {
            "key": UserKeys.i.fatherName,
            "icon": InAppIcons.father.regular,
            "title": "Father's Name",
            "body": user.fatherName,
            "value": user.fatherName,
            "editable": user.fatherName.isNotValid,
          },
          {
            "key": UserKeys.i.motherName,
            "icon": InAppIcons.mother.regular,
            "title": "Mother's Name",
            "body": user.motherName,
            "value": user.motherName,
            "editable": user.motherName.isNotValid,
          },
          {
            "key": UserKeys.i.birthday,
            "icon": InAppIcons.birthday.regular,
            "title": "Date of birth",
            "body": user.birthday.toDate(),
            "value": user.birthday,
            "editable": user.birthday.isNotValid,
          },
          {
            "key": UserKeys.i.maritalStatus,
            "icon": InAppIcons.maritalStatus.regular,
            "title": "Marital Status",
            "body": user.maritalStatus.name,
            "value": user.maritalStatus.id,
            "editable": user.maritalStatus.id != MaritalStatus.married.id,
          },
          {
            "key": UserKeys.i.religion,
            "icon": InAppIcons.religion.regular,
            "title": "Religion",
            "body": InAppReligion.of(user.religion)?.label,
            "value": user.religion,
            "editable": true ?? user.religion.isNotValid,
          },
          {
            "key": UserKeys.i.language,
            "icon": InAppIcons.language.regular,
            "title": "Mother language",
            "body": kLanguageNamesInEnglish[user.language],
            "value": user.language,
            "editable": true,
          },
          {
            "key": UserKeys.i.nationality,
            "icon": InAppIcons.nationality.regular,
            "title": "Nationality",
            "body": kCountryNationalitiesInEnglish[user.nationality],
            "value": user.nationality,
            "editable": true,
          },
          {
            "key": UserKeys.i.country,
            "icon": InAppIcons.flag.regular,
            "title": "Country",
            "body": kCountryNamesInEnglish[user.country],
            "value": user.country,
            "editable": true,
          },
        ],
      },
      {
        "title": "More Information",
        "contents": [
          {
            "key": UserKeys.i.relationship,
            "icon": InAppIcons.relationship.regular,
            "title": "Relationship",
            "body": user.relationship.name,
            "value": user.relationship.id,
            "editable": true,
          },
          {
            "key": UserKeys.i.profession,
            "icon": InAppIcons.profession.regular,
            "title": "Profession",
            "body": user.profession,
            "value": user.profession,
            "editable": true,
          },
          {
            "key": UserKeys.i.interestedProfessions,
            "icon": InAppIcons.profession.regular,
            "title": "Interested Professions",
            "body": user.interestedProfessions?.text,
            "value": user.interestedProfessions,
            "editable": true,
          },
          {
            "key": UserKeys.i.secondaryLanguages,
            "icon": InAppIcons.language.regular,
            "title": "Other Languages",
            "body": user.secondaryLanguages.use.map((e) {
              return kLanguageNamesInEnglish[e].use;
            }).text,
            "value": user.secondaryLanguages,
            "editable": true,
          },
          {
            "key": UserKeys.i.hobbies,
            "icon": InAppIcons.hobby.regular,
            "title": "Hobbies",
            "body": user.hobbies?.text,
            "value": user.hobbies,
            "editable": true,
          },
          {
            "key": UserKeys.i.interestedPlaces,
            "icon": InAppIcons.interestedPlace.regular,
            "title": "Interested Places",
            "body": user.interestedPlaces?.text,
            "value": user.interestedPlaces,
            "editable": true,
          },
          {
            "key": UserKeys.i.lifestyle,
            "icon": InAppIcons.tips.regular,
            "title": "Life Style",
            "body": user.lifestyle.name,
            "value": user.lifestyle.id,
            "editable": true,
          },
          {
            "key": UserKeys.i.childhoodRemember,
            "icon": InAppIcons.childhoodRemember.regular,
            "title": "Childhood Remember",
            "body": user.childhoodRemember,
            "value": user.childhoodRemember,
            "editable": true,
          },
        ],
      },
    ];
  }

  void _update(String key, String title, User? user) async {
    if (key.isEmpty || user == null) return;
    final keys = UserKeys.i;
    final updater = UserInfoUpdater(context, user);
    if (keys.fatherName == key) {
      return updater.updateFatherName(title);
    }
    if (keys.motherName == key) {
      return updater.updateMotherName(title);
    }
    if (keys.birthday == key) {
      return updater.updateBirthday();
    }
    if (keys.maritalStatus == key) {
      return updater.updateMarital(title);
    }
    if (keys.religion == key) {
      return updater.updateReligion();
    }
    if (keys.language == key) {
      return updater.updateLanguage();
    }
    if (keys.nationality == key) {
      return updater.updateMotherland();
    }
    if (keys.country == key) {
      return updater.updateCountry();
    }
    if (keys.relationship == key) {
      return updater.updateRelationship(title);
    }
    if (keys.profession == key) {
      return updater.updateProfession();
    }
    if (keys.interestedProfessions == key) {
      return updater.updateProfessions();
    }
    if (keys.secondaryLanguages == key) {
      return updater.updateLanguages();
    }
    if (keys.hobbies == key) {
      return updater.updateHobbies();
    }
    if (keys.interestedPlaces == key) {
      return updater.updateInterestedPlaces(title);
    }
    if (keys.lifestyle == key) {
      return updater.updateLifestyle(title);
    }
    if (keys.childhoodRemember == key) {
      return updater.updateChildhoodRemember(title);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    final light = context.light;
    final primary = context.primary;
    return InAppUserBuilder(
      initial: widget.user,
      builder: (context, user) {
        final map = _data(user);
        final currentUid = user.isCurrentUser;
        return ColoredBox(
          color: light,
          child: BlocBuilder<UserCubit, Response<User>>(
            builder: (context, state) {
              if (state.status.isLoading) {
                return InAppScaffoldShimmer();
              }
              return ListView(
                padding: EdgeInsets.only(bottom: dimen.dp(100)),
                children: map.map((e) {
                  final category = e["title"] as String;
                  final contents = e["contents"] as List<Map<String, dynamic>>;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(dimen.dp(16)),
                        child: InAppText(
                          category,
                          style: TextStyle(
                            color: primary,
                            fontWeight: dimen.mediumFontWeight,
                            fontSize: dimen.dp(18),
                          ),
                        ),
                      ),
                      ...contents.map((e) {
                        final key = e["key"] as String;
                        final icon = e["icon"];
                        final title = e["title"] as String;
                        final body = e["body"] as String?;
                        final editable = e["editable"] as bool;
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: dimen.dp(16),
                            vertical: dimen.dp(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  top: dimen.dp(8),
                                  right: dimen.dp(24),
                                ),
                                padding: EdgeInsets.all(dimen.dp(8)),
                                decoration: BoxDecoration(
                                  color: dark.t05,
                                  shape: BoxShape.circle,
                                ),
                                child: InAppIcon(
                                  icon,
                                  color: dark,
                                  size: dimen.dp(24),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InAppText(
                                            title,
                                            style: TextStyle(
                                              color: dark.t50,
                                              fontSize: dimen.dp(16),
                                              fontWeight: dimen.boldFontWeight,
                                            ),
                                          ),
                                        ),
                                        if (currentUid &&
                                            (body.isNotValid || editable))
                                          InAppTextButton(
                                            body.isValid ? "Edit" : "Add",
                                            onTap: () =>
                                                _update(key, title, user),
                                            borderRadius: BorderRadius.circular(
                                              dimen.dp(10),
                                            ),
                                            backgroundColor: primary.t05,
                                            style: TextStyle(
                                              fontWeight:
                                                  dimen.semiBoldFontWeight,
                                              fontFamily: InAppFonts.secondary,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: dimen.dp(16),
                                              vertical: dimen.dp(4),
                                            ),
                                          ),
                                      ],
                                    ),
                                    InAppText(
                                      body.isValid
                                          ? body
                                          : currentUid
                                          ? "Apply your document"
                                          : "No data found",
                                      style: TextStyle(
                                        color: body.isValid ? dark : dark.t25,
                                        fontWeight: dimen.semiBoldFontWeight,
                                        fontFamily: InAppFonts.secondary,
                                        fontSize: dimen.dp(16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );
  }
}
