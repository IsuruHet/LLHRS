import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reserv/repositories/authentication_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<FormResetEvent>(_reset);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) {
    // final username = event.username;
    // emit(
    //   state.copyWith(
    //     username: username,
    //   ),
    // );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    // final password = event.password;
    // emit(
    //   state.copyWith(
    //     password: password,
    //   ),
    // );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginState.inProgress());
    try {
      await _authenticationRepository.logIn(
        userEmail: event.userEmail.toUpperCase(),
        password: event.password,
      );
      emit(const LoginState.success());
    } catch (err) {
      if (err is Exception) {
        final error = err.toString().replaceFirst("Exception:", '');
        emit(LoginState.failure(message: error));
      }
    }
  }

  Future<void> _onForgotPassword(
    ForgotPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(const LoginState.inProgress());

      await _authenticationRepository.forgotPassword(email: event.uniEmail);
      emit(const LoginState.success());
    } catch (err) {
      if (err is Exception) {
        final error = err.toString().replaceFirst("Exception:", '');

        emit(LoginState.failure(message: error));
      }
    }
  }

  Future<void> _reset(
    FormResetEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginState.ideal());
  }
}
