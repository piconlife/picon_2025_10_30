import 'dart:convert';

import 'package:auth_management/auth_management.dart';
import 'package:flutter_andomie/core.dart';

import '../../app/constants/limitations.dart';
import '../../app/helpers/user.dart';

class UserKeys extends AuthKeys {
  const UserKeys._();

  static UserKeys? _i;

  static UserKeys get i => _i ??= const UserKeys._();

  // IN APP INFO

  final activeTime = "active_time";
  final joiningTime = "joining_time";

  final calling = "calling";
  final celebrity = "celebrity";
  final messaging = "messaging";
  final secureAccount = "secure_account";

  final latitude = "latitude";
  final longitude = "longitude";
  final rating = "rating";

  final biography = "biography";
  final coverPhoto = "cover_photo";
  final profilePath = "profile_path";
  final profileUrl = "profile_url";
  final secondaryEmail = "secondary_email";
  final secondaryPhone = "secondary_phone";
  final title = "title";

  // UPDATING INFO
  final reportCount = "report_count";
  final approvals = "approvals";
  final followers = "followers";
  final followings = "followings";
  final interestedChannels = "interested_channels";

  // PERSONAL INFO
  final birthday = "birthday";

  final childhoodRemember = "childhood_remember";
  final fatherName = "father_name";
  final language = "language";
  final motherName = "mother_name";
  final nationality = "nationality";
  final profession = "profession";
  final religion = "religion";
  final website = "website";

  final gender = "gender";
  final lifestyle = "lifestyle";
  final maritalStatus = "marital_status";
  final relationship = "relationship";

  final hobbies = "hobbies";
  final interestedPlaces = "interested_places";
  final interestedProfessions = "interested_professions";
  final secondaryLanguages = "secondary_languages";

  // OBJECT KEYs
  final alternateInfo = "alternate_info";
  final primaryInfo = "primary_info";
  final secondaryInfo = "secondary_info";

  // ADDRESS KEYs
  final address = "address";
  final area = "area";
  final city = "city";
  final country = "country";
  final countryCode = "country_code";
  final house = "house";
  final policeStation = "police_station";
  final postCode = "post_code";
  final road = "road";
  final section = "section";
  final state = "state";

  // CONTACT KEYs
  final contact = "contact";

  @override
  Iterable<String> get keys {
    return [
      // ROOT INFO
      id,
      idToken,
      timeMills,
      email,
      loggedIn,
      loggedInTime,
      loggedOutTime,
      name,
      password,
      phone,
      photo,
      username,
      verified,

      // IN APP INFO
      activeTime,
      joiningTime,
      calling,
      celebrity,
      messaging,
      secureAccount,
      latitude,
      longitude,
      rating,
      biography,
      coverPhoto,
      profilePath,
      profileUrl,
      secondaryEmail,
      secondaryPhone,
      title,

      // UPDATING INFO
      reportCount,
      approvals,
      followers,
      followings,
      interestedChannels,

      // PERSONAL INFO
      birthday,
      childhoodRemember,
      fatherName,
      language,
      motherName,
      nationality,
      profession,
      religion,
      website,
      gender,
      lifestyle,
      maritalStatus,
      relationship,
      hobbies,
      interestedPlaces,
      interestedProfessions,
      secondaryLanguages,

      // OBJECT KEYs
      alternateInfo,
      primaryInfo,
      secondaryInfo,

      // ADDRESS KEYs
      address,
      area,
      city,
      country,
      countryCode,
      house,
      policeStation,
      postCode,
      road,
      section,
      state,

      // CONTACT KEYs
      contact,
    ];
  }
}

class User extends Auth<UserKeys> {
  int? activeTime;
  int? joiningTime;

  bool? calling;
  bool? celebrity;
  bool? messaging;
  bool? secureAccount;

  double? latitude;
  double? longitude;
  double? _rating;

  String? biography;
  String? coverPhoto;
  String? profilePath;
  String? profileUrl;
  String? secondaryEmail;
  String? secondaryPhone;
  String? title;

  // UPDATING INFO
  int? reportCount;

  List<String>? approvals;
  List<String>? followers;
  List<String>? followings;
  List<String>? interestedChannels;

