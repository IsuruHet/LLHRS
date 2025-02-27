import 'package:reserv/helpers/notification_helper.dart';

class NotificationRepository {
  NotificationRepository({required this.notificatioStatus});
  final bool notificatioStatus;
  Future<void> toggleNotificationStatus(bool val) async {
    await NotificationHelper.toggleNotificationStatus(val);
  }

  bool getinitialNotificationStatus() {
    return notificatioStatus;
  }

  Future<void> sendTokenToServer(String token) async {
    await NotificationHelper.sendTokenToServer(token);
  }
}
