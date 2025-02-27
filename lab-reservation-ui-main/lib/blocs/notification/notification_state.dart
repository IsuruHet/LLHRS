part of 'notification_cubit.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {
  final bool notificatioStatus;
  NotificationInitial({required this.notificatioStatus});
}

final class NotificationToggleState extends NotificationState {
  final bool notificatioStatus;
  NotificationToggleState({required this.notificatioStatus});
}
