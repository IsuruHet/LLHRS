import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reserv/configs/strs.dart';
import 'package:reserv/repositories/authentication_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const RegisterState()) {
    on<RegisterSubmitted>(_onSubmitted);
    on<RegisterPageLeaveEvent>(_registerPageLeave);
  }
  final AuthenticationRepository _authenticationRepository;
  void _registerPageLeave(
    RegisterPageLeaveEvent event,
    Emitter<RegisterState> emit,
  ) {
    emit(const RegisterState.ideal());
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterState.inProgress());
    try {
      String roleEmail = lecEmail;
      if (event.role == "Student") {
        roleEmail = stuEmail;
      }
      await _authenticationRepository.register(
        userEmail: "${event.userEmail}$roleEmail",
        password: event.password,
        role: event.role,
        firstName: event.firstName,
        lastName: event.lastName,
      );

      emit(const RegisterState.success(
          message: "Registration success please check your email"));
    } catch (err) {
      emit(RegisterState.failure(message: err.toString()));
    }
  }
}
