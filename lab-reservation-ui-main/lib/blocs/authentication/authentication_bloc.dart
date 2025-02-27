import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reserv/models/user.dart';
import 'package:reserv/repositories/authentication_repository.dart';
import 'package:reserv/repositories/user_repo.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthenticationLogoutPressed>(_onLogoutPressed);
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  Future<void> _onSubscriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    return emit.onEach(
      _authenticationRepository.status,
      onData: (status) async {
        switch (status) {
          case AuthenticationStatus.unauthenticated:
            emit(const AuthenticationState.unauthenticated());
            break;
          case AuthenticationStatus.authenticated:
            final user = await _tryGetUser();
            emit(
              user != null
                  ? AuthenticationState.authenticated(user: user)
                  : const AuthenticationState.unauthenticated(),
            );
            await _tryAddModules();
            break;
          case AuthenticationStatus.unknown:
            emit(const AuthenticationState.unknown());
            break;
          case AuthenticationStatus.inProgress:
            emit(const AuthenticationState.inProgress());
            break;
        }
      },
      onError: addError,
    );
  }

  void _onLogoutPressed(
    AuthenticationLogoutPressed event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _authenticationRepository.logOut();
    await _userRepository.removeUserModules();
  }

  Future<User?> _tryGetUser() async {
    try {
      final user = await _userRepository.getUser();
      return user;
    } catch (err) {
      return null;
    }
  }

  Future<void> _tryAddModules() async {
    try {
      await _userRepository.addUserModules();
    } catch (err) {}
  }
}
