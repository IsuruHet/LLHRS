part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user = User.empty,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated({required User user})
      : this._(status: AuthenticationStatus.authenticated, user: user);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);
  const AuthenticationState.inProgress()
      : this._(status: AuthenticationStatus.inProgress);

  final AuthenticationStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];
}
