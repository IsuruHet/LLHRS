import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';
import 'package:reserv/repositories/notificatio_repo.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository notificationRepository;
  NotificationCubit({required this.notificationRepository})
      : super(
          NotificationInitial(
            notificatioStatus:
                notificationRepository.getinitialNotificationStatus(),
          ),
        );
  void toggleNotification(bool val) async {
    emit(NotificationToggleState(notificatioStatus: val));
    await notificationRepository.toggleNotificationStatus(val);
  }

  void onTokenRefresh() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.onTokenRefresh.listen((newToken) async {
      await notificationRepository.sendTokenToServer(newToken);
    });
  }
}
