import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/string.dart';
import 'package:flutter_andomie/utils/converter.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../app/constants/limitations.dart';
import '../../../app/dialogs/dialog_date_picker.dart';
import '../../../app/helpers/user.dart';
import '../../../data/models/user.dart';
import '../../../routes/paths.dart';

class ChoosingRouteKeys {
  const ChoosingRouteKeys._();

  static const data = 'choosing_data';
  static const submitMode = 'choosing_submit_mode';
}

class UserInfoUpdater {
  final UserKeys keys;
  final BuildContext context;
  final User user;

  UserInfoUpdater(this.context, this.user) : keys = UserKeys.i;

  Future<void> _update(String key, Object? value) async {
    UserHelper.update(context, {key: value});
  }

  /// EDITS

  Future<String?> _edit(
    String title,
    String? value, {
    bool multiline = true,
    int? minLines,
    int? maxLines,
    int? minCharacters,
    int? maxCharacters,
    TextInputType? inputType,
    EditableDialogContent? content,
  }) async {
    content ??= EditableDialogContent(
      minLines: multiline ? minLines : minLines ?? 1,
      maxLines: multiline ? maxLines : maxLines ?? 1,
      inputType: multiline ? inputType : inputType ?? TextInputType.text,
      actionType: multiline ? null : TextInputAction.done,
      minCharacters: minCharacters,
      maxCharacters: maxCharacters,
    );
    final feedback = await context.showEditor(
      title: title,
      text: value,
      hint: value ?? title,
      content: content,
    );
    return feedback ?? value;
  }

  void updateFullname(String name) async {
    final feedback = await _edit(name, user.name, multiline: false);
    _update(keys.name, feedback);
  }

  void updateTitle(String title) async {
    final feedback = await _edit(
      title,
      user.title,
      maxCharacters: Limitations.maxTitle,
    );
    _update(keys.title, feedback);
  }

  void updateBiography(String biography) async {
    final feedback = await _edit(
      biography,
      user.biography,
      maxCharacters: Limitations.maxBio,
    );
    _update(keys.biography, feedback);
  }

  void updateChildhoodRemember(String title) async {
    final feedback = await _edit(title, user.childhoodRemember);
    _update(keys.childhoodRemember, feedback);
  }

  void updateFatherName(String title) async {
    final feedback = await _edit(title, user.fatherName, multiline: false);
    _update(keys.fatherName, feedback);
  }

  void updateInterestedPlaces(String title) async {
    final feedback = await _edit(
      title,
      Converter.asString(user.interestedPlaces),
    );
    if (feedback == null) return;
    final data = feedback.list;
    _update(keys.interestedPlaces, data);
  }

  void updateMotherName(String title) async {
    final feedback = await _edit(title, user.motherName, multiline: false);
    _update(keys.motherName, feedback);
  }

  /// OPTIONS

  Future<int> _options(String title, int initial, List<String> options) async {
    final feedback = await context.showOptions(
      title: title,
      initialIndex: initial < 0 ? 0 : initial,
      options: options,
    );
    return feedback;
  }

  void updateLifestyle(String title) async {
    final options = Lifestyle.values.map((e) => e.name).toList();
    final initial = options.indexOf(user.lifestyle.id);
    final feedback = await _options(title, initial, options);
    if (feedback == initial) return;
    final data = Lifestyle.values.elementAtOrNull(feedback);
    if (data == null) return;
    _update(keys.lifestyle, data.id);
  }

  void updateMarital(String title) async {
    final options = MaritalStatus.values.map((e) => e.name).toList();
    final initial = options.indexOf(user.maritalStatus.name);
    final feedback = await _options(title, initial, options);
    if (feedback == initial) return;
    final data = MaritalStatus.values.elementAtOrNull(feedback);
    if (data == null) return;
    _update(keys.maritalStatus, data.name);
  }

  void updateRelationship(String title) async {
    final options = Relationship.values.map((e) => e.name).toList();
    final initial = options.indexOf(user.relationship.id);
    final feedback = await _options(title, initial, options);
    if (feedback == initial) return;
    final data = Relationship.values.elementAtOrNull(feedback);
    if (data == null) return;
    _update(keys.relationship, data.id);
  }

  /// DATES

