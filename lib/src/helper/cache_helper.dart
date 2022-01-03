import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool?> setString(
      {@required String? key, @required String? value}) async {
    return await sharedPreferences?.setString(key!, value!);
  }

  static getString(String key) => sharedPreferences?.getString(key);

  static Future<bool?> setStringList(
      {required String key, required List<String> value}) async {
    return await sharedPreferences?.setStringList(key, value);
  }

  static getStringList(String key) => sharedPreferences?.getStringList(key);

  static Future<bool>?  signOut() => sharedPreferences?.remove('uid');

  static Future<bool>? deleteModel() => sharedPreferences?.remove('user');
 

}
