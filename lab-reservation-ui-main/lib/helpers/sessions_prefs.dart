import 'dart:convert';

import 'package:reserv/configs/sessions_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionsPrefs {
  static Future<void> toggleSessionPrefStatus(FocusArea val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(val.toJson());
    await prefs.setString("area", jsonString);
  }

  static Future<FocusArea> getinitialSessionPrefStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('area');

    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString);
      return FocusArea.fromJson(jsonMap);
    }
    return FocusArea(areaLetter: "C", areaName: "Common");
  }

  static Future<void> resetSessionPrefStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(FocusArea.initFocusArea.toJson());
    await prefs.setString("area", jsonString);
  }
}
