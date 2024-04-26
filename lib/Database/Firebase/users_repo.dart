import 'dart:convert';
import 'package:flash/Constants/app_keys.dart';
import 'package:flash/Model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersRepo {
  Future saveCurrentUser(User user) async {
    final userJson = json.encode(user.toJson());
    await (await SharedPreferences.getInstance())
        .setString(AppKeys.userKey, userJson);
  }

  Future<User?> getCurrentUser() async {
    try {
      final userStr =
          (await SharedPreferences.getInstance()).getString(AppKeys.userKey);
      if (userStr != null) {
        final userMap = json.decode(userStr);
        return User.fromJson(userMap);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future forceLogout() async {
    await (await SharedPreferences.getInstance()).remove(AppKeys.userKey);
  }
}