  // PERSONAL INFO
  int? birthday;

  String? childhoodRemember;
  String? country;
  String? fatherName;
  String? language;
  String? motherName;
  String? nationality;
  String? profession;
  String? religion;
  String? website;

  Gender gender;
  Lifestyle lifestyle;
  MaritalStatus maritalStatus;
  Relationship relationship;

  List<String>? hobbies;
  List<String>? interestedPlaces;
  List<String>? interestedProfessions;
  List<String>? secondaryLanguages;

  UserInfo? _alternateInfo;
  UserInfo? _primaryInfo;
  UserInfo? _secondaryInfo;

  UserInfo get alternateInfo => _alternateInfo ?? const UserInfo();

  set alternateInfo(UserInfo? value) => _alternateInfo = value;

  UserInfo get primaryInfo => _primaryInfo ?? const UserInfo();

  set primaryInfo(UserInfo? value) => _primaryInfo = value;

  UserInfo get secondaryInfo => _secondaryInfo ?? const UserInfo();

  String? get avatar => photo;

  double get rating => _rating ?? Limitations.userRating;

  bool get isRatedUser => rating >= 4;

  bool get isCelebrityUser => rating >= 5;

  bool get isHeartUser => !isCelebrityUser && rating >= 4;

  bool get isCurrentUser => UserHelper.isCurrentUser(id);

  bool get isOnline => true;

  String get onlineStatus {
    return 'Online';
    final text = activeTime.toRealtime();
    if (text.toLowerCase() == "now") {
      return 'Online';
    }
    return text;
  }

  User({
    // ROOT
    super.id = "",
    super.timeMills,
    super.accessToken,
    super.biometric,
    super.email,
    super.extra,
    super.idToken,
    super.loggedIn,
    super.loggedInTime,
    super.loggedOutTime,
    super.name,
    super.password,
    super.phone,
    super.photo,
    super.provider,
    super.username,
    super.verified,
    // IN APP INFO
    this.activeTime,
    this.joiningTime,
    this.calling,
    this.celebrity,
    this.messaging,
    this.secureAccount,
    this.biography,
    this.coverPhoto,
    this.latitude,
    this.longitude,
    this.profilePath,
    this.profileUrl,
    this.secondaryEmail,
    this.secondaryPhone,
    this.title,

    // UPDATING INFO
    this.reportCount,
    this.approvals,
    this.followers,
    this.followings,
    this.interestedChannels,
    double? rating,

    // PERSONAL INFO
    this.birthday,
    this.childhoodRemember,
    this.country,
    this.fatherName,
    this.language,
    this.motherName,
    this.nationality,
    this.profession,
    this.religion,
    this.website,
    this.hobbies,
    this.interestedPlaces,
    this.interestedProfessions,
    this.secondaryLanguages,
    Gender? gender,
    Lifestyle? lifestyle,
    MaritalStatus? maritalStatus,
    Relationship? relationship,
    UserInfo? alternateInfo,
    UserInfo? primaryInfo,
    UserInfo? secondaryInfo,
  }) : gender = gender ?? Gender.male,
       lifestyle = lifestyle ?? Lifestyle.normal,
       maritalStatus = maritalStatus ?? MaritalStatus.unmarried,
       relationship = relationship ?? Relationship.no,
       _rating = rating,
       _alternateInfo = alternateInfo,
       _primaryInfo = primaryInfo,
       _secondaryInfo = secondaryInfo;

