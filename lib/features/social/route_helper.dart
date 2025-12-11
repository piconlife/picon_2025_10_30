import 'package:flutter/material.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../data/models/user.dart';
import '../../routes/paths.dart';

extension UserRouteHelper on BuildContext {
  Future<void> openUserProfile({String? uid, UserModel? user}) async {
    open(Routes.userProfile, args: {});
  }
}
