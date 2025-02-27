part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

final class LoginUsernameChanged extends LoginEvent {
  const LoginUsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

final class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

final class LoginSubmitted extends LoginEvent {
  LoginSubmitted({required this.password, required this.userEmail});

  String userEmail;
  String password;
}

final class ForgotPasswordEvent extends LoginEvent {
  String uniEmail;
  ForgotPasswordEvent({required this.uniEmail});
}

final class FormResetEvent extends LoginEvent {
  const FormResetEvent();
}
