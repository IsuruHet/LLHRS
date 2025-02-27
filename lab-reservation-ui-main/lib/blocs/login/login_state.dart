part of 'login_bloc.dart';

enum Status { inProgress, success, failure, ideal }

final class LoginState {
  const LoginState({this.status = Status.ideal, this.message = ""});
  final Status status;
  final String message;
  const LoginState.inProgress(
      {this.status = Status.inProgress, this.message = ""});
  const LoginState.success({this.status = Status.success, this.message = ""});
  const LoginState.failure(
      {this.status = Status.failure, required this.message});
  const LoginState.ideal({this.status = Status.ideal, this.message = ""});
}
