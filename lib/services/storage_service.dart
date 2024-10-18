import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_info.dart';

class StorageService {
  static const String userInfoKey = 'userInfo';

  static Future<UserInfo?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userInfoJson = prefs.getString(userInfoKey);
    return UserInfo.fromPrefs(userInfoJson);
  }

  static Future<void> saveUserInfo(UserInfo userInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userInfoKey, json.encode(userInfo.toJson()));
  }
}
