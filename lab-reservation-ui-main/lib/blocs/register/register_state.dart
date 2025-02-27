part of 'register_bloc.dart';

enum Status { inProgress, success, failure, ideal }

final class RegisterState {
  const RegisterState({this.status = Status.ideal, this.message = ""});
  final Status status;
  final String message;
  const RegisterState.inProgress(
      {this.status = Status.inProgress, this.message = ""});
  const RegisterState.success(
      {this.status = Status.success, required this.message});
  const RegisterState.failure(
      {this.status = Status.failure, required this.message});
  const RegisterState.ideal({this.status = Status.ideal, this.message = ""});
}
