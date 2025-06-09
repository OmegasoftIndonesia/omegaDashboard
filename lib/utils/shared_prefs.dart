import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUtil {
  static PreferencesUtil? manager;
  static SharedPreferences? sharedPreferences;
  static const String email = "email";
  static const String kodestaff = "kodestaff";
  static const String branch = "branch";
  static const String cabang = "cabang";

  static Future<PreferencesUtil?> getInstance() async {
    manager ??= PreferencesUtil();
    sharedPreferences ??= await SharedPreferences.getInstance();

    return manager;
  }

  Future<bool> putBool(String key, bool value) =>
      sharedPreferences!.setBool(key, value);

  bool? getBool(String key) => sharedPreferences!.getBool(key);

  Future<bool> putDouble(String key, double value) =>
      sharedPreferences!.setDouble(key, value);

  double? getDouble(String key) => sharedPreferences!.getDouble(key);

  Future<bool> putInt(String key, int value) =>
      sharedPreferences!.setInt(key, value);

  int? getInt(String key) => sharedPreferences!.getInt(key);

  Future<bool> putString(String key, String value) =>
      sharedPreferences!.setString(key, value);

  String? getString(String key) => sharedPreferences!.getString(key);

  Future<bool> putStringList(String key, List<String> value) =>
      sharedPreferences!.setStringList(key, value);

  List<String>? getStringList(String key) =>
      sharedPreferences!.getStringList(key);

  bool? isKeyExists(String key) => sharedPreferences!.containsKey(key);

  Future<bool> clearKey(String key) => sharedPreferences!.remove(key);

  Future<bool> clearAll() => sharedPreferences!.clear();

  static void clearLogin() {
    sharedPreferences!.remove(PreferencesUtil.email);
  }
}
