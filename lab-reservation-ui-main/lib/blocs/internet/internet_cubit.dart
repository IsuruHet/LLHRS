import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  InternetCubit() : super(const InternetState.initial());
  final InternetConnectionChecker _connectivity = InternetConnectionChecker();
  late StreamSubscription<InternetConnectionStatus> _subscription;

  void subcribeToInternet() {
    _subscription = _connectivity.onStatusChange.listen((event) {
      if (event == InternetConnectionStatus.connected) {
        emit(const InternetState.connected());
      } else {
        emit(const InternetState.disconnected());
      }
    });
  }

  void cancelSubscription() {
    _subscription.cancel();
  }
}
