import 'package:shared_preferences/shared_preferences.dart';

class KSharedPreference {
  static const KEY_USER_ID = "KEY_USER_ID";
  static const KEY_USER_NAME = "KEY_USER_NAME";
  static const KEY_USER_EMAIL = "KEY_USER_EMAIL";
  static const KEY_USER_IMAGE_URL = "KEY_USER_IMAGE_URL";


  Future<bool> set(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value is int) {
      return prefs.setInt(key, value);
    } else if (value is String) {
      return prefs.setString(key, value);
    } else if (value is bool) {
      return prefs.setBool(key, value);
    } else if (value is double) {
      return prefs.setDouble(key, value);
    } else if (value is List) {
      return prefs.setStringList(key, value as List<String>);
    } else {
      return prefs.setString(key, value.toString());
    }
  }

  dynamic get(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);

  }
}

class GetKSPInstance {
  static KSharedPreference kSharedPreference = KSharedPreference();
}
