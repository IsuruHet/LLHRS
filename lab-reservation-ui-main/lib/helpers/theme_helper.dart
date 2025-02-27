import 'package:shared_preferences/shared_preferences.dart';

class ThemeHelper {
  static Future<void> toggleThemePreferece(bool val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("themeStatus", val);
  }

  static Future<bool> getinitialThemePreferece() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? themeStatus = prefs.getBool("themeStatus");
    if (themeStatus != null) {
      return themeStatus;
    } else {
      return false;
    }
  }
}
