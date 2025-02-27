import 'package:reserv/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHelper {
  static final _api = ApiService.instance;
  static Future<void> toggleNotificationStatus(bool val) async {
    if (val) {
      await FirebaseMessaging.instance.getToken();
    } else {
      await FirebaseMessaging.instance.deleteToken();
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("notificationStatus", val);
  }

  static Future<bool> getinitialNotificationStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? notificatioStatus = prefs.getBool("notificationStatus");
    if (notificatioStatus != null) {
      return notificatioStatus;
    } else {
      return false;
    }
  }

  static Future<void> sendTokenToServer(String token) async {
    try {
      await _api.postRequest("", data: {"deviceId": token});
    } catch (e) {}
  }
}
