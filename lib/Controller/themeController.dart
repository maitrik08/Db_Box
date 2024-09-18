import 'package:shared_preferences/shared_preferences.dart';

class PreferencesController {
  static Future<void> setTheme(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', isDark);
  }

  static Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkTheme') ?? false;
  }

  static Future<void> setIntroSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('introSeen', true);
  }

  static Future<bool> isIntroSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('introSeen') ?? false;
  }
}