  Future<int?> _date({
    required String title,
    required String subtitle,
    required DateTime initial,
    required DateTime start,
    required DateTime end,
  }) async {
    final feedback = await DatePickerBSD.show(
      context,
      title: title,
      subtitle: subtitle,
      initial: initial,
      start: start,
      end: end,
    );
    if (feedback == null) return null;
    final current = feedback.millisecondsSinceEpoch;
    return current;
  }

  void updateBirthday() async {
    final birthday = user.birthday;
    DateTime? initial;
    if (birthday != null) {
      initial = DateTime.fromMillisecondsSinceEpoch(birthday);
    }
    final now = DateTime.now();
    final feedback = await _date(
      title: "What's your birthday?",
      subtitle:
          "Please select your birthday to receive a personalized experience.",
      initial: DateTime.utc(
        initial?.year ?? now.year - 20,
        initial?.month ?? now.month,
        initial?.day ?? now.day,
      ),
      start: DateTime(now.year - Limitations.ageMaximum),
      end: DateTime(now.year - Limitations.ageMinimum, 12, 31),
    );
    if (feedback == null) return;
    if (feedback == birthday) return;
    _update(keys.birthday, feedback);
  }

  /// ROUTES

  void updateCountry() async {
    final feedback = await context.open(
      Routes.chooseCountry,
      arguments: {
        ChoosingRouteKeys.submitMode: false,
        ChoosingRouteKeys.data: [if (user.country != null) user.country],
      },
    );
    if (feedback is! String || feedback == user.country) return;
    _update(keys.country, feedback);
  }

  void updateHobbies() async {
    final feedback = await context.open(
      Routes.chooseHobbies,
      arguments: {
        ChoosingRouteKeys.submitMode: false,
        ChoosingRouteKeys.data: [if (user.hobbies != null) ...user.hobbies!],
      },
    );
    if (feedback is! List<String> || feedback == user.hobbies) return;
    _update(keys.hobbies, feedback);
  }

  void updateLanguage() async {
    final feedback = await context.open(
      Routes.chooseLanguage,
      arguments: {
        ChoosingRouteKeys.submitMode: false,
        ChoosingRouteKeys.data: [if (user.language != null) user.language],
      },
    );
    if (feedback is! String || feedback == user.language) return;
    _update(keys.language, feedback);
  }

  void updateLanguages() async {
    final feedback = await context.open(
      Routes.chooseLanguages,
      arguments: {
        ChoosingRouteKeys.submitMode: false,
        ChoosingRouteKeys.data: [
          if (user.secondaryLanguages != null) ...user.secondaryLanguages!,
        ],
      },
    );
    if (feedback is! List<String> || feedback == user.secondaryLanguages) {
      return;
    }
    _update(keys.secondaryLanguages, feedback);
  }

  void updateMotherland() async {
    final feedback = await context.open(
      Routes.chooseMotherland,
      arguments: {
        ChoosingRouteKeys.submitMode: false,
        ChoosingRouteKeys.data: [
          if (user.nationality != null) user.nationality,
        ],
      },
    );
    if (feedback is! String || feedback == user.nationality) return;
    _update(keys.nationality, feedback);
  }

  void updateProfession() async {
    final feedback = await context.open(
      Routes.chooseProfession,
      arguments: {
        ChoosingRouteKeys.submitMode: false,
        ChoosingRouteKeys.data: [if (user.profession != null) user.profession],
      },
    );
    if (feedback is! String || feedback == user.profession) return;
    _update(keys.profession, feedback);
  }

  void updateProfessions() async {
    final feedback = await context.open(
      Routes.chooseProfessions,
      arguments: {
        ChoosingRouteKeys.submitMode: false,
        ChoosingRouteKeys.data: [
          if (user.interestedProfessions != null)
            ...user.interestedProfessions!,
        ],
      },
    );
    if (feedback is! List<String> || feedback == user.interestedProfessions) {
      return;
    }
    _update(keys.interestedProfessions, feedback);
  }

  void updateReligion() async {
    final feedback = await context.open(
      Routes.chooseReligion,
      arguments: {
        ChoosingRouteKeys.submitMode: false,
        ChoosingRouteKeys.data: [if (user.religion != null) user.religion],
      },
    );
    if (feedback is! String || feedback == user.religion) return;
    _update(keys.religion, feedback);
  }
}