  @override
  User copy({
    // ROOT
    String? id,
    int? timeMills,
    String? accessToken,
    BiometricStatus? biometric,
    String? email,
    Map<String, dynamic>? extra,
    String? idToken,
    bool? loggedIn,
    int? loggedInTime,
    int? loggedOutTime,
    String? name,
    String? password,
    String? phone,
    String? photo,
    Provider? provider,
    String? username,
    bool? verified,

    // IN APP INFO
    int? activeTime,
    int? joiningTime,
    double? rating,
    bool? calling,
    bool? celebrity,
    bool? messaging,
    bool? secureAccount,
    String? biography,
    String? coverPhoto,
    double? latitude,
    double? longitude,
    String? profilePath,
    String? profileUrl,
    String? secondaryEmail,
    String? secondaryPhone,
    String? title,

    // UPDATING INFO
    int? reportCount,
    List<String>? approvals,
    List<String>? followers,
    List<String>? followings,
    List<String>? interestedChannels,

    // PERSONAL INFO
    int? birthday,
    String? country,
    String? childhoodRemember,
    String? fatherName,
    String? language,
    String? motherName,
    String? nationality,
    String? profession,
    String? religion,
    String? website,
    List<String>? hobbies,
    List<String>? interestedPlaces,
    List<String>? interestedProfessions,
    List<String>? secondaryLanguages,
    Gender? gender,
    Lifestyle? lifestyle,
    MaritalStatus? maritalStatus,
    Relationship? relationship,
    UserInfo? alternateInfo,
    UserInfo? primaryInfo,
    UserInfo? secondaryInfo,
  }) {
    return User(
      // ROOT
      id: id ?? this.id,
      timeMills: timeMills ?? this.timeMills,
      accessToken: accessToken ?? this.accessToken,
      biometric: biometric ?? this.biometric,
      email: email ?? this.email,
      extra: extra ?? this.extra,
      idToken: idToken ?? this.idToken,
      loggedIn: loggedIn ?? this.loggedIn,
      loggedInTime: loggedInTime ?? this.loggedInTime,
      loggedOutTime: loggedOutTime ?? this.loggedOutTime,
      name: name ?? this.name,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      provider: provider ?? this.provider,
      username: username ?? this.username,
      verified: verified ?? this.verified,

      // IN APP INFO
      calling: calling ?? this.calling,
      celebrity: celebrity ?? this.celebrity,
      messaging: messaging ?? this.messaging,
      secureAccount: secureAccount ?? this.secureAccount,
      activeTime: activeTime ?? this.activeTime,
      biography: biography ?? this.biography,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      joiningTime: joiningTime ?? this.joiningTime,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      profilePath: profilePath ?? this.profilePath,
      profileUrl: profileUrl ?? this.profileUrl,
      rating: rating ?? this.rating,
      secondaryEmail: secondaryEmail ?? this.secondaryEmail,
      secondaryPhone: secondaryPhone ?? this.secondaryPhone,
      title: title ?? this.title,

      // UPDATING INFO
      reportCount: reportCount ?? this.reportCount,
      approvals: approvals ?? this.approvals,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
      interestedChannels: interestedChannels ?? this.interestedChannels,

      // PERSONAL INFO
      birthday: birthday ?? this.birthday,
      childhoodRemember: childhoodRemember ?? this.childhoodRemember,
      country: country ?? this.country,
      fatherName: fatherName ?? this.fatherName,
      gender: gender ?? this.gender,
      language: language ?? this.language,
      lifestyle: lifestyle ?? this.lifestyle,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      motherName: motherName ?? this.motherName,
      nationality: nationality ?? this.nationality,
      profession: profession ?? this.profession,
      relationship: relationship ?? this.relationship,
      religion: religion ?? this.religion,
      hobbies: hobbies ?? this.hobbies,
      interestedPlaces: interestedPlaces ?? this.interestedPlaces,
      interestedProfessions:
          interestedProfessions ?? this.interestedProfessions,
      secondaryLanguages: secondaryLanguages ?? this.secondaryLanguages,
      alternateInfo: alternateInfo ?? _alternateInfo,
      primaryInfo: primaryInfo ?? _primaryInfo,
      secondaryInfo: secondaryInfo ?? _secondaryInfo,
    );
  }

