import 'package:auth_management/auth_management.dart';
import 'package:flutter_andomie/extensions/object.dart';

import '../../app/constants/limitations.dart';
import '../../data/extensions/map.dart';

List<String> _keys = [
  UserKeys.i.id,
  UserKeys.i.idToken,
  UserKeys.i.timeMills,
  UserKeys.i.email,
  UserKeys.i.loggedIn,
  UserKeys.i.loggedInTime,
  UserKeys.i.loggedOutTime,
  UserKeys.i.name,
  UserKeys.i.password,
  UserKeys.i.phone,
  UserKeys.i.photo,
  UserKeys.i.username,
  UserKeys.i.verified,
];

class UserKeys extends AuthKeys {
  const UserKeys._();

  static UserKeys? _i;

  static UserKeys get i => _i ??= const UserKeys._();

  // Information
  final activeTime = "active_time";
  final biography = "biography";
  final birthday = "birthday";
  final childhoodRemember = "childhood_remember";
  final coverPhoto = "cover_photo";
  final fatherName = "father_name";
  final gender = "gender";
  final joiningTime = "joining_time";
  final language = "language";
  final latitude = "latitude";
  final lifeStyle = "life_style";
  final longitude = "longitude";
  final maritalStatus = "marital_status";
  final motherName = "mother_name";
  final nationality = "nationality";
  final profession = "profession";
  final profilePath = "profile_path";
  final profileUrl = "profile_url";
  final rating = "rating";
  final relationship = "relationship";
  final religion = "religion";
  final secondaryEmail = "secondary_email";
  final secondaryPhone = "secondary_phone";
  final title = "title";
  final website = "website";

  // Collections
  final approvals = "approvals";
  final favouritePlaces = "favourite_places";
  final followers = "followers";
  final followings = "followings";
  final hobbies = "hobbies";
  final interestedChannels = "interested_channels";
  final interestedPlaces = "interested_places";
  final interestedProfessions = "interested_professions";
  final secondaryLanguages = "secondary_languages";

  // Conditions
  final calling = "calling";
  final celebrity = "celebrity";
  final messaging = "messaging";
  final secureAccount = "secure_account";

  // Object
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
}

class User extends Auth<UserKeys> {
  int? activeTime;
  int? birthday;
  int? joiningTime;
  bool? calling;
  bool? celebrity;
  bool? messaging;
  bool? secureAccount;

  double? _rating;
  double? latitude;
  double? longitude;

  String? biography;
  String? childhoodRemember;
  String? coverPhoto;
  String? fatherName;
  Gender? _gender;
  String? language;
  String? lifeStyle;
  String? maritalStatus;
  String? motherName;
  String? nationality;
  String? profession;
  String? profilePath;
  String? profileUrl;
  String? relationship;
  String? religion;
  String? secondaryEmail;
  String? secondaryPhone;
  String? title;
  String? website;

  List<String>? approvals;
  List<String>? favouritePlaces;
  List<String>? followers;
  List<String>? followings;
  List<String>? hobbies;
  List<String>? interestedChannels;
  List<String>? interestedPlaces;
  List<String>? interestedProfessions;
  List<String>? secondaryLanguages;

  UserInfo? _alternateInfo;
  UserInfo? _primaryInfo;
  UserInfo? _secondaryInfo;

  String? get avatar => photo;

  double get rating => _rating ?? Limitations.userRating;

  UserInfo get alternateInfo => _alternateInfo ?? const UserInfo();

  set alternateInfo(UserInfo? value) => _alternateInfo = value;

  Gender get gender => _gender ?? Gender.male;

  set gender(Gender value) => _gender = value;

  UserInfo get primaryInfo => _primaryInfo ?? const UserInfo();

  set primaryInfo(UserInfo? value) => _primaryInfo = value;

  UserInfo get secondaryInfo => _secondaryInfo ?? const UserInfo();

  User({
    // PARENT
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
    // CHILD
    this.activeTime,
    this.birthday,
    this.joiningTime,
    this.calling,
    this.celebrity,
    this.messaging,
    this.secureAccount,
    double? rating,
    this.biography,
    this.childhoodRemember,
    this.coverPhoto,
    this.fatherName,
    Gender? gender,
    this.language,
    this.latitude,
    this.lifeStyle,
    this.longitude,
    this.maritalStatus,
    this.motherName,
    this.nationality,
    this.profession,
    this.profilePath,
    this.profileUrl,
    this.relationship,
    this.religion,
    this.secondaryEmail,
    this.secondaryPhone,
    this.title,
    this.website,
    this.approvals,
    this.favouritePlaces,
    this.followers,
    this.followings,
    this.hobbies,
    this.interestedChannels,
    this.interestedPlaces,
    this.interestedProfessions,
    this.secondaryLanguages,
    UserInfo? alternateInfo,
    UserInfo? primaryInfo,
    UserInfo? secondaryInfo,
  }) : _alternateInfo = alternateInfo,
       _gender = gender,
       _primaryInfo = primaryInfo,
       _rating = rating,
       _secondaryInfo = secondaryInfo;

