part of 'internet_cubit.dart';

enum InternetStatus {
  initial,
  connected,
  disconnected,
}

class InternetState extends Equatable {
  const InternetState.connected({this.status = InternetStatus.connected});
  const InternetState.disconnected({this.status = InternetStatus.disconnected});
  const InternetState.initial({this.status = InternetStatus.initial});

  final InternetStatus status;
  @override
  List<Object> get props => [status];
}