  factory User.from(Object? source) {
    final auth = Auth.from(source);
    return User(
      // ROOT
      id: auth.id,
      timeMills: auth.timeMills,
      accessToken: auth.accessToken,
      biometric: auth.biometric,
      loggedIn: auth.loggedIn,
      loggedInTime: auth.loggedInTime,
      loggedOutTime: auth.loggedOutTime,
      idToken: auth.idToken,
      email: auth.email,
      name: auth.name,
      password: auth.password,
      phone: auth.phone,
      photo: auth.photo,
      provider: auth.provider,
      username: auth.username,
      verified: auth.verified,
      extra: auth.extra,

      // IN APP INFO
      activeTime: source.entityValue(UserKeys.i.activeTime),
      joiningTime: source.entityValue(UserKeys.i.joiningTime),
      rating: source.entityValue(UserKeys.i.rating),
      calling: source.entityValue(UserKeys.i.calling),
      celebrity: source.entityValue(UserKeys.i.celebrity),
      messaging: source.entityValue(UserKeys.i.messaging),
      secureAccount: source.entityValue(UserKeys.i.secureAccount),
      biography: source.entityValue(UserKeys.i.biography),
      coverPhoto: source.entityValue(UserKeys.i.coverPhoto),
      latitude: source.entityValue(UserKeys.i.latitude),
      longitude: source.entityValue(UserKeys.i.longitude),
      profilePath: source.entityValue(UserKeys.i.profilePath),
      profileUrl: source.entityValue(UserKeys.i.profileUrl),
      secondaryEmail: source.entityValue(UserKeys.i.secondaryEmail),
      secondaryPhone: source.entityValue(UserKeys.i.secondaryPhone),
      title: source.entityValue(UserKeys.i.title),

      // UPDATING INFO
      reportCount: source.entityValue(UserKeys.i.reportCount),
      approvals: source.entityValues(UserKeys.i.approvals),
      followers: source.entityValues(UserKeys.i.followers),
      followings: source.entityValues(UserKeys.i.followings),
      interestedChannels: source.entityValues(UserKeys.i.interestedChannels),

      // PERSONAL INFO
      birthday: source.entityValue(UserKeys.i.birthday),
      childhoodRemember: source.entityValue(UserKeys.i.childhoodRemember),
      country: source.entityValue(UserKeys.i.country),
      fatherName: source.entityValue(UserKeys.i.fatherName),
      language: source.entityValue(UserKeys.i.language),
      motherName: source.entityValue(UserKeys.i.motherName),
      nationality: source.entityValue(UserKeys.i.nationality),
      profession: source.entityValue(UserKeys.i.profession),
      religion: source.entityValue(UserKeys.i.religion),
      website: source.entityValue(UserKeys.i.website),
      hobbies: source.entityValues(UserKeys.i.hobbies),
      interestedPlaces: source.entityValues(UserKeys.i.interestedPlaces),
      interestedProfessions: source.entityValues(
        UserKeys.i.interestedProfessions,
      ),
      secondaryLanguages: source.entityValues(UserKeys.i.secondaryLanguages),
      gender: source.entityValue(UserKeys.i.gender, Gender.from),
      lifestyle: source.entityValue(UserKeys.i.lifestyle, Lifestyle.from),
      maritalStatus: source.entityValue(
        UserKeys.i.maritalStatus,
        MaritalStatus.from,
      ),
      relationship: source.entityValue(
        UserKeys.i.relationship,
        Relationship.from,
      ),
      alternateInfo: source.entityValue(
        UserKeys.i.alternateInfo,
        UserInfo.from,
      ),
      primaryInfo: source.entityValue(UserKeys.i.primaryInfo, UserInfo.from),
      secondaryInfo: source.entityValue(
        UserKeys.i.secondaryInfo,
        UserInfo.from,
      ),
    );
  }

  @override
  UserKeys makeKey() => UserKeys.i;

