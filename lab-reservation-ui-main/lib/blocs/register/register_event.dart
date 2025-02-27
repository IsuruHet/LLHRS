part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

final class RegisterPageLeaveEvent extends RegisterEvent {}

final class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted({
    required this.password,
    required this.userEmail,
    required this.role,
    required this.firstName,
    required this.lastName,
  });

  final String userEmail;
  final String password;
  final String role;
  final String firstName;
  final String lastName;
}
