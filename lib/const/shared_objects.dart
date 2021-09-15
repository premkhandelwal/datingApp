import 'package:dating_app/const/app_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedObjects {
  static CachedSharedPreference? prefs;
}

class CachedSharedPreference {
  static SharedPreferences? sharedPreferences;
  static CachedSharedPreference? instance;
  static final sessionKeyList = {
    SessionConstants.sessionUid,
    SessionConstants.sessionUsername,
    SessionConstants.sessionSignedInWith,
  };

  static Map<String, dynamic> map = Map();

  static Future<CachedSharedPreference?> getInstance() async {
    sharedPreferences = await SharedPreferences.getInstance();
    for (String key in sessionKeyList) {
      map[key] = sharedPreferences?.get(key);
    }
    if (instance == null) instance = CachedSharedPreference();
    return instance;
  }

  String? getString(String key) {
    if (sessionKeyList.contains(key)) {
      return map[key];
    }
    return sharedPreferences?.getString(key);
  }

  bool? getBool(String key) {
    if (sessionKeyList.contains(key)) {
      return map[key];
    }
    return sharedPreferences?.getBool(key);
  }

  Future<bool?>? setString(String key, String value) async {
    bool? result = await sharedPreferences?.setString(key, value);
    if (result != null && result) map[key] = value;
    return result;
  }

  Future<bool?>? setBool(String key, bool value) async {
    bool? result = await sharedPreferences?.setBool(key, value);
    if (result != null && result) map[key] = value;
    return result;
  }

  Future<void> clearAll() async {
    await sharedPreferences?.clear();
    SessionConstants.clear();
    map = Map();
  }

  Future<void> clearSession() async {
    await sharedPreferences?.remove(SessionConstants.sessionUsername);
    await sharedPreferences?.remove(SessionConstants.sessionUid);
    await sharedPreferences?.remove(SessionConstants.sessionSignedInWith);
    map.removeWhere((k, v) => (sessionKeyList.contains(k)));
  }
}