  @override
  Map<String, dynamic> get source {
    return super.source..addAll({
      // IN APP INFO
      UserKeys.i.activeTime: activeTime,
      UserKeys.i.joiningTime: joiningTime,

      UserKeys.i.calling: calling,
      UserKeys.i.messaging: messaging,
      UserKeys.i.secureAccount: secureAccount,

      UserKeys.i.rating: _rating,
      UserKeys.i.latitude: latitude,
      UserKeys.i.longitude: longitude,

      UserKeys.i.biography: biography,
      UserKeys.i.coverPhoto: coverPhoto,
      UserKeys.i.profilePath: profilePath,
      UserKeys.i.profileUrl: profileUrl,
      UserKeys.i.secondaryEmail: secondaryEmail,
      UserKeys.i.secondaryPhone: secondaryPhone,
      UserKeys.i.title: title,

      // UPDATING INFO
      UserKeys.i.reportCount: reportCount,
      UserKeys.i.approvals: approvals,
      UserKeys.i.followers: followers,
      UserKeys.i.followings: followings,
      UserKeys.i.interestedChannels: interestedChannels,

      // PERSONAL INFO
      UserKeys.i.birthday: birthday,

      UserKeys.i.childhoodRemember: childhoodRemember,
      UserKeys.i.country: country,
      UserKeys.i.fatherName: fatherName,
      UserKeys.i.language: language,
      UserKeys.i.motherName: motherName,
      UserKeys.i.nationality: nationality,
      UserKeys.i.profession: profession,
      UserKeys.i.religion: religion,
      UserKeys.i.website: website,

      UserKeys.i.gender: gender.id,
      UserKeys.i.lifestyle: lifestyle.id,
      UserKeys.i.maritalStatus: maritalStatus.id,
      UserKeys.i.relationship: relationship.id,

      UserKeys.i.hobbies: hobbies,
      UserKeys.i.interestedPlaces: interestedPlaces,
      UserKeys.i.interestedProfessions: interestedProfessions,
      UserKeys.i.secondaryLanguages: secondaryLanguages,

      // OBJECT INFO
      UserKeys.i.alternateInfo: _alternateInfo?.source,
      UserKeys.i.primaryInfo: _primaryInfo?.source,
      UserKeys.i.secondaryInfo: _secondaryInfo?.source,
    });
  }

  @override
  String get json => jsonEncode(source);

  @override
  int get hashCode => json.hashCode;

  @override
  bool operator ==(Object other) {
    return other is User && other.id == id && other.json == json;
  }

  @override
  String toString() => "$User#$hashCode($json)";
}

enum Gender {
  male(id: "male", name: "Male"),
  female(id: "female", name: "Female"),
  other(id: "other", name: "Other");

  final String id;
  final String name;

  const Gender({required this.id, required this.name});

  factory Gender.from(Object? source) {
    if (source == null) return Gender.male;
    return values.firstWhere(
      (e) =>
          e == source ||
          e.index == source ||
          e.id == source ||
          e.name == source,
      orElse: () => Gender.male,
    );
  }
}

enum MaritalStatus {
  married(id: "married", name: "Married"),
  unmarried(id: "unmarried", name: "Unmarried"),
  other(id: "other", name: "Other");

  final String id;
  final String name;

  const MaritalStatus({required this.id, required this.name});

  factory MaritalStatus.from(Object? source) {
    if (source == null) return MaritalStatus.unmarried;
    final x = values.firstWhere(
      (e) => e == source || e.id == source || e.name == source,
      orElse: () => MaritalStatus.unmarried,
    );
    return x;
  }
}

enum Lifestyle {
  modern(id: "modern", name: "Modern"),
  normal(id: "normal", name: "Normal");

  final String id;
  final String name;

  const Lifestyle({required this.id, required this.name});

  factory Lifestyle.from(Object? source) {
    if (source == null) return Lifestyle.normal;
    return values.firstWhere(
      (e) => e == source || e.id == source || e.name == source,
      orElse: () => Lifestyle.normal,
    );
  }
}

enum Relationship {
  yes(id: "YES", name: "Yes"),
  no(id: "NO", name: "No");

  final String id;
  final String name;

  const Relationship({required this.id, required this.name});

  factory Relationship.from(Object? source) {
    if (source == null) return Relationship.no;
    return values.firstWhere(
      (e) => e == source || e.id == source || e.name == source,
      orElse: () => Relationship.no,
    );
  }
}

class UserInfo {
  final Address? _address;
  final Contact? _contact;

  const UserInfo({Address? address, Contact? contact})
    : _address = address,
      _contact = contact;

  UserInfo copy({Address? address, Contact? contact}) {
    return UserInfo(address: address ?? _address, contact: contact ?? _contact);
  }

  factory UserInfo.from(Object? source) {
    return UserInfo(
      address: source.entityValue(UserKeys.i.address, Address.from),
      contact: source.entityValue(UserKeys.i.contact, Contact.from),
    );
  }

  Address get address => _address ?? const Address();

  Contact get contact => _contact ?? const Contact();

  Map<String, dynamic> get source {
    return {
      UserKeys.i.address: _address?.source,
      UserKeys.i.contact: _contact?.source,
    };
  }