  @override
  User copy({
    // PARENT
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
    // CHILD
    int? activeTime,
    int? birthday,
    int? joiningTime,
    double? rating,
    bool? calling,
    bool? celebrity,
    bool? messaging,
    bool? secureAccount,
    String? biography,
    String? childhoodRemember,
    String? coverPhoto,
    String? fatherName,
    Gender? gender,
    String? language,
    double? latitude,
    String? lifeStyle,
    double? longitude,
    String? maritalStatus,
    String? motherName,
    String? nationality,
    String? profession,
    String? profilePath,
    String? profileUrl,
    String? relationship,
    String? religion,
    String? secondaryEmail,
    String? secondaryPhone,
    String? title,
    String? website,
    List<String>? approvals,
    List<String>? favouritePlaces,
    List<String>? followers,
    List<String>? followings,
    List<String>? hobbies,
    List<String>? interestedChannels,
    List<String>? interestedPlaces,
    List<String>? interestedProfessions,
    List<String>? secondaryLanguages,
    UserInfo? alternateInfo,
    UserInfo? primaryInfo,
    UserInfo? secondaryInfo,
  }) {
    return User(
      // PARENT
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
      // CHILD
      calling: calling ?? this.calling,
      celebrity: celebrity ?? this.celebrity,
      messaging: messaging ?? this.messaging,
      secureAccount: secureAccount ?? this.secureAccount,
      activeTime: activeTime ?? this.activeTime,
      biography: biography ?? this.biography,
      birthday: birthday ?? this.birthday,
      childhoodRemember: childhoodRemember ?? this.childhoodRemember,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      fatherName: fatherName ?? this.fatherName,
      gender: gender ?? this.gender,
      joiningTime: joiningTime ?? this.joiningTime,
      language: language ?? this.language,
      latitude: latitude ?? this.latitude,
      lifeStyle: lifeStyle ?? this.lifeStyle,
      longitude: longitude ?? this.longitude,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      motherName: motherName ?? this.motherName,
      nationality: nationality ?? this.nationality,
      profession: profession ?? this.profession,
      profilePath: profilePath ?? this.profilePath,
      profileUrl: profileUrl ?? this.profileUrl,
      rating: rating ?? this.rating,
      relationship: relationship ?? this.relationship,
      religion: religion ?? this.religion,
      secondaryEmail: secondaryEmail ?? this.secondaryEmail,
      secondaryPhone: secondaryPhone ?? this.secondaryPhone,
      title: title ?? this.title,
      approvals: approvals ?? this.approvals,
      favouritePlaces: favouritePlaces ?? this.favouritePlaces,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
      hobbies: hobbies ?? this.hobbies,
      interestedChannels: interestedChannels ?? this.interestedChannels,
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
      // PARENT
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
      // CHILD
      activeTime: source.entityValue(UserKeys.i.activeTime),
      birthday: source.entityValue(UserKeys.i.birthday),
      joiningTime: source.entityValue(UserKeys.i.joiningTime),
      rating: source.entityValue(UserKeys.i.rating),
      calling: source.entityValue(UserKeys.i.calling),
      celebrity: source.entityValue(UserKeys.i.celebrity),
      messaging: source.entityValue(UserKeys.i.messaging),
      secureAccount: source.entityValue(UserKeys.i.secureAccount),
      biography: source.entityValue(UserKeys.i.biography),
      childhoodRemember: source.entityValue(UserKeys.i.childhoodRemember),
      coverPhoto: source.entityValue(UserKeys.i.coverPhoto),
      fatherName: source.entityValue(UserKeys.i.fatherName),
      gender: source.entityValue(UserKeys.i.gender, Gender.from),
      language: source.entityValue(UserKeys.i.language),
      latitude: source.entityValue(UserKeys.i.latitude),
      lifeStyle: source.entityValue(UserKeys.i.lifeStyle),
      longitude: source.entityValue(UserKeys.i.longitude),
      maritalStatus: source.entityValue(UserKeys.i.maritalStatus),
      motherName: source.entityValue(UserKeys.i.motherName),
      nationality: source.entityValue(UserKeys.i.nationality),
      profession: source.entityValue(UserKeys.i.profession),
      profilePath: source.entityValue(UserKeys.i.profilePath),
      profileUrl: source.entityValue(UserKeys.i.profileUrl),
      relationship: source.entityValue(UserKeys.i.relationship),
      religion: source.entityValue(UserKeys.i.religion),
      secondaryEmail: source.entityValue(UserKeys.i.secondaryEmail),
      secondaryPhone: source.entityValue(UserKeys.i.secondaryPhone),
      title: source.entityValue(UserKeys.i.title),
      website: source.entityValue(UserKeys.i.website),
      approvals: source.entityValues(UserKeys.i.approvals),
      favouritePlaces: source.entityValues(UserKeys.i.favouritePlaces),
      followers: source.entityValues(UserKeys.i.followers),
      followings: source.entityValues(UserKeys.i.followings),
      hobbies: source.entityValues(UserKeys.i.hobbies),
      interestedChannels: source.entityValues(UserKeys.i.interestedChannels),
      interestedPlaces: source.entityValues(UserKeys.i.interestedPlaces),
      interestedProfessions: source.entityValues(
        UserKeys.i.interestedProfessions,
      ),
      secondaryLanguages: source.entityValues(UserKeys.i.secondaryLanguages),
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
  bool isInsertable(String key, value) {
    return _keys.contains(key) && value != null;
  }

  @override
  Map<String, dynamic> get source {
    return super.source
        .set(UserKeys.i.activeTime, activeTime)
        .set(UserKeys.i.birthday, birthday)
        .set(UserKeys.i.joiningTime, joiningTime)
        .set(UserKeys.i.rating, rating)
        .set(UserKeys.i.calling, calling)
        .set(UserKeys.i.celebrity, celebrity)
        .set(UserKeys.i.messaging, messaging)
        .set(UserKeys.i.secureAccount, secureAccount)
        .set(UserKeys.i.verified, verified)
        .set(UserKeys.i.biography, biography)
        .set(UserKeys.i.childhoodRemember, childhoodRemember)
        .set(UserKeys.i.coverPhoto, coverPhoto)
        .set(UserKeys.i.fatherName, fatherName)
        .set(UserKeys.i.name, name)
        .set(UserKeys.i.gender, _gender?.name)
        .set(UserKeys.i.language, language)
        .set(UserKeys.i.latitude, latitude)
        .set(UserKeys.i.lifeStyle, lifeStyle)
        .set(UserKeys.i.longitude, longitude)
        .set(UserKeys.i.maritalStatus, maritalStatus)
        .set(UserKeys.i.motherName, motherName)
        .set(UserKeys.i.nationality, nationality)
        .set(UserKeys.i.profession, profession)
        .set(UserKeys.i.profilePath, profilePath)
        .set(UserKeys.i.profileUrl, profileUrl)
        .set(UserKeys.i.relationship, relationship)
        .set(UserKeys.i.religion, religion)
        .set(UserKeys.i.secondaryEmail, secondaryEmail)
        .set(UserKeys.i.secondaryPhone, secondaryPhone)
        .set(UserKeys.i.title, title)
        .set(UserKeys.i.approvals, approvals)
        .set(UserKeys.i.favouritePlaces, favouritePlaces)
        .set(UserKeys.i.followers, followers)
        .set(UserKeys.i.followings, followings)
        .set(UserKeys.i.hobbies, hobbies)
        .set(UserKeys.i.interestedChannels, interestedChannels)
        .set(UserKeys.i.interestedPlaces, interestedPlaces)
        .set(UserKeys.i.interestedProfessions, interestedProfessions)
        .set(UserKeys.i.secondaryLanguages, secondaryLanguages)
        .set(UserKeys.i.alternateInfo, _alternateInfo?.source)
        .set(UserKeys.i.primaryInfo, _primaryInfo?.source)
        .set(UserKeys.i.secondaryInfo, _secondaryInfo?.source);
  }
}

enum Gender {
  male("MALE", "Male"),
  female("FEMALE", "Female"),
  other("OTHER", "Other");

  final String name;
  final String value;

  const Gender(this.name, this.value);

  bool get isMale => this == male;

  bool get isFemale => this == female;

  bool get isOther => this == other;

  factory Gender.from(Object? value) {
    final name = (value is String ? value : "").toUpperCase();
    if (name == Gender.female.name) {
      return Gender.female;
    } else if (name == Gender.other.name) {
      return Gender.other;
    } else {
      return Gender.male;
    }
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
      if (address.source.isValid) UserKeys.i.address: _address,
      if (contact.source.isValid) UserKeys.i.contact: _contact,
    };
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
      if (area.isValid) UserKeys.i.area: area,
      if (city.isValid) UserKeys.i.city: city,
      if (country.isValid) UserKeys.i.country: country,
      if (countryCode.isValid) UserKeys.i.countryCode: countryCode,
      if (house.isValid) UserKeys.i.house: house,
      if (policeStation.isValid) UserKeys.i.policeStation: policeStation,
      if (postCode.isValid) UserKeys.i.postCode: postCode,
      if (road.isValid) UserKeys.i.road: road,
      if (section.isValid) UserKeys.i.section: section,
      if (state.isValid) UserKeys.i.state: state,
    };
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
      if (email.isValid) UserKeys.i.email: email,
      if (phone.isValid) UserKeys.i.phone: phone,
      if (website.isValid) UserKeys.i.website: website,
    };
  }
}
