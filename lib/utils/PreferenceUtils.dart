import 'package:shared_preferences/shared_preferences.dart';

String keyUserId = "UserId";
String keyUserName = "UserName";
String keyUserEmail = "UserEmail";
String keyChatRoomId = "ChatRoomId";

class PreferenceUtils {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance!;
  }

  static String getString(String key) {
    return _prefsInstance != null ? (_prefsInstance!.getString(key) ?? "") : "";
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;
    return _prefsInstance != null
        ? prefs.setString(key, value)
        : Future.value(false);
  }
}