  String get json => jsonEncode(source);

  @override
  int get hashCode => address.hashCode ^ contact.hashCode;

  @override
  bool operator ==(Object other) {
    return other is UserInfo &&
        other.address == address &&
        other.contact == contact;
  }

  @override
  String toString() {
    return "$UserInfo(address: $address, contact: $contact)";
  }
}

class Address {
  final String? area;
  final String? city;
  final String? country;
  final String? countryCode;
  final String? house;
  final String? policeStation;
  final String? postCode;
  final String? road;
  final String? section;
  final String? state;

  const Address({
    this.area,
    this.city,
    this.country,
    this.countryCode,
    this.house,
    this.policeStation,
    this.postCode,
    this.road,
    this.section,
    this.state,
  });

  Address copy({
    String? area,
    String? city,
    String? country,
    String? countryCode,
    String? house,
    String? policeStation,
    String? postCode,
    String? road,
    String? section,
    String? state,
  }) {
    return Address(
      area: area ?? this.area,
      city: city ?? this.city,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      house: house ?? this.house,
      policeStation: policeStation ?? this.policeStation,
      postCode: postCode ?? this.postCode,
      road: road ?? this.road,
      section: section ?? this.section,
      state: state ?? this.state,
    );
  }

  factory Address.from(Object? source) {
    return Address(
      area: source.entityValue(UserKeys.i.area),
      city: source.entityValue(UserKeys.i.city),
      country: source.entityValue(UserKeys.i.country),
      countryCode: source.entityValue(UserKeys.i.countryCode),
      house: source.entityValue(UserKeys.i.house),
      policeStation: source.entityValue(UserKeys.i.policeStation),
      postCode: source.entityValue(UserKeys.i.postCode),
      road: source.entityValue(UserKeys.i.road),
      section: source.entityValue(UserKeys.i.section),
      state: source.entityValue(UserKeys.i.state),
    );
  }

  Map<String, dynamic> get source {
    return {
      UserKeys.i.area: area,
      UserKeys.i.city: city,
      UserKeys.i.country: country,
      UserKeys.i.countryCode: countryCode,
      UserKeys.i.house: house,
      UserKeys.i.policeStation: policeStation,
      UserKeys.i.postCode: postCode,
      UserKeys.i.road: road,
      UserKeys.i.section: section,
      UserKeys.i.state: state,
    };
  }

  String get json => jsonEncode(source);

  @override
  int get hashCode =>
      area.hashCode ^
      city.hashCode ^
      country.hashCode ^
      countryCode.hashCode ^
      house.hashCode ^
      policeStation.hashCode ^
      postCode.hashCode ^
      road.hashCode ^
      section.hashCode ^
      state.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Address &&
        other.area == area &&
        other.city == city &&
        other.country == country &&
        other.countryCode == countryCode &&
        other.house == house &&
        other.policeStation == policeStation &&
        other.postCode == postCode &&
        other.road == road &&
        other.section == section &&
        other.state == state;
  }

  @override
  String toString() {
    return "$Address(area: $area, city: $city, country: $country, countryCode: $countryCode, house: $house, policeStation: $policeStation, postCode: $postCode, road: $road, section: $section, state: $state)";
  }
}

class Contact {
  final String? email;
  final String? phone;
  final String? website;

  const Contact({this.email, this.phone, this.website});

  Contact copy({String? email, String? phone, String? website}) {
    return Contact(
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
    );
  }

  factory Contact.from(Object? source) {
    return Contact(
      email: source.entityValue(UserKeys.i.email),
      phone: source.entityValue(UserKeys.i.phone),
      website: source.entityValue(UserKeys.i.website),
    );
  }

  Map<String, dynamic> get source {
    return {
      UserKeys.i.email: email,
      UserKeys.i.phone: phone,
      UserKeys.i.website: website,
    };
  }

  String get json => jsonEncode(source);

  @override
  int get hashCode => email.hashCode ^ phone.hashCode ^ website.hashCode;

  @override
  bool operator ==(Object other) =>
      other is Contact &&
      other.email == email &&
      other.phone == phone &&
      other.website == website;

  @override
  String toString() {
    return "$Contact(email: $email, phone: $phone, website: $website)";
  }
}
